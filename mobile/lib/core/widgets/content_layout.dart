import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:nabta/core/theme/spacing.dart';

/// Page padding that keeps content within [Sizes.contentMaxWidth] and
/// centered on tablets, while the whole width stays scrollable.
EdgeInsetsDirectional pagePadding(
  double availableWidth, {
  double top = Space.m,
  double bottom = Space.xl,
}) {
  final side = math.max(Space.m, (availableWidth - Sizes.contentMaxWidth) / 2);
  return EdgeInsetsDirectional.fromSTEB(side, top, side, bottom);
}

/// Centers [child] and caps its width at [Sizes.contentMaxWidth].
class ContentConstraint extends StatelessWidget {
  const ContentConstraint({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Sizes.contentMaxWidth),
        child: child,
      ),
    );
  }
}
