import 'package:material_ui/material_ui.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:nabta/features/planner/data/location_service.dart';
import 'package:nabta/features/planner/presentation/location_feedback.dart';
import 'package:nabta/features/planner/presentation/map/map_picker_screen.dart';
import 'package:nabta/features/planner/presentation/planner_controller.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Opens the full-screen picker and stores the confirmed point.
Future<void> openMapPicker(BuildContext context) async {
  final planner = context.read<PlannerController>();
  final picked = await Navigator.of(context).push<LatLng>(
    MaterialPageRoute(builder: (_) => MapPickerScreen(initial: planner.location)),
  );
  if (picked != null) planner.setLocation(picked);
}

class PickOnMapButton extends StatelessWidget {
  const PickOnMapButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => openMapPicker(context),
      icon: const Icon(Icons.map_outlined),
      label: Text(AppLocalizations.of(context).pickOnMap),
    );
  }
}

class UseMyLocationButton extends StatefulWidget {
  const UseMyLocationButton({super.key});

  @override
  State<UseMyLocationButton> createState() => _UseMyLocationButtonState();
}

class _UseMyLocationButtonState extends State<UseMyLocationButton> {
  bool _busy = false;

  Future<void> _locate() async {
    final service = context.read<LocationService>();
    final planner = context.read<PlannerController>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);

    setState(() => _busy = true);
    final outcome = await service.locate();
    if (!mounted) return;
    setState(() => _busy = false);

    switch (outcome) {
      case LocationFound(:final position):
        planner.setLocation(position);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.locationSetSnack)));
      case LocationFailed(:final reason):
        showLocationFailure(messenger: messenger, l10n: l10n, failure: reason, service: service);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return OutlinedButton.icon(
      onPressed: _busy ? null : _locate,
      icon: _busy
          ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.my_location),
      label: Text(_busy ? l10n.locating : l10n.useMyLocation),
    );
  }
}
