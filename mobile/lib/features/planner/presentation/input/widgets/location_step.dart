import 'package:material_ui/material_ui.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/features/planner/presentation/input/widgets/coordinate_fields.dart';
import 'package:nabta/features/planner/presentation/input/widgets/location_buttons.dart';
import 'package:nabta/features/planner/presentation/input/widgets/map_preview.dart';
import 'package:nabta/features/planner/presentation/planner_controller.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Step 1: map preview, coordinate fields, and the two location buttons.
class LocationStep extends StatelessWidget {
  const LocationStep({super.key});

  @override
  Widget build(BuildContext context) {
    final location = context.select<PlannerController, LatLng?>((p) => p.location);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MapPreview(location: location, onTap: () => openMapPicker(context)),
        const SizedBox(height: Space.m),
        const CoordinateFields(),
        const SizedBox(height: Space.s),
        Text(
          AppLocalizations.of(context).coordinatesHelper,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: Space.m),
        const Wrap(
          spacing: Space.s,
          runSpacing: Space.s,
          children: [PickOnMapButton(), UseMyLocationButton()],
        ),
      ],
    );
  }
}
