import 'package:nabta/features/planner/domain/crop.dart';
import 'package:nabta/features/planner/domain/priority.dart';
import 'package:nabta/features/planner/domain/rotation.dart';

enum RangePosition { below, inside, above }

/// Pure scoring formulas. Every score is clamped to 0–100 and rounded.
abstract final class Scoring {
  static const double soilPenaltyPerPh = 30;
  static const double climatePenaltyPerDegree = 7;
  static const double selectedWeight = 1;
  static const double unselectedWeight = 0.25;
  static const double marketSizeAdjustment = 8;
  static const double smallPlotM2 = 2000;
  static const double largePlotM2 = 50000;
  static const double fixerBonusStep = 2.5;
  static const double maxFixerBonus = 5;

  static int clampScore(num value) => value.clamp(0, 100).round();

  static double distanceOutside(double value, ValueRange range) {
    if (value < range.min) return range.min - value;
    if (value > range.max) return value - range.max;
    return 0;
  }

  static RangePosition positionIn(double value, ValueRange range) {
    if (value < range.min) return RangePosition.below;
    if (value > range.max) return RangePosition.above;
    return RangePosition.inside;
  }

  /// 100 − 30 × (pH distance outside the crop's optimal range).
  static int soil(double ph, Crop crop) =>
      clampScore(100 - soilPenaltyPerPh * distanceOutside(ph, crop.ph));

  /// 100 − 7 × (°C distance outside the crop's optimal range).
  static int climate(double temperatureC, Crop crop) =>
      clampScore(100 - climatePenaltyPerDegree * distanceOutside(temperatureC, crop.temperatureC));

  /// 100 × (1 − (seasonalWaterMm − 200) / 1000).
  static int water(Crop crop) => clampScore(100 * (1 - (crop.seasonalWaterMm - 200) / 1000));

  /// 40 + 0.5 × nitrogenBalanceKgHa.
  static int nitrogen(Crop crop) => clampScore(40 + 0.5 * crop.nitrogenBalanceKgHa);

  /// Catalog value ± 8 by farm size: intensive crops gain on small plots
  /// and lose on large ones; non-intensive crops do the reverse.
  static int market(Crop crop, double areaM2) {
    final double adjustment;
    if (areaM2 < smallPlotM2) {
      adjustment = crop.intensive ? marketSizeAdjustment : -marketSizeAdjustment;
    } else if (areaM2 > largePlotM2) {
      adjustment = crop.intensive ? -marketSizeAdjustment : marketSizeAdjustment;
    } else {
      adjustment = 0;
    }
    return clampScore(crop.marketScore + adjustment);
  }

  static CropScores scoresFor(
    Crop crop, {
    required double ph,
    required double temperatureC,
    required double areaM2,
  }) {
    return CropScores(
      soil: soil(ph, crop),
      climate: climate(temperatureC, crop),
      water: water(crop),
      nitrogen: nitrogen(crop),
      market: market(crop, areaM2),
    );
  }

  /// Selected priorities weigh 1.0, the others 0.25, normalised to sum 1.
  static Map<Priority, double> weightsFor(Set<Priority> selected) => normalize({
        for (final priority in Priority.values)
          priority: selected.contains(priority) ? selectedWeight : unselectedWeight,
      });

  static Map<Priority, double> normalize(Map<Priority, double> raw) {
    final total = raw.values.fold(0.0, (sum, value) => sum + value);
    if (total <= 0) {
      return {for (final priority in Priority.values) priority: 1 / Priority.values.length};
    }
    return {for (final priority in Priority.values) priority: (raw[priority] ?? 0.0) / total};
  }

  static double weightedPriority(CropScores scores, Map<Priority, double> weights) =>
      Priority.values.fold(
        0.0,
        (sum, priority) => sum + (weights[priority] ?? 0.0) * scores.forPriority(priority),
      );

  /// 0.5 × mean(soil, climate) + 0.5 × weighted priority score.
  static double stageScore(CropScores scores, Map<Priority, double> weights) =>
      0.5 * (scores.soil + scores.climate) / 2 + 0.5 * weightedPriority(scores, weights);
}
