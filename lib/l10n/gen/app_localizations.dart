import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'NabtA'**
  String get appTitle;

  /// No description provided for @brandStem.
  ///
  /// In en, this message translates to:
  /// **'Nabt'**
  String get brandStem;

  /// No description provided for @brandTail.
  ///
  /// In en, this message translates to:
  /// **'A'**
  String get brandTail;

  /// No description provided for @languageToggleLabel.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageToggleLabel;

  /// No description provided for @languageToggleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch the app to Arabic'**
  String get languageToggleTooltip;

  /// No description provided for @themeToDarkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark mode'**
  String get themeToDarkTooltip;

  /// No description provided for @themeToLightTooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch to light mode'**
  String get themeToLightTooltip;

  /// No description provided for @inputTitle.
  ///
  /// In en, this message translates to:
  /// **'Describe your land'**
  String get inputTitle;

  /// No description provided for @inputSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Four quick steps, then we suggest crop rotations that suit your field.'**
  String get inputSubtitle;

  /// No description provided for @stepNumberSemantics.
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String stepNumberSemantics(String number);

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Land location'**
  String get locationTitle;

  /// No description provided for @locationHelper.
  ///
  /// In en, this message translates to:
  /// **'Pin your field so we can estimate its climate.'**
  String get locationHelper;

  /// No description provided for @mapPreviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Tap to pin your land on the map'**
  String get mapPreviewEmpty;

  /// No description provided for @mapPreviewEmptySemantics.
  ///
  /// In en, this message translates to:
  /// **'No location yet. Opens the map to pin your land.'**
  String get mapPreviewEmptySemantics;

  /// No description provided for @mapPreviewPinnedSemantics.
  ///
  /// In en, this message translates to:
  /// **'Map preview with your pin at {coordinates}. Opens the map to change it.'**
  String mapPreviewPinnedSemantics(String coordinates);

  /// No description provided for @latitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitudeLabel;

  /// No description provided for @longitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitudeLabel;

  /// No description provided for @coordinatesHelper.
  ///
  /// In en, this message translates to:
  /// **'Tip: paste both numbers, like 30.0444, 31.2357, into either box.'**
  String get coordinatesHelper;

  /// No description provided for @coordinatesPair.
  ///
  /// In en, this message translates to:
  /// **'{latitude}, {longitude}'**
  String coordinatesPair(String latitude, String longitude);

  /// No description provided for @coordinatesSemantics.
  ///
  /// In en, this message translates to:
  /// **'Latitude {latitude}, longitude {longitude}'**
  String coordinatesSemantics(String latitude, String longitude);

  /// No description provided for @pickOnMap.
  ///
  /// In en, this message translates to:
  /// **'Pick on map'**
  String get pickOnMap;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Finding you…'**
  String get locating;

  /// No description provided for @locationSetSnack.
  ///
  /// In en, this message translates to:
  /// **'Your location is pinned.'**
  String get locationSetSnack;

  /// No description provided for @errorLocationMissing.
  ///
  /// In en, this message translates to:
  /// **'Pin your land on the map, or type its coordinates.'**
  String get errorLocationMissing;

  /// No description provided for @errorNotANumber.
  ///
  /// In en, this message translates to:
  /// **'Type a number, for example {example}.'**
  String errorNotANumber(String example);

  /// No description provided for @errorLatitudeRange.
  ///
  /// In en, this message translates to:
  /// **'Latitude must be between {min} and {max}.'**
  String errorLatitudeRange(String min, String max);

  /// No description provided for @errorLongitudeRange.
  ///
  /// In en, this message translates to:
  /// **'Longitude must be between {min} and {max}.'**
  String errorLongitudeRange(String min, String max);

  /// No description provided for @areaTitle.
  ///
  /// In en, this message translates to:
  /// **'Farm size'**
  String get areaTitle;

  /// No description provided for @areaHelper.
  ///
  /// In en, this message translates to:
  /// **'In square meters. Tap a common size or type your own.'**
  String get areaHelper;

  /// No description provided for @areaLabel.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get areaLabel;

  /// No description provided for @areaUnit.
  ///
  /// In en, this message translates to:
  /// **'m²'**
  String get areaUnit;

  /// No description provided for @areaWithUnit.
  ///
  /// In en, this message translates to:
  /// **'{value} m²'**
  String areaWithUnit(String value);

  /// No description provided for @areaEquivalents.
  ///
  /// In en, this message translates to:
  /// **'≈ {hectares} ha · {secondary} acres'**
  String areaEquivalents(String hectares, String secondary);

  /// No description provided for @errorAreaMissing.
  ///
  /// In en, this message translates to:
  /// **'Enter your farm size.'**
  String get errorAreaMissing;

  /// No description provided for @errorAreaRange.
  ///
  /// In en, this message translates to:
  /// **'Size must be above 0 and no more than {max} m².'**
  String errorAreaRange(String max);

  /// No description provided for @phTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil pH'**
  String get phTitle;

  /// No description provided for @phHelper.
  ///
  /// In en, this message translates to:
  /// **'How acidic or alkaline your soil is. {neutral} means neutral.'**
  String phHelper(String neutral);

  /// No description provided for @phAcidic.
  ///
  /// In en, this message translates to:
  /// **'Acidic'**
  String get phAcidic;

  /// No description provided for @phSlightlyAcidic.
  ///
  /// In en, this message translates to:
  /// **'Slightly acidic'**
  String get phSlightlyAcidic;

  /// No description provided for @phNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get phNeutral;

  /// No description provided for @phSlightlyAlkaline.
  ///
  /// In en, this message translates to:
  /// **'Slightly alkaline'**
  String get phSlightlyAlkaline;

  /// No description provided for @phAlkaline.
  ///
  /// In en, this message translates to:
  /// **'Alkaline'**
  String get phAlkaline;

  /// No description provided for @phTapToType.
  ///
  /// In en, this message translates to:
  /// **'Tap the number to type it'**
  String get phTapToType;

  /// No description provided for @phValueSemantics.
  ///
  /// In en, this message translates to:
  /// **'Soil pH {value}, {label}. Opens a box to type a value.'**
  String phValueSemantics(String value, String label);

  /// No description provided for @phSliderLabel.
  ///
  /// In en, this message translates to:
  /// **'Soil pH slider'**
  String get phSliderLabel;

  /// No description provided for @phDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter soil pH'**
  String get phDialogTitle;

  /// No description provided for @phDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Between {min} and {max}'**
  String phDialogHint(String min, String max);

  /// No description provided for @phDialogError.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between {min} and {max}.'**
  String phDialogError(String min, String max);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @phUnknownChip.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know my pH'**
  String get phUnknownChip;

  /// No description provided for @phAssumedHelper.
  ///
  /// In en, this message translates to:
  /// **'Using a typical {value}. A soil test gives sharper results.'**
  String phAssumedHelper(String value);

  /// No description provided for @prioritiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your priorities'**
  String get prioritiesTitle;

  /// No description provided for @prioritiesHelper.
  ///
  /// In en, this message translates to:
  /// **'Choose what matters most to you. You can pick more than one.'**
  String get prioritiesHelper;

  /// No description provided for @priorityWaterTitle.
  ///
  /// In en, this message translates to:
  /// **'Water conserving'**
  String get priorityWaterTitle;

  /// No description provided for @priorityWaterDescription.
  ///
  /// In en, this message translates to:
  /// **'Crops that need less irrigation.'**
  String get priorityWaterDescription;

  /// No description provided for @priorityWaterShort.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get priorityWaterShort;

  /// No description provided for @priorityNitrogenTitle.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen-fixing potential'**
  String get priorityNitrogenTitle;

  /// No description provided for @priorityNitrogenDescription.
  ///
  /// In en, this message translates to:
  /// **'Crops that feed your soil naturally.'**
  String get priorityNitrogenDescription;

  /// No description provided for @priorityNitrogenShort.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen'**
  String get priorityNitrogenShort;

  /// No description provided for @priorityMarketTitle.
  ///
  /// In en, this message translates to:
  /// **'Market suitability'**
  String get priorityMarketTitle;

  /// No description provided for @priorityMarketDescription.
  ///
  /// In en, this message translates to:
  /// **'Crops that are likely to sell well.'**
  String get priorityMarketDescription;

  /// No description provided for @priorityMarketShort.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get priorityMarketShort;

  /// No description provided for @errorPrioritiesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one priority.'**
  String get errorPrioritiesEmpty;

  /// No description provided for @getPlans.
  ///
  /// In en, this message translates to:
  /// **'Get rotation plans'**
  String get getPlans;

  /// No description provided for @stepsNeedAttention.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{countText} step needs your attention} other{{countText} steps need your attention}}'**
  String stepsNeedAttention(int count, String countText);

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Pin your land'**
  String get mapTitle;

  /// No description provided for @mapInstruction.
  ///
  /// In en, this message translates to:
  /// **'Move the map until the pin sits on your field.'**
  String get mapInstruction;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm location'**
  String get confirmLocation;

  /// No description provided for @zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get zoomIn;

  /// No description provided for @zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get zoomOut;

  /// No description provided for @goToMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Go to my location'**
  String get goToMyLocation;

  /// No description provided for @mapAttribution.
  ///
  /// In en, this message translates to:
  /// **'OpenStreetMap contributors'**
  String get mapAttribution;

  /// No description provided for @mapTilesFailed.
  ///
  /// In en, this message translates to:
  /// **'Map images can\'t load right now. You can still place the pin or type coordinates.'**
  String get mapTilesFailed;

  /// No description provided for @locationServiceOff.
  ///
  /// In en, this message translates to:
  /// **'Location is turned off. Turn it on to find your field.'**
  String get locationServiceOff;

  /// No description provided for @locationDenied.
  ///
  /// In en, this message translates to:
  /// **'We need location permission to find you. You can also pick on the map.'**
  String get locationDenied;

  /// No description provided for @locationDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission is blocked. Allow it in Settings to use this.'**
  String get locationDeniedForever;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find your location. Try again or pick on the map.'**
  String get locationUnavailable;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @resultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your rotation plans'**
  String get resultsTitle;

  /// No description provided for @editInputs.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editInputs;

  /// No description provided for @summaryPh.
  ///
  /// In en, this message translates to:
  /// **'pH {value}'**
  String summaryPh(String value);

  /// No description provided for @phAssumedNote.
  ///
  /// In en, this message translates to:
  /// **'We assumed a typical soil pH of {value}. A simple soil test will make these plans more accurate.'**
  String phAssumedNote(String value);

  /// No description provided for @tipAcidic.
  ///
  /// In en, this message translates to:
  /// **'Your soil is quite acidic. Spreading agricultural lime a few weeks before planting raises the pH and helps most crops.'**
  String get tipAcidic;

  /// No description provided for @tipAlkaline.
  ///
  /// In en, this message translates to:
  /// **'Your soil is quite alkaline. Working in compost or well-rotted manure, plus elemental sulfur, gently lowers the pH.'**
  String get tipAlkaline;

  /// No description provided for @loadingSoil.
  ///
  /// In en, this message translates to:
  /// **'Reading your soil…'**
  String get loadingSoil;

  /// No description provided for @loadingClimate.
  ///
  /// In en, this message translates to:
  /// **'Checking the climate…'**
  String get loadingClimate;

  /// No description provided for @loadingRotations.
  ///
  /// In en, this message translates to:
  /// **'Building rotations…'**
  String get loadingRotations;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorBody.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t build your plans. Please try again.'**
  String get errorBody;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @plansCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{countText} plan for your land} other{{countText} plans, best match first}}'**
  String plansCount(int count, String countText);

  /// No description provided for @bestMatch.
  ///
  /// In en, this message translates to:
  /// **'Best match'**
  String get bestMatch;

  /// No description provided for @fitCaption.
  ///
  /// In en, this message translates to:
  /// **'fit'**
  String get fitCaption;

  /// No description provided for @fitSemantics.
  ///
  /// In en, this message translates to:
  /// **'Overall fit {percent}'**
  String fitSemantics(String percent);

  /// No description provided for @stagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{countText} stage} other{{countText} stages}}'**
  String stagesCount(int count, String countText);

  /// No description provided for @waterDemand.
  ///
  /// In en, this message translates to:
  /// **'≈ {value} m³ water'**
  String waterDemand(String value);

  /// No description provided for @waterDemandSemantics.
  ///
  /// In en, this message translates to:
  /// **'About {value} cubic meters of water for the whole rotation'**
  String waterDemandSemantics(String value);

  /// No description provided for @showCrops.
  ///
  /// In en, this message translates to:
  /// **'Show crops'**
  String get showCrops;

  /// No description provided for @hideCrops.
  ///
  /// In en, this message translates to:
  /// **'Hide crops'**
  String get hideCrops;

  /// No description provided for @stageLabel.
  ///
  /// In en, this message translates to:
  /// **'Stage {number} · {season} · {months}'**
  String stageLabel(String number, String season, String months);

  /// No description provided for @seasonWarm.
  ///
  /// In en, this message translates to:
  /// **'Warm season'**
  String get seasonWarm;

  /// No description provided for @seasonCool.
  ///
  /// In en, this message translates to:
  /// **'Cool season'**
  String get seasonCool;

  /// No description provided for @monthRange.
  ///
  /// In en, this message translates to:
  /// **'{start}–{end}'**
  String monthRange(String start, String end);

  /// No description provided for @categoryCereal.
  ///
  /// In en, this message translates to:
  /// **'Cereal'**
  String get categoryCereal;

  /// No description provided for @categoryLegume.
  ///
  /// In en, this message translates to:
  /// **'Legume'**
  String get categoryLegume;

  /// No description provided for @categoryRootTuber.
  ///
  /// In en, this message translates to:
  /// **'Root crop'**
  String get categoryRootTuber;

  /// No description provided for @categoryVegetable.
  ///
  /// In en, this message translates to:
  /// **'Vegetable'**
  String get categoryVegetable;

  /// No description provided for @categoryOilseed.
  ///
  /// In en, this message translates to:
  /// **'Oilseed'**
  String get categoryOilseed;

  /// No description provided for @categoryFruitNut.
  ///
  /// In en, this message translates to:
  /// **'Fruit & nut'**
  String get categoryFruitNut;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other crop'**
  String get categoryOther;

  /// No description provided for @roleNitrogenFixer.
  ///
  /// In en, this message translates to:
  /// **'fixes nitrogen'**
  String get roleNitrogenFixer;

  /// No description provided for @roleHeavyFeeder.
  ///
  /// In en, this message translates to:
  /// **'heavy feeder'**
  String get roleHeavyFeeder;

  /// No description provided for @roleLightFeeder.
  ///
  /// In en, this message translates to:
  /// **'light feeder'**
  String get roleLightFeeder;

  /// No description provided for @roleLine.
  ///
  /// In en, this message translates to:
  /// **'{category} · {role}'**
  String roleLine(String category, String role);

  /// No description provided for @growingDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{~{countText} day} other{~{countText} days}}'**
  String growingDays(int count, String countText);

  /// No description provided for @compatSoilShort.
  ///
  /// In en, this message translates to:
  /// **'Soil'**
  String get compatSoilShort;

  /// No description provided for @compatClimateShort.
  ///
  /// In en, this message translates to:
  /// **'Climate'**
  String get compatClimateShort;

  /// No description provided for @compatBadgeSemantics.
  ///
  /// In en, this message translates to:
  /// **'Soil fit {soil}, climate fit {climate}. Opens details.'**
  String compatBadgeSemantics(String soil, String climate);

  /// No description provided for @compatSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'How well {crop} fits'**
  String compatSheetTitle(String crop);

  /// No description provided for @compatSoilHeading.
  ///
  /// In en, this message translates to:
  /// **'Soil fit · {percent}'**
  String compatSoilHeading(String percent);

  /// No description provided for @compatClimateHeading.
  ///
  /// In en, this message translates to:
  /// **'Climate fit · {percent}'**
  String compatClimateHeading(String percent);

  /// No description provided for @soilInside.
  ///
  /// In en, this message translates to:
  /// **'Your pH {ph} is inside this crop\'s ideal range {min}–{max}.'**
  String soilInside(String ph, String min, String max);

  /// No description provided for @soilBelow.
  ///
  /// In en, this message translates to:
  /// **'Your pH {ph} is below this crop\'s ideal range {min}–{max}, so the soil is a little too acidic for it.'**
  String soilBelow(String ph, String min, String max);

  /// No description provided for @soilAbove.
  ///
  /// In en, this message translates to:
  /// **'Your pH {ph} is above this crop\'s ideal range {min}–{max}, so the soil is a little too alkaline for it.'**
  String soilAbove(String ph, String min, String max);

  /// No description provided for @climateInside.
  ///
  /// In en, this message translates to:
  /// **'{season} here averages about {temperature} °C, inside this crop\'s comfortable range of {min}–{max} °C.'**
  String climateInside(
    String season,
    String temperature,
    String min,
    String max,
  );

  /// No description provided for @climateBelow.
  ///
  /// In en, this message translates to:
  /// **'{season} here averages about {temperature} °C, colder than this crop\'s comfortable range of {min}–{max} °C.'**
  String climateBelow(
    String season,
    String temperature,
    String min,
    String max,
  );

  /// No description provided for @climateAbove.
  ///
  /// In en, this message translates to:
  /// **'{season} here averages about {temperature} °C, warmer than this crop\'s comfortable range of {min}–{max} °C.'**
  String climateAbove(
    String season,
    String temperature,
    String min,
    String max,
  );

  /// No description provided for @compatColorKey.
  ///
  /// In en, this message translates to:
  /// **'Green means a good fit, amber means workable, and red means risky.'**
  String get compatColorKey;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @metricSemantics.
  ///
  /// In en, this message translates to:
  /// **'{label}, {percent}'**
  String metricSemantics(String label, String percent);

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Estimates for planning only. Confirm with a local agronomist or a soil test.'**
  String get disclaimer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
