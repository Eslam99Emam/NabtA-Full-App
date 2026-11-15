import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/motion.dart';
import 'package:nabta/features/planner/domain/land_input.dart';
import 'package:nabta/features/planner/domain/rotation.dart';
import 'package:nabta/features/planner/presentation/results/widgets/stage_timeline.dart';
import 'package:nabta/features/planner/presentation/results/widgets/strategy_header.dart';

/// One rotation plan. Tapping the header expands a timeline of crop cards.
class StrategyCard extends StatefulWidget {
  const StrategyCard({
    super.key,
    required this.strategy,
    required this.input,
    required this.isBest,
    required this.initiallyExpanded,
  });

  final RotationStrategy strategy;
  final LandInput input;
  final bool isBest;
  final bool initiallyExpanded;

  @override
  State<StrategyCard> createState() => _StrategyCardState();
}

class _StrategyCardState extends State<StrategyCard> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.card),
        side: BorderSide(
          color: widget.isBest ? scheme.primary : scheme.outlineVariant,
          width: widget.isBest ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(Space.l - Space.half),
              child: StrategyHeader(
                strategy: widget.strategy,
                isBest: widget.isBest,
                expanded: _expanded,
              ),
            ),
          ),
          AnimatedSize(
            duration: Motion.of(context, Motion.medium),
            curve: Curves.easeOutCubic,
            alignment: AlignmentDirectional.topCenter,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(Space.m, 0, Space.m, Space.l - Space.half),
                    child: StageTimeline(stages: widget.strategy.stages, input: widget.input),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
