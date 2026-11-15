import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/features/planner/domain/priority.dart';
import 'package:nabta/features/planner/presentation/input/widgets/priority_card.dart';
import 'package:nabta/features/planner/presentation/planner_controller.dart';

/// Step 4: multi-select priority cards (at least one required).
class PrioritiesStep extends StatelessWidget {
  const PrioritiesStep({super.key});

  @override
  Widget build(BuildContext context) {
    final planner = context.watch<PlannerController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, priority) in Priority.values.indexed) ...[
          if (index > 0) const SizedBox(height: Space.m - Space.half),
          PriorityCard(
            priority: priority,
            selected: planner.priorities.contains(priority),
            onToggle: () => planner.togglePriority(priority),
          ),
        ],
      ],
    );
  }
}
