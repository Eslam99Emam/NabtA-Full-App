import 'package:nabta/features/planner/domain/priority.dart';

/// Everything the grower told us about their land.
class LandInput {
  const LandInput({
    required this.latitude,
    required this.longitude,
    required this.areaM2,
    required this.ph,
    required this.phAssumed,
    required this.priorities,
  });

  final double latitude;
  final double longitude;
  final double areaM2;
  final double ph;

  /// True when the grower tapped "I don't know my pH".
  final bool phAssumed;
  final Set<Priority> priorities;

  LandInput copyWith({
    double? latitude,
    double? longitude,
    double? areaM2,
    double? ph,
    bool? phAssumed,
    Set<Priority>? priorities,
  }) {
    return LandInput(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      areaM2: areaM2 ?? this.areaM2,
      ph: ph ?? this.ph,
      phAssumed: phAssumed ?? this.phAssumed,
      priorities: priorities ?? this.priorities,
    );
  }
}
