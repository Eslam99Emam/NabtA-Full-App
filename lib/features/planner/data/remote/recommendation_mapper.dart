import 'package:nabta/features/planner/data/crop_catalog.dart';
import 'package:nabta/features/planner/data/remote/crop_recommendation_dto.dart';
import 'package:nabta/features/planner/domain/climate_provider.dart';
import 'package:nabta/features/planner/domain/crop.dart';
import 'package:nabta/features/planner/domain/land_input.dart';
import 'package:nabta/features/planner/domain/localized_text.dart';
import 'package:nabta/features/planner/domain/rotation.dart';
import 'package:nabta/features/planner/domain/scoring.dart';
import 'package:nabta/features/planner/domain/season.dart';

/// Turns the crops returned by `POST /recommend` into the app's
/// [RotationStrategy] model, so the results UI needs no changes.
///
/// How the API response lines up with the UI models:
///
/// * The API returns a ranked list of crops. They become the stages of one
///   plan, in rank order, each placed in the next upcoming growing window.
/// * `crop_to_soil_compatibility`, `water_use_score`, `nitrogen_fixing_score`
///   and `market_suitability_score` (0–1) become the 0–100 soil / water /
///   nitrogen / market scores.
/// * The API has no climate score, so it is computed on the device from the
///   crop's optimal temperature range and the window's mean temperature.
/// * Plan fit is the mean of the crops' `overall_score`.
/// * Crop name (Arabic), emoji, note and feeder role come from the local
///   catalog when the API's English name matches one of its crops; otherwise
///   sensible defaults are used.
class RecommendationMapper {
  const RecommendationMapper({
    this.climate = const LatitudeClimateProvider(),
    this.calendar = const SeasonCalendar(),
  });

  final ClimateProvider climate;
  final SeasonCalendar calendar;

  /// Returns null when [items] is empty (nothing to show).
  RotationStrategy? toStrategy({
    required List<CropRecommendationDto> items,
    required LandInput input,
    required StrategyProfile profile,
    required DateTime today,
  }) {
    if (items.isEmpty) return null;

    final windows = calendar.upcomingWindows(
      latitude: input.latitude,
      from: today,
      count: items.length,
      climate: climate,
    );

    final stages = [
      for (var i = 0; i < items.length; i++)
        _stage(items[i], windows[i]),
    ];

    final meanOverall =
        items.fold(0.0, (sum, item) => sum + item.overall) / items.length;

    return RotationStrategy(
      profile: profile,
      stages: stages,
      fit: _percent(meanOverall),
      // Same formula as the local engine: Σ seasonalWaterMm × area_m² / 1000.
      waterDemandM3: stages.fold(
        0.0,
        (sum, stage) => sum + stage.crop.seasonalWaterMm * input.areaM2 / 1000,
      ),
    );
  }

  RotationStage _stage(CropRecommendationDto dto, StageWindow window) {
    final crop = _crop(dto);
    return RotationStage(
      window: window,
      crop: crop,
      scores: CropScores(
        soil: _percent(dto.soilCompatibility),
        climate: Scoring.climate(window.meanTemperatureC, crop),
        water: _percent(dto.waterUse),
        nitrogen: _percent(dto.nitrogenFixing),
        market: _percent(dto.marketSuitability),
      ),
    );
  }

  Crop _crop(CropRecommendationDto dto) {
    final english = dto.primaryCommonName ?? dto.scientificName;
    final known = _catalogByName[english.toLowerCase()];
    final category = known?.category ?? _category(dto.category);

    final CropRole role;
    if (dto.nitrogenFixing >= 0.5) {
      role = CropRole.nitrogenFixer;
    } else if (known?.role == CropRole.heavyFeeder) {
      role = CropRole.heavyFeeder;
    } else {
      // The API does not say how hungry a crop is; assume the gentler case.
      role = CropRole.lightFeeder;
    }

    final displayName = _titleCase(english);
    return Crop(
      id: dto.scientificName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_'),
      name: known?.name ?? LocalizedText(en: displayName, ar: displayName),
      emoji: known?.emoji ?? _emojiFor(category),
      family: dto.familyName ?? dto.scientificName,
      category: category,
      role: role,
      ph: (
        min: dto.phOptimalMin ?? dto.phAbsoluteMin ?? 0,
        max: dto.phOptimalMax ?? dto.phAbsoluteMax ?? 0,
      ),
      temperatureC: (
        min: dto.tempOptimalMin ?? dto.tempAbsoluteMin ?? 0,
        max: dto.tempOptimalMax ?? dto.tempAbsoluteMax ?? 0,
      ),
      growingDays: _midpoint(dto.growingDaysMin, dto.growingDaysMax),
      // Optimal rainfall is the closest thing the API gives to seasonal water need.
      seasonalWaterMm: _midpoint(
        dto.rainOptimalMin ?? dto.rainAbsoluteMin,
        dto.rainOptimalMax ?? dto.rainAbsoluteMax,
      ),
      // Not provided by the API and not read for remote results (the scores
      // come from the API), so these are neutral placeholders.
      nitrogenBalanceKgHa: 0,
      marketScore: _percent(dto.marketSuitability),
      intensive: false,
      note: known?.note ?? _genericNote,
    );
  }

  static const LocalizedText _genericNote = LocalizedText(
    en: 'Suited to your soil and climate.',
    ar: 'مناسب لتربتك ومناخك.',
  );

  static final Map<String, Crop> _catalogByName = {
    for (final crop in cropCatalog) crop.name.en.toLowerCase(): crop,
  };

  /// EcoCrop's CAT can list several categories ("roots/tubers, medicinals &
  /// aromatic"); the first one the app knows wins.
  static CropCategory _category(String raw) {
    for (final part in raw.toLowerCase().split(',')) {
      if (part.contains('cereal')) return CropCategory.cereal;
      if (part.contains('legume') || part.contains('pulse')) return CropCategory.legume;
      if (part.contains('root') || part.contains('tuber')) return CropCategory.rootTuber;
      if (part.contains('vegetable')) return CropCategory.vegetable;
      if (part.contains('oil')) return CropCategory.oilseed;
      if (part.contains('fruit') || part.contains('nut')) return CropCategory.fruitNut;
    }
    return CropCategory.other;
  }

  static String _emojiFor(CropCategory category) => switch (category) {
        CropCategory.cereal => '🌾',
        CropCategory.legume => '🫘',
        CropCategory.rootTuber => '🥔',
        CropCategory.vegetable => '🥬',
        CropCategory.oilseed => '🌻',
        CropCategory.fruitNut => '🌴',
        CropCategory.other => '🌱',
      };

  static int _percent(double fraction) => Scoring.clampScore(fraction * 100);

  static int _midpoint(double? min, double? max) {
    final lo = min ?? max ?? 0;
    final hi = max ?? min ?? 0;
    return ((lo + hi) / 2).round();
  }

  static String _titleCase(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}
