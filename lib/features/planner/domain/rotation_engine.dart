import 'dart:math' as math;

import 'package:nabta/features/planner/domain/climate_provider.dart';
import 'package:nabta/features/planner/domain/crop.dart';
import 'package:nabta/features/planner/domain/land_input.dart';
import 'package:nabta/features/planner/domain/priority.dart';
import 'package:nabta/features/planner/domain/rotation.dart';
import 'package:nabta/features/planner/domain/scoring.dart';
import 'package:nabta/features/planner/domain/season.dart';

typedef _Table = List<List<CropScores>>;

class _Pick {
  const _Pick(this.profile, this.sequence, this.fit);

  final StrategyProfile profile;
  final List<int> sequence;
  final double fit;
}

/// Deterministic, offline crop-rotation recommender.
///
/// Rules: no crop repeats; no botanical family in consecutive stages; a heavy
/// feeder never follows a heavy feeder; at least one nitrogen fixer. Crops
/// should reach soil ≥ 40 and climate ≥ 40 in their window; that floor is
/// relaxed step by step until at least [minStrategies] plans exist.
class RotationEngine {
  const RotationEngine({
    required this.catalog,
    required this.profiles,
    required this.fallbackProfile,
    this.climate = const LatitudeClimateProvider(),
    this.calendar = const SeasonCalendar(),
  });

  final List<Crop> catalog;

  /// Search profiles in order; the first should use the grower's weights.
  final List<StrategyProfile> profiles;

  /// Label for extra plans added only to reach [minStrategies].
  final StrategyProfile fallbackProfile;
  final ClimateProvider climate;
  final SeasonCalendar calendar;

  static const int stageCount = 4;
  static const int minStrategies = 3;
  static const int maxStrategies = 4;
  static const List<int> compatibilityFloors = [40, 25, 10, 0];
  static const double maxSharedCropRatio = 0.5;

  List<RotationStrategy> recommend(LandInput input, {required DateTime today}) {
    final windows = calendar.upcomingWindows(
      latitude: input.latitude,
      from: today,
      count: stageCount,
      climate: climate,
    );
    final _Table table = [
      for (final window in windows)
        [
          for (final crop in catalog)
            Scoring.scoresFor(crop,
                ph: input.ph, temperatureC: window.meanTemperatureC, areaM2: input.areaM2),
        ],
    ];
    final userWeights = Scoring.weightsFor(input.priorities);

    var picks = <_Pick>[];
    for (final floor in compatibilityFloors) {
      final candidate = _select(_enumerate(table, floor), table, userWeights);
      if (candidate.length > picks.length) picks = candidate;
      if (picks.length >= minStrategies) break;
    }

    final ordered = [for (var i = 0; i < picks.length; i++) (order: i, pick: picks[i])]
      ..sort((a, b) {
        final byFit = b.pick.fit.compareTo(a.pick.fit);
        return byFit != 0 ? byFit : a.order.compareTo(b.order);
      });

    return [
      for (final entry in ordered)
        RotationStrategy(
          profile: entry.pick.profile,
          stages: [
            for (var i = 0; i < entry.pick.sequence.length; i++)
              RotationStage(
                window: windows[i],
                crop: catalog[entry.pick.sequence[i]],
                scores: table[i][entry.pick.sequence[i]],
              ),
          ],
          fit: Scoring.clampScore(entry.pick.fit),
          waterDemandM3: _waterDemandM3(entry.pick.sequence, input.areaM2),
        ),
    ];
  }

  /// Whether [next] may directly follow [previous].
  static bool canFollow(Crop previous, Crop next) =>
      previous.family != next.family &&
      !(previous.role == CropRole.heavyFeeder && next.role == CropRole.heavyFeeder);

  List<List<int>> _enumerate(_Table table, int floor) {
    final allowed = [
      for (final row in table) [for (final s in row) s.soil >= floor && s.climate >= floor],
    ];
    final results = <List<int>>[];
    final current = <int>[];

    void visit() {
      final stage = current.length;
      if (stage == table.length) {
        if (current.any((i) => catalog[i].role == CropRole.nitrogenFixer)) {
          results.add(List<int>.unmodifiable(current));
        }
        return;
      }
      for (var c = 0; c < catalog.length; c++) {
        if (!allowed[stage][c] || current.contains(c)) continue;
        if (current.isNotEmpty && !canFollow(catalog[current.last], catalog[c])) continue;
        current.add(c);
        visit();
        current.removeLast();
      }
    }

    visit();
    return results;
  }

  List<_Pick> _select(List<List<int>> sequences, _Table table, Map<Priority, double> userWeights) {
    final picks = <_Pick>[];
    for (final profile in profiles) {
      if (picks.length >= maxStrategies) break;
      final raw = profile.weights;
      final weights = raw == null ? userWeights : Scoring.normalize(raw);
      for (final sequence in _rank(sequences, table, weights)) {
        if (_isDistinct(sequence, picks)) {
          picks.add(_Pick(profile, sequence, _fit(sequence, table, userWeights)));
          break;
        }
      }
    }
    if (picks.length < minStrategies) {
      for (final sequence in _rank(sequences, table, userWeights)) {
        if (picks.length >= minStrategies) break;
        if (_isDistinct(sequence, picks)) {
          picks.add(_Pick(fallbackProfile, sequence, _fit(sequence, table, userWeights)));
        }
      }
    }
    return picks;
  }

  List<List<int>> _rank(List<List<int>> sequences, _Table table, Map<Priority, double> weights) {
    final scored = [for (final s in sequences) (fit: _fit(s, table, weights), sequence: s)]
      ..sort((a, b) {
        final byFit = b.fit.compareTo(a.fit);
        return byFit != 0 ? byFit : _compareSequences(a.sequence, b.sequence);
      });
    return [for (final entry in scored) entry.sequence];
  }

  static int _compareSequences(List<int> a, List<int> b) {
    for (var i = 0; i < a.length; i++) {
      final order = a[i].compareTo(b[i]);
      if (order != 0) return order;
    }
    return 0;
  }

  bool _isDistinct(List<int> sequence, List<_Pick> picks) {
    for (final pick in picks) {
      final shared = sequence.where(pick.sequence.contains).length;
      if (shared / stageCount > maxSharedCropRatio) return false;
    }
    return true;
  }

  /// mean(stageScore) + up to +5 when a nitrogen fixer directly precedes a
  /// heavy feeder (+2.5 per occurrence), capped at 100.
  double _fit(List<int> sequence, _Table table, Map<Priority, double> weights) {
    var total = 0.0;
    var bonus = 0.0;
    for (var i = 0; i < sequence.length; i++) {
      total += Scoring.stageScore(table[i][sequence[i]], weights);
      if (i > 0 &&
          catalog[sequence[i - 1]].role == CropRole.nitrogenFixer &&
          catalog[sequence[i]].role == CropRole.heavyFeeder) {
        bonus += Scoring.fixerBonusStep;
      }
    }
    return math.min(100.0, total / sequence.length + math.min(Scoring.maxFixerBonus, bonus));
  }

  double _waterDemandM3(List<int> sequence, double areaM2) => sequence.fold(
        0.0,
        (sum, index) => sum + catalog[index].seasonalWaterMm * areaM2 / 1000,
      );
}
