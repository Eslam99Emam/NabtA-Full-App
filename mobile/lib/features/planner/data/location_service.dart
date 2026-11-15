import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

enum LocationFailure { serviceDisabled, denied, deniedForever, unavailable }

sealed class LocationOutcome {
  const LocationOutcome();
}

final class LocationFound extends LocationOutcome {
  const LocationFound(this.position);

  final LatLng position;
}

final class LocationFailed extends LocationOutcome {
  const LocationFailed(this.reason);

  final LocationFailure reason;
}

/// One place for device location, shared by "Use my location" and the map
/// picker, including the full permission flow.
class LocationService {
  const LocationService();

  static const Duration _timeout = Duration(seconds: 15);

  Future<LocationOutcome> locate() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationFailed(LocationFailure.serviceDisabled);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      switch (permission) {
        case LocationPermission.deniedForever:
          return const LocationFailed(LocationFailure.deniedForever);
        case LocationPermission.denied:
        case LocationPermission.unableToDetermine:
          return const LocationFailed(LocationFailure.denied);
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          break;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: _timeout,
        ),
      );
      return LocationFound(LatLng(position.latitude, position.longitude));
    } on Exception {
      final last = await _lastKnown();
      return last == null ? const LocationFailed(LocationFailure.unavailable) : LocationFound(last);
    }
  }

  /// A quiet best guess for centering the map: never prompts.
  Future<LatLng?> lastKnownIfPermitted() async {
    try {
      final permission = await Geolocator.checkPermission();
      final granted = permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
      return granted ? await _lastKnown() : null;
    } on Exception {
      return null;
    }
  }

  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  Future<LatLng?> _lastKnown() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      return position == null ? null : LatLng(position.latitude, position.longitude);
    } on Exception {
      return null;
    }
  }
}
