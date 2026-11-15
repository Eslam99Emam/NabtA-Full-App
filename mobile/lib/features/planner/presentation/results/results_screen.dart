import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:nabta/core/utils/motion.dart';
import 'package:nabta/features/planner/presentation/planner_controller.dart';
import 'package:nabta/features/planner/presentation/results/widgets/error_view.dart';
import 'package:nabta/features/planner/presentation/results/widgets/loading_view.dart';
import 'package:nabta/features/planner/presentation/results/widgets/results_list.dart';
import 'package:nabta/features/settings/presentation/nabta_app_bar.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Screen 3: "Your rotation plans".
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final planner = context.watch<PlannerController>();
    final input = planner.submittedInput;

    final Widget body = switch (planner.status) {
      PlannerStatus.error => ErrorView(key: const ValueKey('error'), onRetry: planner.retry),
      PlannerStatus.success when input != null => ResultsList(
          key: const ValueKey('results'),
          input: input,
          strategies: planner.strategies,
        ),
      _ => const LoadingView(key: ValueKey('loading')),
    };

    return Scaffold(
      appBar: NabtaAppBar(title: Text(AppLocalizations.of(context).resultsTitle)),
      body: AnimatedSwitcher(duration: Motion.of(context, Motion.medium), child: body),
    );
  }
}
