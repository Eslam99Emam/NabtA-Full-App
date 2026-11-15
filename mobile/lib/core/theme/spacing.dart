/// 8-pt spacing scale. `half` exists only for tight icon/text gaps.
abstract final class Space {
  static const double half = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Corner radii used across the app.
abstract final class Radii {
  static const double card = 20;
  static const double input = 16;
  static const double chip = 12;
  static const double bar = 4;
}

/// Layout limits and touch-target sizes.
abstract final class Sizes {
  static const double contentMaxWidth = 640;
  static const double primaryTarget = 56;
  static const double minTarget = 48;
  static const double mapPreviewHeight = 160;
}
