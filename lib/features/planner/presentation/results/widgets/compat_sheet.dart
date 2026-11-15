import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/app_palette.dart';
import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/features/planner/domain/rotation.dart';
import 'package:nabta/features/planner/domain/scoring.dart';
import 'package:nabta/features/planner/presentation/planner_texts.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

Future<void> showCompatSheet(
  BuildContext context, {
  required RotationStage stage,
  required double soilPh,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => CompatSheet(stage: stage, soilPh: soilPh),
  );
}

/// Plain-language explanation of the soil and climate numbers.
class CompatSheet extends StatelessWidget {
  const CompatSheet({super.key, required this.stage, required this.soilPh});

  final RotationStage stage;
  final double soilPh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final f = AppFormat.of(context);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final crop = stage.crop;
    final scores = stage.scores;

    final ph = f.decimal(soilPh);
    final phMin = f.decimal(crop.ph.min);
    final phMax = f.decimal(crop.ph.max);
    final soilText = switch (Scoring.positionIn(soilPh, crop.ph)) {
      RangePosition.inside => l10n.soilInside(ph, phMin, phMax),
      RangePosition.below => l10n.soilBelow(ph, phMin, phMax),
      RangePosition.above => l10n.soilAbove(ph, phMin, phMax),
    };

    final temperature = stage.window.meanTemperatureC;
    final season = seasonName(l10n, stage.window.kind);
    final t = f.decimal(temperature, digits: 0);
    final tMin = f.decimal(crop.temperatureC.min, digits: 0);
    final tMax = f.decimal(crop.temperatureC.max, digits: 0);
    final climateText = switch (Scoring.positionIn(temperature, crop.temperatureC)) {
      RangePosition.inside => l10n.climateInside(season, t, tMin, tMax),
      RangePosition.below => l10n.climateBelow(season, t, tMin, tMax),
      RangePosition.above => l10n.climateAbove(season, t, tMin, tMax),
    };

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(Space.l, 0, Space.l, Space.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.compatSheetTitle(crop.name.of(context)), style: theme.textTheme.titleLarge),
          const SizedBox(height: Space.m),
          _Section(
            icon: Icons.terrain_outlined,
            heading: l10n.compatSoilHeading(f.percent(scores.soil)),
            body: soilText,
            tones: palette.forScore(scores.soil),
          ),
          const SizedBox(height: Space.m - Space.half),
          _Section(
            icon: Icons.thermostat_outlined,
            heading: l10n.compatClimateHeading(f.percent(scores.climate)),
            body: climateText,
            tones: palette.forScore(scores.climate),
          ),
          const SizedBox(height: Space.m),
          Text(
            l10n.compatColorKey,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: Space.l),
          FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.gotIt)),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.icon, required this.heading, required this.body, required this.tones});

  final IconData icon;
  final String heading;
  final String body;
  final ToneSet tones;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tones.container,
        borderRadius: BorderRadius.circular(Radii.input),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(Space.m),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: tones.onContainer),
            const SizedBox(width: Space.m - Space.half),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(heading, style: theme.textTheme.titleMedium?.copyWith(color: tones.onContainer)),
                  const SizedBox(height: Space.half),
                  Text(body, style: theme.textTheme.bodyMedium?.copyWith(color: tones.onContainer)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
