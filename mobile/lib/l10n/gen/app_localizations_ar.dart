// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'نبتة';

  @override
  String get brandStem => 'Nabt';

  @override
  String get brandTail => 'A';

  @override
  String get languageToggleLabel => 'English';

  @override
  String get languageToggleTooltip => 'تغيير لغة التطبيق إلى الإنجليزية';

  @override
  String get themeToDarkTooltip => 'التبديل إلى الوضع الداكن';

  @override
  String get themeToLightTooltip => 'التبديل إلى الوضع الفاتح';

  @override
  String get inputTitle => 'صِف أرضك';

  @override
  String get inputSubtitle =>
      'أربع خطوات سريعة، ثم نقترح عليك دورات زراعية تناسب حقلك.';

  @override
  String stepNumberSemantics(String number) {
    return 'الخطوة $number';
  }

  @override
  String get locationTitle => 'موقع الأرض';

  @override
  String get locationHelper => 'حدِّد موقع حقلك لنقدّر طبيعة مناخه.';

  @override
  String get mapPreviewEmpty => 'اضغط لتحديد أرضك على الخريطة';

  @override
  String get mapPreviewEmptySemantics =>
      'لم يُحدَّد موقع بعد. يفتح الخريطة لتحديد أرضك.';

  @override
  String mapPreviewPinnedSemantics(String coordinates) {
    return 'معاينة الخريطة ودبوسك عند $coordinates. يفتح الخريطة لتغييره.';
  }

  @override
  String get latitudeLabel => 'خط العرض';

  @override
  String get longitudeLabel => 'خط الطول';

  @override
  String get coordinatesHelper =>
      'تلميح: يمكنك لصق الرقمين معًا، مثل 30.0444, 31.2357، في أيٍّ من الخانتين.';

  @override
  String coordinatesPair(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String coordinatesSemantics(String latitude, String longitude) {
    return 'خط العرض $latitude، خط الطول $longitude';
  }

  @override
  String get pickOnMap => 'اختر على الخريطة';

  @override
  String get useMyLocation => 'استخدم موقعي';

  @override
  String get locating => 'جارٍ تحديد موقعك…';

  @override
  String get locationSetSnack => 'تم تثبيت موقعك على الخريطة.';

  @override
  String get errorLocationMissing =>
      'حدِّد أرضك على الخريطة، أو اكتب إحداثياتها.';

  @override
  String errorNotANumber(String example) {
    return 'اكتب رقمًا، مثل $example.';
  }

  @override
  String errorLatitudeRange(String min, String max) {
    return 'يجب أن يكون خط العرض بين $min و$max.';
  }

  @override
  String errorLongitudeRange(String min, String max) {
    return 'يجب أن يكون خط الطول بين $min و$max.';
  }

  @override
  String get areaTitle => 'مساحة المزرعة';

  @override
  String get areaHelper => 'بالمتر المربع. اختر مساحة شائعة أو اكتب مساحتك.';

  @override
  String get areaLabel => 'المساحة';

  @override
  String get areaUnit => 'م²';

  @override
  String areaWithUnit(String value) {
    return '$value م²';
  }

  @override
  String areaEquivalents(String hectares, String secondary) {
    return '≈ $hectares هكتار · $secondary فدان';
  }

  @override
  String get errorAreaMissing => 'أدخل مساحة مزرعتك.';

  @override
  String errorAreaRange(String max) {
    return 'يجب أن تكون المساحة أكبر من الصفر ولا تتجاوز $max م².';
  }

  @override
  String get phTitle => 'حموضة التربة (pH)';

  @override
  String phHelper(String neutral) {
    return 'مدى حموضة تربتك أو قلويتها، والقيمة $neutral تعني أنها متعادلة.';
  }

  @override
  String get phAcidic => 'حمضية';

  @override
  String get phSlightlyAcidic => 'حمضية قليلًا';

  @override
  String get phNeutral => 'متعادلة';

  @override
  String get phSlightlyAlkaline => 'قلوية قليلًا';

  @override
  String get phAlkaline => 'قلوية';

  @override
  String get phTapToType => 'اضغط على الرقم لكتابته';

  @override
  String phValueSemantics(String value, String label) {
    return 'حموضة التربة $value، $label. يفتح خانة لكتابة القيمة.';
  }

  @override
  String get phSliderLabel => 'شريط ضبط حموضة التربة';

  @override
  String get phDialogTitle => 'أدخل قيمة pH للتربة';

  @override
  String phDialogHint(String min, String max) {
    return 'بين $min و$max';
  }

  @override
  String phDialogError(String min, String max) {
    return 'أدخل قيمة بين $min و$max.';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get phUnknownChip => 'لا أعرف قيمة pH';

  @override
  String phAssumedHelper(String value) {
    return 'نستخدم القيمة الشائعة $value. فحص التربة يعطي نتائج أدق.';
  }

  @override
  String get prioritiesTitle => 'أولوياتك';

  @override
  String get prioritiesHelper =>
      'اختر ما يهمك أكثر، ويمكنك اختيار أكثر من خيار.';

  @override
  String get priorityWaterTitle => 'توفير المياه';

  @override
  String get priorityWaterDescription => 'محاصيل تحتاج إلى ري أقل.';

  @override
  String get priorityWaterShort => 'المياه';

  @override
  String get priorityNitrogenTitle => 'تثبيت النيتروجين';

  @override
  String get priorityNitrogenDescription => 'محاصيل تغذّي تربتك بشكل طبيعي.';

  @override
  String get priorityNitrogenShort => 'النيتروجين';

  @override
  String get priorityMarketTitle => 'ملاءمة السوق';

  @override
  String get priorityMarketDescription => 'محاصيل يُتوقَّع أن تُباع جيدًا.';

  @override
  String get priorityMarketShort => 'السوق';

  @override
  String get errorPrioritiesEmpty => 'اختر أولوية واحدة على الأقل.';

  @override
  String get getPlans => 'اعرض خطط الدورة الزراعية';

  @override
  String stepsNeedAttention(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countText خطوة تحتاج إلى مراجعة',
      many: '$countText خطوة تحتاج إلى مراجعة',
      few: '$countText خطوات تحتاج إلى مراجعة',
      two: 'خطوتان تحتاجان إلى مراجعة',
      one: 'خطوة واحدة تحتاج إلى مراجعة',
      zero: 'لا توجد خطوات تحتاج إلى مراجعة',
    );
    return '$_temp0';
  }

  @override
  String get mapTitle => 'حدِّد موقع أرضك';

  @override
  String get mapInstruction => 'حرِّك الخريطة حتى يستقر الدبوس فوق حقلك.';

  @override
  String get confirmLocation => 'تأكيد الموقع';

  @override
  String get zoomIn => 'تكبير';

  @override
  String get zoomOut => 'تصغير';

  @override
  String get goToMyLocation => 'انتقل إلى موقعي';

  @override
  String get mapAttribution => 'المساهمون في OpenStreetMap';

  @override
  String get mapTilesFailed =>
      'تعذّر تحميل صور الخريطة حاليًا. ما زال بإمكانك وضع الدبوس أو كتابة الإحداثيات.';

  @override
  String get locationServiceOff =>
      'خدمة الموقع متوقفة. فعّلها لنتمكن من تحديد حقلك.';

  @override
  String get locationDenied =>
      'نحتاج إلى إذن الوصول إلى الموقع لتحديد مكانك، ويمكنك أيضًا الاختيار من الخريطة.';

  @override
  String get locationDeniedForever =>
      'إذن الموقع محظور. اسمح به من الإعدادات لاستخدام هذه الميزة.';

  @override
  String get locationUnavailable =>
      'تعذّر تحديد موقعك. حاول مرة أخرى أو اختر من الخريطة.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get resultsTitle => 'خطط دورتك الزراعية';

  @override
  String get editInputs => 'تعديل';

  @override
  String summaryPh(String value) {
    return 'pH $value';
  }

  @override
  String phAssumedNote(String value) {
    return 'افترضنا أن حموضة تربتك $value، وهي قيمة شائعة. فحص بسيط للتربة سيجعل هذه الخطط أدق.';
  }

  @override
  String get tipAcidic =>
      'تربتك حمضية بدرجة واضحة. نثر الجير الزراعي قبل الزراعة ببضعة أسابيع يرفع قيمة pH ويفيد معظم المحاصيل.';

  @override
  String get tipAlkaline =>
      'تربتك قلوية بدرجة واضحة. إضافة السماد العضوي المتحلل (الكمبوست) مع الكبريت الزراعي تخفض قيمة pH تدريجيًا.';

  @override
  String get loadingSoil => 'نقرأ بيانات تربتك…';

  @override
  String get loadingClimate => 'نتحقق من المناخ…';

  @override
  String get loadingRotations => 'نبني الدورات الزراعية…';

  @override
  String get errorTitle => 'حدث خطأ ما';

  @override
  String get errorBody => 'تعذّر إعداد خططك. يُرجى المحاولة مرة أخرى.';

  @override
  String get retry => 'أعد المحاولة';

  @override
  String plansCount(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countText خطة، الأنسب أولًا',
      many: '$countText خطة، الأنسب أولًا',
      few: '$countText خطط، الأنسب أولًا',
      two: 'خطتان، الأنسب أولًا',
      one: 'خطة واحدة لأرضك',
      zero: 'لا توجد خطط',
    );
    return '$_temp0';
  }

  @override
  String get bestMatch => 'الأنسب لك';

  @override
  String get fitCaption => 'ملاءمة';

  @override
  String fitSemantics(String percent) {
    return 'نسبة الملاءمة الإجمالية $percent';
  }

  @override
  String stagesCount(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countText مرحلة',
      many: '$countText مرحلة',
      few: '$countText مراحل',
      two: 'مرحلتان',
      one: 'مرحلة واحدة',
      zero: 'بلا مراحل',
    );
    return '$_temp0';
  }

  @override
  String waterDemand(String value) {
    return '≈ $value م³ مياه';
  }

  @override
  String waterDemandSemantics(String value) {
    return 'نحو $value متر مكعب من المياه للدورة كاملة';
  }

  @override
  String get showCrops => 'اعرض المحاصيل';

  @override
  String get hideCrops => 'أخفِ المحاصيل';

  @override
  String stageLabel(String number, String season, String months) {
    return 'المرحلة $number · $season · $months';
  }

  @override
  String get seasonWarm => 'الموسم الدافئ';

  @override
  String get seasonCool => 'الموسم البارد';

  @override
  String monthRange(String start, String end) {
    return '$start–$end';
  }

  @override
  String get categoryCereal => 'حبوب';

  @override
  String get categoryLegume => 'بقوليات';

  @override
  String get categoryRootTuber => 'محصول جذري';

  @override
  String get categoryVegetable => 'خضروات';

  @override
  String get categoryOilseed => 'محصول زيتي';

  @override
  String get categoryFruitNut => 'فواكه ومكسرات';

  @override
  String get categoryOther => 'محصول آخر';

  @override
  String get roleNitrogenFixer => 'يثبّت النيتروجين';

  @override
  String get roleHeavyFeeder => 'يستهلك غذاءً كثيرًا';

  @override
  String get roleLightFeeder => 'يستهلك غذاءً قليلًا';

  @override
  String roleLine(String category, String role) {
    return '$category · $role';
  }

  @override
  String growingDays(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'نحو $countText يوم',
      many: 'نحو $countText يومًا',
      few: 'نحو $countText أيام',
      two: 'نحو يومين',
      one: 'نحو يوم واحد',
      zero: 'نحو $countText يوم',
    );
    return '$_temp0';
  }

  @override
  String get compatSoilShort => 'التربة';

  @override
  String get compatClimateShort => 'المناخ';

  @override
  String compatBadgeSemantics(String soil, String climate) {
    return 'ملاءمة التربة $soil، ملاءمة المناخ $climate. يفتح التفاصيل.';
  }

  @override
  String compatSheetTitle(String crop) {
    return 'مدى ملاءمة $crop لأرضك';
  }

  @override
  String compatSoilHeading(String percent) {
    return 'ملاءمة التربة · $percent';
  }

  @override
  String compatClimateHeading(String percent) {
    return 'ملاءمة المناخ · $percent';
  }

  @override
  String soilInside(String ph, String min, String max) {
    return 'قيمة pH لتربتك $ph تقع ضمن النطاق المثالي لهذا المحصول ($min–$max).';
  }

  @override
  String soilBelow(String ph, String min, String max) {
    return 'قيمة pH لتربتك $ph أقل من النطاق المثالي لهذا المحصول ($min–$max)، أي أن التربة أكثر حمضية مما يناسبه.';
  }

  @override
  String soilAbove(String ph, String min, String max) {
    return 'قيمة pH لتربتك $ph أعلى من النطاق المثالي لهذا المحصول ($min–$max)، أي أن التربة أكثر قلوية مما يناسبه.';
  }

  @override
  String climateInside(
    String season,
    String temperature,
    String min,
    String max,
  ) {
    return '$season هنا متوسط حرارته نحو $temperature °م، وهو ضمن النطاق المريح لهذا المحصول ($min–$max °م).';
  }

  @override
  String climateBelow(
    String season,
    String temperature,
    String min,
    String max,
  ) {
    return '$season هنا متوسط حرارته نحو $temperature °م، وهو أبرد من النطاق المريح لهذا المحصول ($min–$max °م).';
  }

  @override
  String climateAbove(
    String season,
    String temperature,
    String min,
    String max,
  ) {
    return '$season هنا متوسط حرارته نحو $temperature °م، وهو أدفأ من النطاق المريح لهذا المحصول ($min–$max °م).';
  }

  @override
  String get compatColorKey =>
      'الأخضر يعني ملاءمة جيدة، والكهرماني يعني ملاءمة مقبولة، والأحمر يعني مخاطرة.';

  @override
  String get gotIt => 'حسنًا';

  @override
  String metricSemantics(String label, String percent) {
    return '$label، $percent';
  }

  @override
  String get disclaimer =>
      'تقديرات للتخطيط فقط. تحقّق منها مع مهندس زراعي محلي أو بفحص للتربة.';
}
