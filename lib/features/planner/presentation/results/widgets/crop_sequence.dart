import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/features/planner/domain/rotation.dart';
import 'package:nabta/features/planner/presentation/planner_texts.dart';

/// Compact preview: 🌾 Wheat → 🫘 Faba bean → … Arrows mirror in RTL.
class CropSequence extends StatelessWidget {
  const CropSequence({super.key, required this.stages});

  final List<RotationStage> stages;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final last = stages.length - 1;
    return Wrap(
      spacing: Space.half,
      runSpacing: Space.s,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final (index, stage) in stages.indexed) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Text(stage.crop.emoji, style: const TextStyle(fontSize: 20), textScaler: TextScaler.noScaling),
              ),
              const SizedBox(width: Space.half),
              Flexible(child: Text(stage.crop.name.of(context), style: theme.textTheme.labelLarge)),
            ],
          ),
          if (index < last)
            Icon(Icons.arrow_forward, size: 18, color: theme.colorScheme.onSurfaceVariant),
        ],
      ],
    );
  }
}
