import 'package:flutter/widgets.dart';

/// Animation durations that collapse to zero when the platform asks for
/// reduced motion (`MediaQuery.disableAnimations`).
abstract final class Motion {
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 360);
  static const Duration long = Duration(milliseconds: 800);
  static const Duration stagger = Duration(milliseconds: 80);

  static bool reduced(BuildContext context) => MediaQuery.disableAnimationsOf(context);

  static Duration of(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;
}
