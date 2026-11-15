import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/features/planner/domain/priority.dart';
import 'package:nabta/features/planner/domain/rotation.dart';
import 'package:nabta/features/planner/presentation/planner_texts.dart';
import 'package:nabta/features/planner/presentation/results/widgets/compat_badge.dart';
import 'package:nabta/features/planner/presentation/results/widgets/compat_sheet.dart';
import 'package:nabta/features/planner/presentation/results/widgets/metric_row.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// One crop in a rotation.
///
/// Layout: header row (avatar · name/role/days · compatibility badge at the
/// top-END corner), a short note, a divider, then the three priority
/// metrics at the bottom. The badge is the last child of a Row, so it lands
/// top-right in LTR and top-left in RTL without any left/right code.
class CropCard extends StatelessWidget {
  const CropCard({
    super.key,
    required this.stage,
    required this.selectedPriorities,
    required this.soilPh,
  });

  final RotationStage stage;
  final Set<Priority> selectedPriorities;
  final double soilPh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final crop = stage.crop;
    final secondary = theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(Space.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
                    child: Text(crop.emoji, style: const TextStyle(fontSize: 24), textScaler: TextScaler.noScaling),
                  ),
                ),
                const SizedBox(width: Space.m - Space.half),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(crop.name.of(context), style: theme.textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(
                        l10n.roleLine(categoryName(l10n, crop.category), roleName(l10n, crop.role)),
                        style: secondary,
                      ),
                      Text(l10n.growingDays(crop.growingDays, format.integer(crop.growingDays)), style: secondary),
                    ],
                  ),
                ),
                const SizedBox(width: Space.s),
                CompatBadge(
                  soil: stage.scores.soil,
                  climate: stage.scores.climate,
                  onTap: () => showCompatSheet(context, stage: stage, soilPh: soilPh),
                ),
              ],
            ),
            const SizedBox(height: Space.m - Space.half),
            Text(crop.note.of(context), style: theme.textTheme.bodyMedium),
            const Divider(),
            MetricRow(scores: stage.scores, selected: selectedPriorities),
          ],
        ),
      ),
    );
  }
}
