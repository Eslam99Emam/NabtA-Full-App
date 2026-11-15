import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/app_palette.dart';
import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/features/planner/domain/land_input.dart';
import 'package:nabta/features/planner/domain/priority.dart';
import 'package:nabta/features/planner/presentation/planner_texts.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Chips summarizing what the grower entered, plus "Edit", which returns
/// to the form with everything intact.
class InputSummary extends StatelessWidget {
  const InputSummary({super.key, required this.input});

  final LandInput input;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final palette = AppPalette.of(context);

    return Wrap(
      spacing: Space.s,
      runSpacing: Space.s,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Chip(
          avatar: const Icon(Icons.place_outlined),
          label: Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              l10n.coordinatesPair(format.coordinate(input.latitude), format.coordinate(input.longitude)),
            ),
          ),
        ),
        Chip(
          avatar: const Icon(Icons.straighten),
          label: Text(l10n.areaWithUnit(format.integer(input.areaM2))),
        ),
        Chip(
          avatar: const Icon(Icons.science_outlined),
          label: Text(l10n.summaryPh(format.decimal(input.ph))),
        ),
        for (final priority in Priority.values)
          if (input.priorities.contains(priority))
            Chip(
              avatar: Icon(priority.icon, color: priority.tones(palette).onContainer),
              label: Text(priority.shortLabel(l10n)),
              labelStyle: TextStyle(color: priority.tones(palette).onContainer),
              backgroundColor: priority.tones(palette).container,
              side: BorderSide(color: priority.tones(palette).accent),
            ),
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.edit_outlined),
          label: Text(l10n.editInputs),
        ),
      ],
    );
  }
}
