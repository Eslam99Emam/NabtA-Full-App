import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/app_palette.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/core/utils/motion.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Animated ring showing a strategy's overall fit.
class FitRing extends StatelessWidget {
  const FitRing({super.key, required this.percent, this.size = 76});

  final int percent;
  final double size;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final theme = Theme.of(context);
    final tones = AppPalette.of(context).forScore(percent);

    return Semantics(
      label: l10n.fitSemantics(format.percent(percent)),
      excludeSemantics: true,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: percent.toDouble()),
        duration: Motion.of(context, Motion.long),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) => SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: _RingPainter(
              progress: value / 100,
              color: tones.accent,
              track: theme.colorScheme.surfaceContainerHighest,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(12),
              child: FittedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      format.percent(value.round()),
                      style: theme.textTheme.titleLarge?.copyWith(color: tones.onContainer),
                    ),
                    Text(l10n.fitCaption, style: theme.textTheme.labelMedium),
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

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.progress, required this.color, required this.track});

  final double progress;
  final Color color;
  final Color track;

  static const double _stroke = 7;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(_stroke / 2);
    final base = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke;
    canvas.drawArc(arcRect, 0, math.pi * 2, false, base);
    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round;
    final sweep = math.pi * 2 * progress.clamp(0.0, 1.0).toDouble();
    canvas.drawArc(arcRect, -math.pi / 2, sweep, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color || oldDelegate.track != track;
}
