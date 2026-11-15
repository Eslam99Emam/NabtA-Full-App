import 'dart:async';
import 'dart:isolate';

import 'package:nabta/features/planner/data/crop_catalog.dart';
import 'package:nabta/features/planner/data/strategy_profiles.dart';
import 'package:nabta/features/planner/domain/land_input.dart';
import 'package:nabta/features/planner/domain/rotation.dart';
import 'package:nabta/features/planner/domain/rotation_engine.dart';
import 'package:nabta/features/planner/domain/rotation_repository.dart';

/// Runs the rotation engine on a background isolate. A short minimum delay
/// keeps the loading state readable instead of flashing.
class LocalRotationRepository implements RotationRepository {
  LocalRotationRepository({
    RotationEngine? engine,
    DateTime Function()? clock,
    this.minimumDelay = const Duration(milliseconds: 1500),
  })  : _engine = engine ??
            const RotationEngine(
              catalog: cropCatalog,
              profiles: strategyProfiles,
              fallbackProfile: alternativeProfile,
            ),
        _clock = clock ?? DateTime.now;

  final RotationEngine _engine;
  final DateTime Function() _clock;
  final Duration minimumDelay;

  @override
  Future<List<RotationStrategy>> recommend(LandInput input) async {
    final engine = _engine;
    final today = _clock();
    final (strategies, _) = await (
      Isolate.run(() => engine.recommend(input, today: today)),
      Future<void>.delayed(minimumDelay),
    ).wait;
    return strategies;
  }
}
