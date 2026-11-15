/// One crop exactly as `POST /recommend` returns it. Only the fields the app
/// uses are kept; everything else in the JSON is ignored.
///
/// Parsing is forgiving about numbers (int, double or numeric string) and
/// about missing optional values, but throws [FormatException] when the
/// payload is not recognisable (e.g. no `ScientificName`).
class CropRecommendationDto {
  const CropRecommendationDto({
    required this.scientificName,
    required this.family,
    required this.commonNames,
    required this.category,
    required this.tempOptimalMin,
    required this.tempOptimalMax,
    required this.tempAbsoluteMin,
    required this.tempAbsoluteMax,
    required this.rainOptimalMin,
    required this.rainOptimalMax,
    required this.rainAbsoluteMin,
    required this.rainAbsoluteMax,
    required this.phOptimalMin,
    required this.phOptimalMax,
    required this.phAbsoluteMin,
    required this.phAbsoluteMax,
    required this.growingDaysMin,
    required this.growingDaysMax,
    required this.soilCompatibility,
    required this.marketSuitability,
    required this.nitrogenFixing,
    required this.waterUse,
    required this.overall,
  });

  factory CropRecommendationDto.fromJson(Map<String, dynamic> json) {
    final name = json['ScientificName'];
    if (name is! String || name.trim().isEmpty) {
      throw const FormatException('Crop entry has no ScientificName');
    }
    return CropRecommendationDto(
      scientificName: name.trim(),
      family: (json['FAMNAME'] as String?) ?? '',
      commonNames: (json['COMNAME'] as String?) ?? '',
      category: (json['CAT'] as String?) ?? '',
      tempOptimalMin: _number(json['TOPMN']),
      tempOptimalMax: _number(json['TOPMX']),
      tempAbsoluteMin: _number(json['TMIN']),
      tempAbsoluteMax: _number(json['TMAX']),
      rainOptimalMin: _number(json['ROPMN']),
      rainOptimalMax: _number(json['ROPMX']),
      rainAbsoluteMin: _number(json['RMIN']),
      rainAbsoluteMax: _number(json['RMAX']),
      phOptimalMin: _number(json['PHOPMN']),
      phOptimalMax: _number(json['PHOPMX']),
      phAbsoluteMin: _number(json['PHMIN']),
      phAbsoluteMax: _number(json['PHMAX']),
      growingDaysMin: _number(json['GMIN']),
      growingDaysMax: _number(json['GMAX']),
      soilCompatibility: _number(json['crop_to_soil_compatibility']) ?? 0,
      marketSuitability: _number(json['market_suitability_score']) ?? 0,
      nitrogenFixing: _number(json['nitrogen_fixing_score']) ?? 0,
      waterUse: _number(json['water_use_score']) ?? 0,
      overall: _number(json['overall_score']) ?? 0,
    );
  }

  final String scientificName;

  /// Colon-separated taxonomy, e.g. "Magnoliopsida:Asteridae:Solanales:Solanaceae".
  final String family;

  /// Comma-separated names in many languages; the first one is English.
  final String commonNames;

  /// Comma-separated EcoCrop categories, e.g. "roots/tubers, medicinals & aromatic".
  final String category;

  final double? tempOptimalMin;
  final double? tempOptimalMax;
  final double? tempAbsoluteMin;
  final double? tempAbsoluteMax;
  final double? rainOptimalMin;
  final double? rainOptimalMax;
  final double? rainAbsoluteMin;
  final double? rainAbsoluteMax;
  final double? phOptimalMin;
  final double? phOptimalMax;
  final double? phAbsoluteMin;
  final double? phAbsoluteMax;
  final double? growingDaysMin;
  final double? growingDaysMax;

  // All four scores and `overall` are 0–1.
  final double soilCompatibility;
  final double marketSuitability;
  final double nitrogenFixing;
  final double waterUse;
  final double overall;

  /// First English common name ("potato"), or null when the list is empty.
  String? get primaryCommonName {
    final first = commonNames.split(',').first.trim();
    return first.isEmpty ? null : first;
  }

  /// Last taxonomy segment ("Solanaceae"), or null when missing.
  String? get familyName {
    final last = family.split(':').last.trim();
    return last.isEmpty ? null : last;
  }

  static double? _number(Object? value) => switch (value) {
        num n => n.toDouble(),
        String s => double.tryParse(s.trim()),
        _ => null,
      };
}
