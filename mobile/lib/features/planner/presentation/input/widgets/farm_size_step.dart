import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/core/utils/area_units.dart';
import 'package:nabta/core/widgets/app_input_decoration.dart';
import 'package:nabta/features/planner/domain/input_validation.dart';
import 'package:nabta/features/planner/presentation/planner_controller.dart';
import 'package:nabta/features/planner/presentation/planner_texts.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Step 2: area in m² with quick-pick chips and a live equivalents line
/// (hectares + acres in English, hectares + feddans in Arabic).
class FarmSizeStep extends StatefulWidget {
  const FarmSizeStep({super.key});

  @override
  State<FarmSizeStep> createState() => _FarmSizeStepState();
}

class _FarmSizeStepState extends State<FarmSizeStep> {
  late final PlannerController _planner;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _planner = context.read<PlannerController>();
    _controller = TextEditingController(text: _planner.areaText);
    _planner.addListener(_sync);
  }

  void _sync() {
    final text = _planner.areaText;
    if (_controller.text == text) return;
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  void dispose() {
    _planner.removeListener(_sync);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final theme = Theme.of(context);
    final planner = context.watch<PlannerController>();
    final area = planner.areaM2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          onChanged: _planner.setAreaText,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          style: theme.textTheme.bodyLarge,
          decoration: appInputDecoration(
            context,
            label: l10n.areaLabel,
            suffixText: l10n.areaUnit,
            prefixIcon: const Icon(Icons.straighten),
            errorText: validationMessage(l10n, format, planner.visibleValidation.area),
          ),
        ),
        const SizedBox(height: Space.m - Space.half),
        Wrap(
          spacing: Space.s,
          runSpacing: Space.s,
          children: [
            for (final size in InputLimits.quickAreasM2)
              ChoiceChip(
                label: Text(l10n.areaWithUnit(format.integer(size))),
                selected: area == size,
                onSelected: (_) => _planner.setQuickArea(size),
              ),
          ],
        ),
        if (area != null && area > 0) ...[
          const SizedBox(height: Space.m - Space.half),
          Row(
            children: [
              Icon(Icons.swap_horiz, size: 20, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: Space.s),
              Expanded(
                child: Text(
                  l10n.areaEquivalents(
                    format.flexible(AreaUnits.hectares(area)),
                    format.flexible(format.isArabic ? AreaUnits.feddans(area) : AreaUnits.acres(area)),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
