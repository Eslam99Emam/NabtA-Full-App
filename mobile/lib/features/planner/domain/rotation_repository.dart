import 'package:nabta/features/planner/domain/land_input.dart';
import 'package:nabta/features/planner/domain/rotation.dart';

/// Source of rotation plans. Today this runs on-device; a remote API can
/// implement the same contract without touching the UI.
abstract class RotationRepository {
  Future<List<RotationStrategy>> recommend(LandInput input);
}
