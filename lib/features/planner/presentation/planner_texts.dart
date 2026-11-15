import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/app_palette.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/features/planner/domain/crop.dart';
import 'package:nabta/features/planner/domain/input_validation.dart';
import 'package:nabta/features/planner/domain/localized_text.dart';
import 'package:nabta/features/planner/domain/priority.dart';
import 'package:nabta/features/planner/domain/season.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Icons, colors and localized labels for domain values.
extension PriorityPresentation on Priority {
  IconData get icon => switch (this) {
        Priority.water => Icons.water_drop_outlined,
        Priority.nitrogen => Icons.eco_outlined,
        Priority.market => Icons.storefront_outlined,
      };

  String title(AppLocalizations l10n) => switch (this) {
        Priority.water => l10n.priorityWaterTitle,
        Priority.nitrogen => l10n.priorityNitrogenTitle,
        Priority.market => l10n.priorityMarketTitle,
      };

  String shortLabel(AppLocalizations l10n) => switch (this) {
        Priority.water => l10n.priorityWaterShort,
        Priority.nitrogen => l10n.priorityNitrogenShort,
        Priority.market => l10n.priorityMarketShort,
      };

  String description(AppLocalizations l10n) => switch (this) {
        Priority.water => l10n.priorityWaterDescription,
        Priority.nitrogen => l10n.priorityNitrogenDescription,
        Priority.market => l10n.priorityMarketDescription,
      };

  ToneSet tones(AppPalette palette) => switch (this) {
        Priority.water => palette.water,
        Priority.nitrogen => palette.nitrogen,
        Priority.market => palette.market,
      };
}

extension LocalizedTextContext on LocalizedText {
  String of(BuildContext context) => resolve(Localizations.localeOf(context).languageCode);
}

String seasonName(AppLocalizations l10n, SeasonKind kind) => switch (kind) {
      SeasonKind.warm => l10n.seasonWarm,
      SeasonKind.cool => l10n.seasonCool,
    };

String categoryName(AppLocalizations l10n, CropCategory category) => switch (category) {
      CropCategory.cereal => l10n.categoryCereal,
      CropCategory.legume => l10n.categoryLegume,
      CropCategory.rootTuber => l10n.categoryRootTuber,
      CropCategory.vegetable => l10n.categoryVegetable,
      CropCategory.oilseed => l10n.categoryOilseed,
      CropCategory.fruitNut => l10n.categoryFruitNut,
      CropCategory.other => l10n.categoryOther,
    };

String roleName(AppLocalizations l10n, CropRole role) => switch (role) {
      CropRole.nitrogenFixer => l10n.roleNitrogenFixer,
      CropRole.heavyFeeder => l10n.roleHeavyFeeder,
      CropRole.lightFeeder => l10n.roleLightFeeder,
    };

String phCategoryLabel(AppLocalizations l10n, double ph) {
  if (ph < 5.5) return l10n.phAcidic;
  if (ph < 6.6) return l10n.phSlightlyAcidic;
  if (ph <= 7.3) return l10n.phNeutral;
  if (ph <= 8.0) return l10n.phSlightlyAlkaline;
  return l10n.phAlkaline;
}

String? validationMessage(AppLocalizations l10n, AppFormat format, ValidationIssue? issue) {
  return switch (issue) {
    null => null,
    ValidationIssue.locationMissing => l10n.errorLocationMissing,
    ValidationIssue.latitudeNotNumber => l10n.errorNotANumber(format.decimal(30.5)),
    ValidationIssue.longitudeNotNumber => l10n.errorNotANumber(format.decimal(31.2)),
    ValidationIssue.latitudeOutOfRange => l10n.errorLatitudeRange(
        format.integer(InputLimits.minLatitude),
        format.integer(InputLimits.maxLatitude),
      ),
    ValidationIssue.longitudeOutOfRange => l10n.errorLongitudeRange(
        format.integer(InputLimits.minLongitude),
        format.integer(InputLimits.maxLongitude),
      ),
    ValidationIssue.areaMissing => l10n.errorAreaMissing,
    ValidationIssue.areaNotNumber => l10n.errorNotANumber(format.integer(1000)),
    ValidationIssue.areaOutOfRange => l10n.errorAreaRange(format.integer(InputLimits.maxAreaM2)),
    ValidationIssue.prioritiesEmpty => l10n.errorPrioritiesEmpty,
  };
}
