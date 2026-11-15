import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/app_palette.dart';
import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Two-row badge: soil fit and climate fit. Each row is color-coded
/// (75+ green, 50–74 amber, below 50 red) and always shows its number.
class CompatBadge extends StatelessWidget {
  const CompatBadge({
    super.key,
    required this.soil,
    required this.climate,
    required this.onTap,
  });

  final int soil;
  final int climate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final scheme = Theme.of(context).colorScheme;
    final palette = AppPalette.of(context);

    return Semantics(
      button: true,
      label: l10n.compatBadgeSemantics(format.percent(soil), format.percent(climate)),
      excludeSemantics: true,
      child: Material(
        color: scheme.surfaceContainerLowest,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.chip),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: Sizes.minTarget, minHeight: Sizes.minTarget),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(Space.half),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _BadgeRow(icon: Icons.terrain_outlined, value: soil, tones: palette.forScore(soil)),
                    const SizedBox(height: Space.half),
                    _BadgeRow(icon: Icons.thermostat_outlined, value: climate, tones: palette.forScore(climate)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeRow extends StatelessWidget {
  const _BadgeRow({required this.icon, required this.value, required this.tones});

  final IconData icon;
  final int value;
  final ToneSet tones;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tones.container,
        borderRadius: BorderRadius.circular(Space.s),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(6, 3, Space.s, 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: tones.onContainer),
            const SizedBox(width: Space.half),
            Text(
              AppFormat.of(context).percent(value),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: tones.onContainer),
            ),
          ],
        ),
      ),
    );
  }
}
