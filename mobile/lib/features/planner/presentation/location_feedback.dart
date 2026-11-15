import 'package:material_ui/material_ui.dart';

import 'package:nabta/features/planner/data/location_service.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Explains a location failure in plain words, with an "Open settings"
/// action when the fix lives in system settings.
void showLocationFailure({
  required ScaffoldMessengerState messenger,
  required AppLocalizations l10n,
  required LocationFailure failure,
  required LocationService service,
}) {
  final (String message, Future<bool> Function()? openSettings) = switch (failure) {
    LocationFailure.serviceDisabled => (l10n.locationServiceOff, service.openLocationSettings),
    LocationFailure.deniedForever => (l10n.locationDeniedForever, service.openAppSettings),
    LocationFailure.denied => (l10n.locationDenied, null),
    LocationFailure.unavailable => (l10n.locationUnavailable, null),
  };

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 6),
        action: openSettings == null
            ? null
            : SnackBarAction(label: l10n.openSettings, onPressed: () => openSettings()),
      ),
    );
}
