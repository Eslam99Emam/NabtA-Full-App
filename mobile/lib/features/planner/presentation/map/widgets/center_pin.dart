import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/utils/motion.dart';

/// The fixed center pin. It lifts with a softer, wider shadow while the
/// map is being dragged and drops back on release.
class CenterPin extends StatelessWidget {
  const CenterPin({super.key, required this.lifted});

  final bool lifted;

  static const double _size = 48;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final duration = Motion.of(context, Motion.short);
    return IgnorePointer(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          AnimatedContainer(
            duration: duration,
            curve: Curves.easeOut,
            width: lifted ? 20 : 12,
            height: lifted ? 6 : 4,
            decoration: BoxDecoration(
              color: scheme.shadow.withValues(alpha: lifted ? 0.22 : 0.4),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          AnimatedPadding(
            duration: duration,
            curve: Curves.easeOutBack,
            padding: EdgeInsetsDirectional.only(bottom: lifted ? _size + 24 : _size),
            child: Icon(
              Icons.location_on,
              size: _size,
              color: scheme.primary,
              shadows: [
                Shadow(
                  color: scheme.shadow.withValues(alpha: lifted ? 0.3 : 0.15),
                  blurRadius: lifted ? 10 : 4,
                  offset: Offset(0, lifted ? 6 : 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
