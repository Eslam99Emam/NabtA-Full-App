import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/features/planner/domain/land_input.dart';
import 'package:nabta/features/planner/domain/rotation.dart';
import 'package:nabta/features/planner/presentation/planner_texts.dart';
import 'package:nabta/features/planner/presentation/results/widgets/crop_card.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Vertical timeline: a stage label with a dot, then the crop card beside
/// a connector line on the start side.
class StageTimeline extends StatelessWidget {
  const StageTimeline({super.key, required this.stages, required this.input});

  final List<RotationStage> stages;
  final LandInput input;

  static const double _dot = 14;
  static const double _line = 2;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final last = stages.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, stage) in stages.indexed) ...[
          Row(
            children: [
              Container(
                width: _dot,
                height: _dot,
                decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
              ),
              const SizedBox(width: Space.s + Space.half),
              Expanded(
                child: Text(
                  l10n.stageLabel(
                    format.integer(stage.window.number),
                    seasonName(l10n, stage.window.kind),
                    l10n.monthRange(
                      format.month(stage.window.startMonth),
                      format.month(stage.window.endMonth),
                    ),
                  ),
                  style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(start: (_dot - _line) / 2),
            padding: EdgeInsetsDirectional.fromSTEB(
              Space.m + Space.half,
              Space.s,
              0,
              index == last ? 0 : Space.l,
            ),
            decoration: BoxDecoration(
              border: index == last
                  ? null
                  : BorderDirectional(start: BorderSide(color: scheme.outlineVariant, width: _line)),
            ),
            child: CropCard(
              stage: stage,
              selectedPriorities: input.priorities,
              soilPh: input.ph,
            ),
          ),
        ],
      ],
    );
  }
}
