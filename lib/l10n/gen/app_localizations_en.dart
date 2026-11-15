// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NabtA';

  @override
  String get brandStem => 'Nabt';

  @override
  String get brandTail => 'A';

  @override
  String get languageToggleLabel => 'العربية';

  @override
  String get languageToggleTooltip => 'Switch the app to Arabic';

  @override
  String get themeToDarkTooltip => 'Switch to dark mode';

  @override
  String get themeToLightTooltip => 'Switch to light mode';

  @override
  String get inputTitle => 'Describe your land';

  @override
  String get inputSubtitle =>
      'Four quick steps, then we suggest crop rotations that suit your field.';

  @override
  String stepNumberSemantics(String number) {
    return 'Step $number';
  }

  @override
  String get locationTitle => 'Land location';

  @override
  String get locationHelper => 'Pin your field so we can estimate its climate.';

  @override
  String get mapPreviewEmpty => 'Tap to pin your land on the map';

  @override
  String get mapPreviewEmptySemantics =>
      'No location yet. Opens the map to pin your land.';

  @override
  String mapPreviewPinnedSemantics(String coordinates) {
    return 'Map preview with your pin at $coordinates. Opens the map to change it.';
  }

  @override
  String get latitudeLabel => 'Latitude';

  @override
  String get longitudeLabel => 'Longitude';

  @override
  String get coordinatesHelper =>
      'Tip: paste both numbers, like 30.0444, 31.2357, into either box.';

  @override
  String coordinatesPair(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String coordinatesSemantics(String latitude, String longitude) {
    return 'Latitude $latitude, longitude $longitude';
  }

  @override
  String get pickOnMap => 'Pick on map';

  @override
  String get useMyLocation => 'Use my location';

  @override
  String get locating => 'Finding you…';

  @override
  String get locationSetSnack => 'Your location is pinned.';

  @override
  String get errorLocationMissing =>
      'Pin your land on the map, or type its coordinates.';

  @override
  String errorNotANumber(String example) {
    return 'Type a number, for example $example.';
  }

  @override
  String errorLatitudeRange(String min, String max) {
    return 'Latitude must be between $min and $max.';
  }

  @override
  String errorLongitudeRange(String min, String max) {
    return 'Longitude must be between $min and $max.';
  }

  @override
  String get areaTitle => 'Farm size';

  @override
  String get areaHelper =>
      'In square meters. Tap a common size or type your own.';

  @override
  String get areaLabel => 'Area';

  @override
  String get areaUnit => 'm²';

  @override
  String areaWithUnit(String value) {
    return '$value m²';
  }

  @override
  String areaEquivalents(String hectares, String secondary) {
    return '≈ $hectares ha · $secondary acres';
  }

  @override
  String get errorAreaMissing => 'Enter your farm size.';

  @override
  String errorAreaRange(String max) {
    return 'Size must be above 0 and no more than $max m².';
  }

  @override
  String get phTitle => 'Soil pH';

  @override
  String phHelper(String neutral) {
    return 'How acidic or alkaline your soil is. $neutral means neutral.';
  }

  @override
  String get phAcidic => 'Acidic';

  @override
  String get phSlightlyAcidic => 'Slightly acidic';

  @override
  String get phNeutral => 'Neutral';

  @override
  String get phSlightlyAlkaline => 'Slightly alkaline';

  @override
  String get phAlkaline => 'Alkaline';

  @override
  String get phTapToType => 'Tap the number to type it';

  @override
  String phValueSemantics(String value, String label) {
    return 'Soil pH $value, $label. Opens a box to type a value.';
  }

  @override
  String get phSliderLabel => 'Soil pH slider';

  @override
  String get phDialogTitle => 'Enter soil pH';

  @override
  String phDialogHint(String min, String max) {
    return 'Between $min and $max';
  }

  @override
  String phDialogError(String min, String max) {
    return 'Enter a value between $min and $max.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get phUnknownChip => 'I don\'t know my pH';

  @override
  String phAssumedHelper(String value) {
    return 'Using a typical $value. A soil test gives sharper results.';
  }

  @override
  String get prioritiesTitle => 'Your priorities';

  @override
  String get prioritiesHelper =>
      'Choose what matters most to you. You can pick more than one.';

  @override
  String get priorityWaterTitle => 'Water conserving';

  @override
  String get priorityWaterDescription => 'Crops that need less irrigation.';

  @override
  String get priorityWaterShort => 'Water';

  @override
  String get priorityNitrogenTitle => 'Nitrogen-fixing potential';

  @override
  String get priorityNitrogenDescription =>
      'Crops that feed your soil naturally.';

  @override
  String get priorityNitrogenShort => 'Nitrogen';

  @override
  String get priorityMarketTitle => 'Market suitability';

  @override
  String get priorityMarketDescription => 'Crops that are likely to sell well.';

  @override
  String get priorityMarketShort => 'Market';

  @override
  String get errorPrioritiesEmpty => 'Choose at least one priority.';

  @override
  String get getPlans => 'Get rotation plans';

  @override
  String stepsNeedAttention(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countText steps need your attention',
      one: '$countText step needs your attention',
    );
    return '$_temp0';
  }

  @override
  String get mapTitle => 'Pin your land';

  @override
  String get mapInstruction => 'Move the map until the pin sits on your field.';

  @override
  String get confirmLocation => 'Confirm location';

  @override
  String get zoomIn => 'Zoom in';

  @override
  String get zoomOut => 'Zoom out';

  @override
  String get goToMyLocation => 'Go to my location';

  @override
  String get mapAttribution => 'OpenStreetMap contributors';

  @override
  String get mapTilesFailed =>
      'Map images can\'t load right now. You can still place the pin or type coordinates.';

  @override
  String get locationServiceOff =>
      'Location is turned off. Turn it on to find your field.';

  @override
  String get locationDenied =>
      'We need location permission to find you. You can also pick on the map.';

  @override
  String get locationDeniedForever =>
      'Location permission is blocked. Allow it in Settings to use this.';

  @override
  String get locationUnavailable =>
      'We couldn\'t find your location. Try again or pick on the map.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get resultsTitle => 'Your rotation plans';

  @override
  String get editInputs => 'Edit';

  @override
  String summaryPh(String value) {
    return 'pH $value';
  }

  @override
  String phAssumedNote(String value) {
    return 'We assumed a typical soil pH of $value. A simple soil test will make these plans more accurate.';
  }

  @override
  String get tipAcidic =>
      'Your soil is quite acidic. Spreading agricultural lime a few weeks before planting raises the pH and helps most crops.';

  @override
  String get tipAlkaline =>
      'Your soil is quite alkaline. Working in compost or well-rotted manure, plus elemental sulfur, gently lowers the pH.';

  @override
  String get loadingSoil => 'Reading your soil…';

  @override
  String get loadingClimate => 'Checking the climate…';

  @override
  String get loadingRotations => 'Building rotations…';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorBody => 'We couldn\'t build your plans. Please try again.';

  @override
  String get retry => 'Try again';

  @override
  String plansCount(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countText plans, best match first',
      one: '$countText plan for your land',
    );
    return '$_temp0';
  }

  @override
  String get bestMatch => 'Best match';

  @override
  String get fitCaption => 'fit';

  @override
  String fitSemantics(String percent) {
    return 'Overall fit $percent';
  }

  @override
  String stagesCount(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countText stages',
      one: '$countText stage',
    );
    return '$_temp0';
  }

  @override
  String waterDemand(String value) {
    return '≈ $value m³ water';
  }

  @override
  String waterDemandSemantics(String value) {
    return 'About $value cubic meters of water for the whole rotation';
  }

  @override
  String get showCrops => 'Show crops';

  @override
  String get hideCrops => 'Hide crops';

  @override
  String stageLabel(String number, String season, String months) {
    return 'Stage $number · $season · $months';
  }

  @override
  String get seasonWarm => 'Warm season';

  @override
  String get seasonCool => 'Cool season';

  @override
  String monthRange(String start, String end) {
    return '$start–$end';
  }

  @override
  String get categoryCereal => 'Cereal';

  @override
  String get categoryLegume => 'Legume';

  @override
  String get categoryRootTuber => 'Root crop';

  @override
  String get categoryVegetable => 'Vegetable';

  @override
  String get categoryOilseed => 'Oilseed';

  @override
  String get categoryFruitNut => 'Fruit & nut';

  @override
  String get categoryOther => 'Other crop';

  @override
  String get roleNitrogenFixer => 'fixes nitrogen';

  @override
  String get roleHeavyFeeder => 'heavy feeder';

  @override
  String get roleLightFeeder => 'light feeder';

  @override
  String roleLine(String category, String role) {
    return '$category · $role';
  }

  @override
  String growingDays(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '~$countText days',
      one: '~$countText day',
    );
    return '$_temp0';
  }

  @override
  String get compatSoilShort => 'Soil';

  @override
  String get compatClimateShort => 'Climate';

  @override
  String compatBadgeSemantics(String soil, String climate) {
    return 'Soil fit $soil, climate fit $climate. Opens details.';
  }

  @override
  String compatSheetTitle(String crop) {
    return 'How well $crop fits';
  }

  @override
  String compatSoilHeading(String percent) {
    return 'Soil fit · $percent';
  }

  @override
  String compatClimateHeading(String percent) {
    return 'Climate fit · $percent';
  }

  @override
  String soilInside(String ph, String min, String max) {
    return 'Your pH $ph is inside this crop\'s ideal range $min–$max.';
  }

  @override
  String soilBelow(String ph, String min, String max) {
    return 'Your pH $ph is below this crop\'s ideal range $min–$max, so the soil is a little too acidic for it.';
  }

  @override
  String soilAbove(String ph, String min, String max) {
    return 'Your pH $ph is above this crop\'s ideal range $min–$max, so the soil is a little too alkaline for it.';
  }

  @override
  String climateInside(
    String season,
    String temperature,
    String min,
    String max,
  ) {
    return '$season here averages about $temperature °C, inside this crop\'s comfortable range of $min–$max °C.';
  }

  @override
  String climateBelow(
    String season,
    String temperature,
    String min,
    String max,
  ) {
    return '$season here averages about $temperature °C, colder than this crop\'s comfortable range of $min–$max °C.';
  }

  @override
  String climateAbove(
    String season,
    String temperature,
    String min,
    String max,
  ) {
    return '$season here averages about $temperature °C, warmer than this crop\'s comfortable range of $min–$max °C.';
  }

  @override
  String get compatColorKey =>
      'Green means a good fit, amber means workable, and red means risky.';

  @override
  String get gotIt => 'Got it';

  @override
  String metricSemantics(String label, String percent) {
    return '$label, $percent';
  }

  @override
  String get disclaimer =>
      'Estimates for planning only. Confirm with a local agronomist or a soil test.';
}
