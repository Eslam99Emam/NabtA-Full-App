import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/app_palette.dart';
import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/core/widgets/content_layout.dart';
import 'package:nabta/core/widgets/messages.dart';
import 'package:nabta/core/widgets/staggered_entry.dart';
import 'package:nabta/features/planner/domain/input_validation.dart';
import 'package:nabta/features/planner/domain/land_input.dart';
import 'package:nabta/features/planner/domain/rotation.dart';
import 'package:nabta/features/planner/presentation/results/widgets/input_summary.dart';
import 'package:nabta/features/planner/presentation/results/widgets/strategy_card.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Summary, notes, strategy cards (best first) and the disclaimer.
class ResultsList extends StatelessWidget {
  const ResultsList({super.key, required this.input, required this.strategies});

  final LandInput input;
  final List<RotationStrategy> strategies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final count = strategies.length;

    final String? soilTip = input.ph < InputLimits.acidicTipBelow
        ? l10n.tipAcidic
        : (input.ph > InputLimits.alkalineTipAbove ? l10n.tipAlkaline : null);

    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        padding: pagePadding(constraints.maxWidth),
        children: [
          InputSummary(input: input),
          if (input.phAssumed) ...[
            const SizedBox(height: Space.m),
            InfoBanner(
              icon: Icons.info_outline,
              message: l10n.phAssumedNote(format.decimal(input.ph)),
              background: theme.colorScheme.secondaryContainer,
              foreground: theme.colorScheme.onSecondaryContainer,
            ),
          ],
          if (soilTip != null) ...[
            const SizedBox(height: Space.m),
            InfoBanner(
              icon: Icons.tips_and_updates_outlined,
              message: soilTip,
              background: palette.market.container,
              foreground: palette.market.onContainer,
            ),
          ],
          const SizedBox(height: Space.l),
          Semantics(
            header: true,
            child: Text(l10n.plansCount(count, format.integer(count)), style: theme.textTheme.titleMedium),
          ),
          const SizedBox(height: Space.m - Space.half),
          for (final (index, strategy) in strategies.indexed) ...[
            StaggeredEntry(
              index: index,
              child: StrategyCard(
                strategy: strategy,
                input: input,
                isBest: index == 0,
                initiallyExpanded: index == 0,
              ),
            ),
            const SizedBox(height: Space.m),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.verified_outlined, size: 20, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: Space.s),
              Expanded(
                child: Text(
                  l10n.disclaimer,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
