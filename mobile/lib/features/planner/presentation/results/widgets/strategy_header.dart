import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/core/utils/motion.dart';
import 'package:nabta/core/widgets/messages.dart';
import 'package:nabta/features/planner/domain/rotation.dart';
import 'package:nabta/features/planner/presentation/planner_texts.dart';
import 'package:nabta/features/planner/presentation/results/widgets/crop_sequence.dart';
import 'package:nabta/features/planner/presentation/results/widgets/fit_ring.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Always-visible part of a strategy card.
class StrategyHeader extends StatelessWidget {
  const StrategyHeader({
    super.key,
    required this.strategy,
    required this.isBest,
    required this.expanded,
  });

  final RotationStrategy strategy;
  final bool isBest;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final water = format.integer(strategy.waterDemandM3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isBest) ...[
                    InfoPill(
                      icon: Icons.star_rounded,
                      label: l10n.bestMatch,
                      background: scheme.primary,
                      foreground: scheme.onPrimary,
                    ),
                    const SizedBox(height: Space.s),
                  ],
                  Text(strategy.profile.name.of(context), style: theme.textTheme.titleLarge),
                  const SizedBox(height: Space.half),
                  Text(
                    strategy.profile.rationale.of(context),
                    style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Space.m - Space.half),
            FitRing(percent: strategy.fit),
          ],
        ),
        const SizedBox(height: Space.m - Space.half),
        Wrap(
          spacing: Space.s,
          runSpacing: Space.s,
          children: [
            InfoPill(
              icon: Icons.layers_outlined,
              label: l10n.stagesCount(strategy.stageCount, format.integer(strategy.stageCount)),
            ),
            InfoPill(
              icon: Icons.water_drop_outlined,
              label: l10n.waterDemand(water),
              semanticsLabel: l10n.waterDemandSemantics(water),
            ),
          ],
        ),
        const SizedBox(height: Space.m - Space.half),
        CropSequence(stages: strategy.stages),
        const SizedBox(height: Space.s),
        Row(
          children: [
            Expanded(
              child: Text(
                expanded ? l10n.hideCrops : l10n.showCrops,
                style: theme.textTheme.labelLarge?.copyWith(color: scheme.primary),
              ),
            ),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0,
              duration: Motion.of(context, Motion.short),
              child: Icon(Icons.expand_more, color: scheme.primary),
            ),
          ],
        ),
      ],
    );
  }
}
