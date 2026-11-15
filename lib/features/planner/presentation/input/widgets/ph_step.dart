import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/features/planner/domain/input_validation.dart';
import 'package:nabta/features/planner/presentation/input/widgets/ph_dialog.dart';
import 'package:nabta/features/planner/presentation/input/widgets/ph_gradient_slider.dart';
import 'package:nabta/features/planner/presentation/planner_controller.dart';
import 'package:nabta/features/planner/presentation/planner_texts.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Step 3: big pH readout (tap to type), gradient slider, and an
/// "I don't know my pH" chip.
class PhStep extends StatelessWidget {
  const PhStep({super.key});

  Future<void> _typeValue(BuildContext context, double current) async {
    final planner = context.read<PlannerController>();
    final value = await showPhDialog(context, initial: current);
    if (value != null) planner.setPh(value);
  }

  @override
  Widget build(BuildContext context) {
    final planner = context.watch<PlannerController>();
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final ph = planner.ph;
    final label = phCategoryLabel(l10n, ph);
    final caption = theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          label: l10n.phValueSemantics(format.decimal(ph), label),
          excludeSemantics: true,
          child: InkWell(
            borderRadius: BorderRadius.circular(Radii.input),
            onTap: () => _typeValue(context, ph),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(Space.s),
              child: Row(
                children: [
                  Text(format.decimal(ph), style: theme.textTheme.displaySmall),
                  const SizedBox(width: Space.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: theme.textTheme.titleMedium),
                        Text(l10n.phTapToType, style: caption),
                      ],
                    ),
                  ),
                  Icon(Icons.edit_outlined, color: scheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: Space.s),
        PhGradientSlider(
          value: ph,
          min: InputLimits.minPh,
          max: InputLimits.maxPh,
          step: InputLimits.phStep,
          semanticLabel: l10n.phSliderLabel,
          formatValue: (value) => format.decimal(value),
          onChanged: planner.setPh,
        ),
        Row(
          children: [
            Expanded(child: Text(l10n.phAcidic, style: caption)),
            Expanded(child: Text(l10n.phNeutral, style: caption, textAlign: TextAlign.center)),
            Expanded(child: Text(l10n.phAlkaline, style: caption, textAlign: TextAlign.end)),
          ],
        ),
        const SizedBox(height: Space.m),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: FilterChip(
            avatar: const Icon(Icons.help_outline),
            label: Text(l10n.phUnknownChip),
            selected: planner.phAssumed,
            onSelected: (_) => planner.assumeUnknownPh(),
          ),
        ),
        if (planner.phAssumed) ...[
          const SizedBox(height: Space.s),
          Text(l10n.phAssumedHelper(format.decimal(InputLimits.defaultPh)), style: caption),
        ],
      ],
    );
  }
}
