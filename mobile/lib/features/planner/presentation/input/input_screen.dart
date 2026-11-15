import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/core/utils/motion.dart';
import 'package:nabta/core/widgets/content_layout.dart';
import 'package:nabta/features/planner/domain/input_validation.dart';
import 'package:nabta/features/planner/presentation/input/widgets/farm_size_step.dart';
import 'package:nabta/features/planner/presentation/input/widgets/location_step.dart';
import 'package:nabta/features/planner/presentation/input/widgets/ph_step.dart';
import 'package:nabta/features/planner/presentation/input/widgets/priorities_step.dart';
import 'package:nabta/features/planner/presentation/input/widgets/step_card.dart';
import 'package:nabta/features/planner/presentation/input/widgets/submit_bar.dart';
import 'package:nabta/features/planner/presentation/planner_controller.dart';
import 'package:nabta/features/planner/presentation/planner_texts.dart';
import 'package:nabta/features/planner/presentation/results/results_screen.dart';
import 'package:nabta/features/settings/presentation/nabta_app_bar.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Screen 1: "Describe your land" — four numbered steps and a sticky CTA.
class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final Map<InputStep, GlobalKey> _stepKeys = {
    for (final step in InputStep.values) step: GlobalKey(),
  };

  void _submit() {
    final planner = context.read<PlannerController>();
    if (planner.submit()) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const ResultsScreen()));
      return;
    }
    HapticFeedback.mediumImpact();
    final validation = planner.validation;
    final firstStep = validation.firstInvalidStep;
    final target = firstStep == null
        ? null
        : _stepKeys[firstStep]?.currentContext;
    if (target != null) {
      Scrollable.ensureVisible(
        target,
        duration: Motion.of(context, Motion.medium),
        curve: Curves.easeOutCubic,
        alignment: 0.05,
      );
    }
    final count = validation.invalidSteps.length;
    final l10n = AppLocalizations.of(context);
    // ScaffoldMessenger.of(context)
    //   ..hideCurrentSnackBar()
    //   ..showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         l10n.stepsNeedAttention(
    //           count,
    //           AppFormat.of(context).integer(count),
    //         ),
    //       ),
    //     ),
    //   );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.fixed, // Add this line
          content: Text(
            l10n.stepsNeedAttention(
              count,
              AppFormat.of(context).integer(count),
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final theme = Theme.of(context);
    final validation = context.watch<PlannerController>().visibleValidation;
    final invalid = validation.invalidSteps;

    return Scaffold(
      appBar: const NabtaAppBar(),
      // bottomNavigationBar: SubmitBar(onPressed: _submit),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // padding: pagePadding(constraints.maxWidth),
          // child: ConstrainedBox(
          //   constraints: BoxConstraints(
          //     minHeight:
          //         constraints.maxHeight -
          //         pagePadding(constraints.maxWidth).vertical,
          //   ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center, // Optional: centers content vertically if screen is taller than content
            children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.inputTitle,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: Space.half),
              Text(
                l10n.inputSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Space.l),
              StepCard(
                key: _stepKeys[InputStep.location],
                number: 1,
                title: l10n.locationTitle,
                helper: l10n.locationHelper,
                invalid: invalid.contains(InputStep.location),
                errorText: validationMessage(l10n, format, validation.location),
                child: const LocationStep(),
              ),
              const SizedBox(height: Space.m),
              StepCard(
                key: _stepKeys[InputStep.area],
                number: 2,
                title: l10n.areaTitle,
                helper: l10n.areaHelper,
                invalid: invalid.contains(InputStep.area),
                child: const FarmSizeStep(),
              ),
              const SizedBox(height: Space.m),
              StepCard(
                key: _stepKeys[InputStep.ph],
                number: 3,
                title: l10n.phTitle,
                helper: l10n.phHelper(format.integer(InputLimits.neutralPh)),
                child: const PhStep(),
              ),
              const SizedBox(height: Space.m),
              StepCard(
                key: _stepKeys[InputStep.priorities],
                number: 4,
                title: l10n.prioritiesTitle,
                helper: l10n.prioritiesHelper,
                invalid: invalid.contains(InputStep.priorities),
                errorText: validationMessage(
                  l10n,
                  format,
                  validation.priorities,
                ),
                child: const PrioritiesStep(),
              ),
              SubmitBar(onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
