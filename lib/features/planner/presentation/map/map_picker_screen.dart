import 'package:material_ui/material_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/widgets/messages.dart';
import 'package:nabta/features/planner/data/location_service.dart';
import 'package:nabta/features/planner/presentation/location_feedback.dart';
import 'package:nabta/features/planner/presentation/map/map_config.dart';
import 'package:nabta/features/planner/presentation/map/widgets/center_pin.dart';
import 'package:nabta/features/planner/presentation/map/widgets/confirm_panel.dart';
import 'package:nabta/features/planner/presentation/map/widgets/map_controls.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Screen 2: full-screen OpenStreetMap with a fixed center pin. Pops with
/// the confirmed [LatLng].
class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key, this.initial});

  final LatLng? initial;

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _map = MapController();
  late LatLng _center = widget.initial ?? MapConfig.worldCenter;
  bool _lifted = false;
  bool _locating = false;
  bool _tilesFailed = false;
  bool _userMoved = false;

  /// Map callbacks can fire during layout; defer setState to after the frame.
  void _safeSetState(VoidCallback change) {
    if (!mounted) return;
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(change);
      });
    } else {
      setState(change);
    }
  }

  Future<void> _onMapReady() async {
    if (widget.initial != null) return;
    final guess = await context.read<LocationService>().lastKnownIfPermitted();
    if (!mounted || guess == null || _userMoved) return;
    _moveTo(guess, MapConfig.pinZoom);
  }

  void _moveTo(LatLng point, double zoom) {
    _map.move(point, zoom);
    _safeSetState(() => _center = point);
  }

  void _zoomBy(double delta) {
    final camera = _map.camera;
    final zoom = (camera.zoom + delta).clamp(MapConfig.minZoom, MapConfig.maxZoom).toDouble();
    _map.move(camera.center, zoom);
  }

  Future<void> _goToMyLocation() async {
    final service = context.read<LocationService>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    setState(() => _locating = true);
    final outcome = await service.locate();
    if (!mounted) return;
    setState(() => _locating = false);
    switch (outcome) {
      case LocationFound(:final position):
        _userMoved = true;
        _moveTo(position, MapConfig.pinZoom);
      case LocationFailed(:final reason):
        showLocationFailure(messenger: messenger, l10n: l10n, failure: reason, service: service);
    }
  }

  void _setLifted(bool lifted) {
    if (_lifted == lifted) return;
    setState(() {
      _lifted = lifted;
      if (lifted) _userMoved = true;
    });
  }

  @override
  void dispose() {
    _map.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mapTitle)),
      bottomNavigationBar: ConfirmPanel(
        center: _center,
        onConfirm: () => Navigator.of(context).pop(_center),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Listener(
            onPointerDown: (_) => _setLifted(true),
            onPointerUp: (_) => _setLifted(false),
            onPointerCancel: (_) => _setLifted(false),
            child: FlutterMap(
              mapController: _map,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: widget.initial == null ? MapConfig.worldZoom : MapConfig.pinZoom,
                minZoom: MapConfig.minZoom,
                maxZoom: MapConfig.maxZoom,
                backgroundColor: scheme.surfaceContainerHigh,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
                onMapReady: _onMapReady,
                onPositionChanged: (camera, hasGesture) =>
                    _safeSetState(() => _center = camera.center),
              ),
              children: [
                TileLayer(
                  urlTemplate: MapConfig.tileUrlTemplate,
                  userAgentPackageName: MapConfig.userAgentPackageName,
                  errorTileCallback: (tile, error, stackTrace) {
                    if (!_tilesFailed) _safeSetState(() => _tilesFailed = true);
                  },
                ),
                RichAttributionWidget(
                  attributions: [TextSourceAttribution(l10n.mapAttribution)],
                ),
              ],
            ),
          ),
          Center(child: CenterPin(lifted: _lifted)),
          PositionedDirectional(
            end: Space.m,
            top: Space.m,
            child: MapControls(
              onZoomIn: () => _zoomBy(1),
              onZoomOut: () => _zoomBy(-1),
              onMyLocation: _goToMyLocation,
              locating: _locating,
            ),
          ),
          if (_tilesFailed)
            PositionedDirectional(
              start: Space.m,
              end: Space.m + Sizes.minTarget + Space.m,
              top: Space.m,
              child: InfoBanner(
                icon: Icons.cloud_off_outlined,
                message: l10n.mapTilesFailed,
                background: scheme.surfaceContainerHighest,
                foreground: scheme.onSurface,
              ),
            ),
        ],
      ),
    );
  }
}
