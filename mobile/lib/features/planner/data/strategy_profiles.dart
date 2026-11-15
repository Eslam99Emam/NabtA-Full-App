import 'package:nabta/features/planner/domain/localized_text.dart';
import 'package:nabta/features/planner/domain/priority.dart';
import 'package:nabta/features/planner/domain/rotation.dart';

/// Search profiles, in search order. The first uses the grower's weights.
const List<StrategyProfile> strategyProfiles = [
  StrategyProfile(
    id: 'yours',
    name: LocalizedText(en: 'Made for your priorities', ar: 'مصمَّمة لأولوياتك'),
    rationale: LocalizedText(
      en: 'Balances what you care about with what your soil and climate can support.',
      ar: 'توازن بين ما يهمك وما تسمح به تربتك ومناخك.',
    ),
  ),
  StrategyProfile(
    id: 'water_saver',
    name: LocalizedText(en: 'Water saver', ar: 'الخطة الموفّرة للمياه'),
    rationale: LocalizedText(
      en: 'Favors crops that do well on less irrigation.',
      ar: 'تفضّل محاصيل تنجح بري أقل.',
    ),
    weights: {Priority.water: 1, Priority.nitrogen: 0.35, Priority.market: 0.35},
  ),
  StrategyProfile(
    id: 'soil_builder',
    name: LocalizedText(en: 'Soil builder', ar: 'خطة بناء التربة'),
    rationale: LocalizedText(
      en: 'Legumes add nitrogen, so the crops that follow need less fertilizer.',
      ar: 'تضيف البقوليات النيتروجين، فتحتاج المحاصيل التالية إلى سماد أقل.',
    ),
    weights: {Priority.water: 0.35, Priority.nitrogen: 1, Priority.market: 0.35},
  ),
  StrategyProfile(
    id: 'market_driver',
    name: LocalizedText(en: 'Market driver', ar: 'الخطة الموجّهة للسوق'),
    rationale: LocalizedText(
      en: 'Leans on crops with steady demand and good prices.',
      ar: 'تعتمد على محاصيل عليها طلب ثابت وأسعار جيدة.',
    ),
    weights: {Priority.water: 0.35, Priority.nitrogen: 0.35, Priority.market: 1},
  ),
];

/// Used only when extra plans are needed to reach the minimum count.
const StrategyProfile alternativeProfile = StrategyProfile(
  id: 'alternative',
  name: LocalizedText(en: 'Alternative plan', ar: 'خطة بديلة'),
  rationale: LocalizedText(
    en: 'Another workable sequence that spreads risk across different crops.',
    ar: 'تسلسل بديل قابل للتطبيق يوزّع المخاطر على محاصيل مختلفة.',
  ),
);
