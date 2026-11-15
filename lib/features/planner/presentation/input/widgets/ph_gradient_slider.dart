import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'package:nabta/core/theme/app_palette.dart';
import 'package:nabta/core/theme/spacing.dart';

/// A pH slider whose track runs from acidic red-orange through neutral
/// green to alkaline blue-violet. Mirrors in RTL and exposes slider
/// semantics (increase/decrease) to screen readers.
class PhGradientSlider extends StatelessWidget {
  const PhGradientSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
    required this.semanticLabel,
    required this.formatValue,
  });

  final double value;
  final double min;
  final double max;
  final double step;
  final ValueChanged<double> onChanged;
  final String semanticLabel;
  final String Function(double value) formatValue;

  static const double _thumb = 32;
  static const double _track = 14;

  double _snap(double raw) {
    final stepped = (raw / step).round() * step;
    return double.parse(stepped.clamp(min, max).toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final palette = AppPalette.of(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final up = _snap(value + step);
    final down = _snap(value - step);

    return LayoutBuilder(
      builder: (context, constraints) {
        final usable = constraints.maxWidth - _thumb;
        final fraction = ((value - min) / (max - min)).clamp(0.0, 1.0).toDouble();

        void update(double dx) {
          var t = ((dx - _thumb / 2) / usable).clamp(0.0, 1.0).toDouble();
          if (rtl) t = 1 - t;
          final next = _snap(min + t * (max - min));
          if (next != value) {
            HapticFeedback.selectionClick();
            onChanged(next);
          }
        }

        return Semantics(
          slider: true,
          label: semanticLabel,
          value: formatValue(value),
          increasedValue: formatValue(up),
          decreasedValue: formatValue(down),
          onIncrease: () => onChanged(up),
          onDecrease: () => onChanged(down),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) => update(details.localPosition.dx),
            onHorizontalDragUpdate: (details) => update(details.localPosition.dx),
            child: SizedBox(
              height: Sizes.minTarget,
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  PositionedDirectional(
                    start: _thumb / 2,
                    end: _thumb / 2,
                    child: Container(
                      height: _track,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_track),
                        gradient: LinearGradient(
                          begin: AlignmentDirectional.centerStart,
                          end: AlignmentDirectional.centerEnd,
                          colors: palette.phScale,
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: fraction * usable,
                    child: Container(
                      width: _thumb,
                      height: _thumb,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scheme.surfaceContainerLowest,
                        border: Border.all(color: scheme.onSurface, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.shadow.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
