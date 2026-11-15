import 'package:nabta/features/planner/domain/localized_text.dart';

/// Inclusive optimal range.
typedef ValueRange = ({double min, double max});

enum CropRole { nitrogenFixer, heavyFeeder, lightFeeder }

enum CropCategory { cereal, legume, rootTuber, vegetable, oilseed }

class Crop {
  const Crop({
    required this.id,
    required this.name,
    required this.emoji,
    required this.family,
    required this.category,
    required this.role,
    required this.ph,
    required this.temperatureC,
    required this.growingDays,
    required this.seasonalWaterMm,
    required this.nitrogenBalanceKgHa,
    required this.marketScore,
    required this.intensive,
    required this.note,
  });

  final String id;
  final LocalizedText name;
  final String emoji;

  /// Botanical family, e.g. "Fabaceae". Consecutive stages must differ.
  final String family;
  final CropCategory category;
  final CropRole role;
  final ValueRange ph;
  final ValueRange temperatureC;

  /// Days from sowing to harvest (≤ 180).
  final int growingDays;

  /// Water the crop needs over its season, in millimeters.
  final int seasonalWaterMm;

  /// Negative = consumes soil nitrogen, positive = fixes it (kg/ha).
  final int nitrogenBalanceKgHa;

  /// 0–100 baseline market appeal.
  final int marketScore;

  /// Labor/input-intensive crop that suits small plots.
  final bool intensive;
  final LocalizedText note;

  @override
  bool operator ==(Object other) => other is Crop && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
