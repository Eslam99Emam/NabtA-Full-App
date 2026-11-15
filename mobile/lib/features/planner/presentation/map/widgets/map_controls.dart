import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Zoom in / zoom out / my location, each a 48 dp target with a tooltip.
class MapControls extends StatelessWidget {
  const MapControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onMyLocation,
    required this.locating,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onMyLocation;
  final bool locating;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = IconButton.styleFrom(
      minimumSize: const Size.square(Sizes.minTarget),
      elevation: 2,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          style: style,
          tooltip: l10n.zoomIn,
          onPressed: onZoomIn,
          icon: const Icon(Icons.add),
        ),
        const SizedBox(height: Space.s),
        IconButton.filledTonal(
          style: style,
          tooltip: l10n.zoomOut,
          onPressed: onZoomOut,
          icon: const Icon(Icons.remove),
        ),
        const SizedBox(height: Space.m),
        IconButton.filled(
          style: style,
          tooltip: l10n.goToMyLocation,
          onPressed: locating ? null : onMyLocation,
          icon: locating
              ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.my_location),
        ),
      ],
    );
  }
}
