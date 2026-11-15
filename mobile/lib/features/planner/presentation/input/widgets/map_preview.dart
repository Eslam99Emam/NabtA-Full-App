import 'package:material_ui/material_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/core/widgets/dashed_border.dart';
import 'package:nabta/features/planner/presentation/map/map_config.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// 160 dp, non-interactive map thumbnail with a centered pin. Tapping it
/// opens the full map picker.
class MapPreview extends StatelessWidget {
  const MapPreview({super.key, required this.location, required this.onTap});

  final LatLng? location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final scheme = Theme.of(context).colorScheme;
    final point = location;
    final label = point == null
        ? l10n.mapPreviewEmptySemantics
        : l10n.mapPreviewPinnedSemantics(
            l10n.coordinatesPair(format.coordinate(point.latitude), format.coordinate(point.longitude)),
          );

    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: SizedBox(
        height: Sizes.mapPreviewHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Radii.input),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (point == null) const _EmptyPreview() else _PinnedPreview(point: point),
              Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: onTap, splashColor: scheme.primary.withValues(alpha: 0.12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CustomPaint(
      painter: DashedBorderPainter(color: scheme.outline, radius: Radii.input),
      child: ColoredBox(
        color: scheme.surfaceContainerLow,
        child: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(Space.m),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_location_alt_outlined, size: 36, color: scheme.primary),
                const SizedBox(height: Space.s),
                Text(
                  AppLocalizations.of(context).mapPreviewEmpty,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: scheme.onSurface),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PinnedPreview extends StatelessWidget {
  const _PinnedPreview({required this.point});

  final LatLng point;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: scheme.surfaceContainerHigh),
          FlutterMap(
            key: ValueKey(point),
            options: MapOptions(
              initialCenter: point,
              initialZoom: MapConfig.previewZoom,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
            ),
            children: [
              TileLayer(
                urlTemplate: MapConfig.tileUrlTemplate,
                userAgentPackageName: MapConfig.userAgentPackageName,
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 40),
              child: Icon(Icons.location_on, size: 40, color: scheme.primary),
            ),
          ),
          PositionedDirectional(
            end: Space.s,
            bottom: Space.half,
            child: Text(
              AppLocalizations.of(context).mapAttribution,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
              textScaler: TextScaler.noScaling,
            ),
          ),
        ],
      ),
    );
  }
}
