import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/app_palette.dart';
import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/core/utils/motion.dart';
import 'package:nabta/features/planner/domain/priority.dart';
import 'package:nabta/features/planner/domain/rotation.dart';
import 'package:nabta/features/planner/presentation/planner_texts.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Bottom of a crop card: water · nitrogen · market in equal columns
/// (mirrored in RTL). Percentage on top, priority label under it, then a
/// thin bar. Priorities the grower selected get a tinted tile.
class MetricRow extends StatelessWidget {
  const MetricRow({super.key, required this.scores, required this.selected});

  final CropScores scores;
  final Set<Priority> selected;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, priority) in Priority.values.indexed) ...[
            if (index > 0) const SizedBox(width: Space.s),
            Expanded(
              child: _MetricTile(
                priority: priority,
                value: scores.forPriority(priority),
                selected: selected.contains(priority),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.priority, required this.value, required this.selected});

  final Priority priority;
  final int value;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = priority.tones(AppPalette.of(context));
    final duration = Motion.of(context, Motion.long);

    return Semantics(
      label: l10n.metricSemantics(priority.title(l10n), format.percent(value)),
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? tones.container : null,
          borderRadius: BorderRadius.circular(Radii.chip),
          border: Border.all(color: selected ? tones.accent : scheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(Space.s, Space.s + 2, Space.s, Space.s + 2),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value.toDouble()),
            duration: duration,
            curve: Curves.easeOutCubic,
            builder: (context, animated, _) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    format.percent(animated.round()),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: selected ? tones.onContainer : scheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: Space.half),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: Space.half,
                  children: [
                    Icon(priority.icon, size: 16, color: tones.onContainer),
                    Text(
                      priority.shortLabel(l10n),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium?.copyWith(color: tones.onContainer),
                    ),
                  ],
                ),
                const SizedBox(height: Space.s),
                _Bar(
                  fraction: animated / 100,
                  color: tones.accent,
                  track: selected ? tones.accent.withValues(alpha: 0.2) : scheme.surfaceContainerHighest,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.fraction, required this.color, required this.track});

  final double fraction;
  final Color color;
  final Color track;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.bar),
      child: SizedBox(
        height: Radii.bar,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(color: track),
          child: FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: fraction.clamp(0.0, 1.0).toDouble(),
            child: DecoratedBox(decoration: BoxDecoration(color: color)),
          ),
        ),
      ),
    );
  }
}
