import 'package:latlong2/latlong.dart';

/// Map settings in one place. Change [tileUrlTemplate] to swap providers.
abstract final class MapConfig {
  static const String tileUrlTemplate = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String userAgentPackageName = 'com.nabta.app';

  static final LatLng worldCenter = LatLng(20, 0);
  static const double worldZoom = 2;
  static const double pinZoom = 15;
  static const double previewZoom = 13;
  static const double minZoom = 2;
  static const double maxZoom = 18;
}
