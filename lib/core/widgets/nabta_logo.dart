import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/app_palette.dart';
import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// The NabtA mark (soil, water and crop layers with a sprout) plus the
/// wordmark with its upside-down "∀" ("for all"). Always laid out LTR.
class NabtaLogo extends StatelessWidget {
  const NabtaLogo({super.key, this.markSize = 30});

  final double markSize;

  /// Bundled TeX Gyre Adventor Bold (see pubspec `fonts`).
  static const String wordmarkFontFamily = 'Adventor';

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context);
    final style = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontFamily: wordmarkFontFamily,
          color: palette.wordmark,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        );
    return Semantics(
      label: l10n.appTitle,
      excludeSemantics: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            NabtaMark(size: markSize),
            const SizedBox(width: Space.s),
            Text(l10n.brandStem, style: style, textScaler: TextScaler.noScaling),
            RotatedBox(
              quarterTurns: 2,
              child: Text(
                l10n.brandTail,
                style: style?.copyWith(color: palette.logoLeaf),
                textScaler: TextScaler.noScaling,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The layered sprout mark on its own.
class NabtaMark extends StatelessWidget {
  const NabtaMark({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _MarkPainter(
        palette: AppPalette.of(context),
        gapColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter({required this.palette, required this.gapColor});

  final AppPalette palette;
  final Color gapColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    Path layer(double centerY) => Path()
      ..moveTo(w * 0.5, centerY - h * 0.15)
      ..lineTo(w * 0.96, centerY)
      ..lineTo(w * 0.5, centerY + h * 0.15)
      ..lineTo(w * 0.04, centerY)
      ..close();

    final gap = Paint()
      ..color = gapColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05;

    for (final (y, color) in [
      (h * 0.80, palette.logoSoil),
      (h * 0.69, palette.logoWater),
      (h * 0.58, palette.logoSprout),
    ]) {
      final path = layer(y);
      canvas.drawPath(path, Paint()..color = color);
      canvas.drawPath(path, gap);
    }

    final stem = Paint()
      ..color = palette.logoLeaf
      ..strokeWidth = w * 0.06
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.5, h * 0.58), Offset(w * 0.5, h * 0.30), stem);

    final leaf = Paint()..color = palette.logoSprout;
    void drawLeaf(Offset center, double angle, double length) {
      canvas
        ..save()
        ..translate(center.dx, center.dy)
        ..rotate(angle)
        ..drawOval(Rect.fromCenter(center: Offset.zero, width: length, height: length * 0.5), leaf)
        ..restore();
    }

    drawLeaf(Offset(w * 0.38, h * 0.27), 0.45, w * 0.24);
    drawLeaf(Offset(w * 0.64, h * 0.22), -0.45, w * 0.32);
  }

  @override
  bool shouldRepaint(_MarkPainter oldDelegate) =>
      oldDelegate.palette != palette || oldDelegate.gapColor != gapColor;
}
