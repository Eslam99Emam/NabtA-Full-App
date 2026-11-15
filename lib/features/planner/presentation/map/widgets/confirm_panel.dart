import 'package:material_ui/material_ui.dart';
import 'package:latlong2/latlong.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/core/widgets/content_layout.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Bottom panel: instruction, live coordinates (always LTR) and the big
/// "Confirm location" button.
class ConfirmPanel extends StatelessWidget {
  const ConfirmPanel({super.key, required this.center, required this.onConfirm});

  final LatLng center;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final theme = Theme.of(context);
    final latitude = format.coordinate(center.latitude);
    final longitude = format.coordinate(center.longitude);

    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(Space.m, Space.m, Space.m, Space.m),
          child: ContentConstraint(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.mapInstruction,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: Space.s),
                Semantics(
                  label: l10n.coordinatesSemantics(latitude, longitude),
                  excludeSemantics: true,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: [
                        Icon(Icons.place_outlined, color: theme.colorScheme.primary),
                        const SizedBox(width: Space.s),
                        Expanded(
                          child: Text(
                            l10n.coordinatesPair(latitude, longitude),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Space.m - Space.half),
                FilledButton.icon(
                  onPressed: onConfirm,
                  icon: const Icon(Icons.check),
                  label: Text(l10n.confirmLocation),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
