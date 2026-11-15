import 'package:material_ui/material_ui.dart';

/// An accent (icons, bars, borders), a tinted container, and a text color
/// that keeps at least 4.5:1 contrast on that container.
@immutable
class ToneSet {
  const ToneSet({
    required this.accent,
    required this.container,
    required this.onContainer,
  });

  final Color accent;
  final Color container;
  final Color onContainer;

  ToneSet lerp(ToneSet other, double t) => ToneSet(
        accent: Color.lerp(accent, other.accent, t) ?? accent,
        container: Color.lerp(container, other.container, t) ?? container,
        onContainer: Color.lerp(onContainer, other.onContainer, t) ?? onContainer,
      );
}

/// NabtA-specific colors that Material's ColorScheme has no slot for:
/// the three priority colors, score tiers, the pH scale and the logo layers.
/// Brand source: NabtA identity (Space Navy, Sprout Green, Leaf Green,
/// Moisture Blue, Soil Brown, Field Cream).
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.water,
    required this.nitrogen,
    required this.market,
    required this.good,
    required this.fair,
    required this.poor,
    required this.phScale,
    required this.logoSprout,
    required this.logoLeaf,
    required this.logoWater,
    required this.logoSoil,
    required this.wordmark,
  });

  final ToneSet water;
  final ToneSet nitrogen;
  final ToneSet market;
  final ToneSet good;
  final ToneSet fair;
  final ToneSet poor;
  final List<Color> phScale;
  final Color logoSprout;
  final Color logoLeaf;
  final Color logoWater;
  final Color logoSoil;
  final Color wordmark;

  static const AppPalette light = AppPalette(
    water: ToneSet(accent: Color(0xFF2F7FC1), container: Color(0xFFE2EEF9), onContainer: Color(0xFF0F4775)),
    nitrogen: ToneSet(accent: Color(0xFF3DBE6E), container: Color(0xFFE0F4E7), onContainer: Color(0xFF17633A)),
    market: ToneSet(accent: Color(0xFFE0A030), container: Color(0xFFFFF0D2), onContainer: Color(0xFF6E4300)),
    good: ToneSet(accent: Color(0xFF23955A), container: Color(0xFFE0F4E7), onContainer: Color(0xFF17633A)),
    fair: ToneSet(accent: Color(0xFFD48A12), container: Color(0xFFFFF0D2), onContainer: Color(0xFF6E4300)),
    poor: ToneSet(accent: Color(0xFFD3453B), container: Color(0xFFFCE3E0), onContainer: Color(0xFF8C1D18)),
    phScale: [Color(0xFFE4572E), Color(0xFFF29E38), Color(0xFF3DBE6E), Color(0xFF2F7FC1), Color(0xFF6B4FC8)],
    logoSprout: Color(0xFF3DBE6E),
    logoLeaf: Color(0xFF23955A),
    logoWater: Color(0xFF2F7FC1),
    logoSoil: Color(0xFF8A5A36),
    wordmark: Color(0xFF0E2233),
  );

  static const AppPalette dark = AppPalette(
    water: ToneSet(accent: Color(0xFF6FB2EA), container: Color(0xFF14304A), onContainer: Color(0xFFA9D2F5)),
    nitrogen: ToneSet(accent: Color(0xFF7EDBA3), container: Color(0xFF143A27), onContainer: Color(0xFFAEEBC4)),
    market: ToneSet(accent: Color(0xFFF2B544), container: Color(0xFF3D2B07), onContainer: Color(0xFFFFD58C)),
    good: ToneSet(accent: Color(0xFF7EDBA3), container: Color(0xFF143A27), onContainer: Color(0xFFAEEBC4)),
    fair: ToneSet(accent: Color(0xFFF2B544), container: Color(0xFF3D2B07), onContainer: Color(0xFFFFD58C)),
    poor: ToneSet(accent: Color(0xFFFF8A80), container: Color(0xFF4A1614), onContainer: Color(0xFFFFB4AB)),
    phScale: [Color(0xFFEF7A5A), Color(0xFFF4B060), Color(0xFF6FD495), Color(0xFF6FA8E0), Color(0xFF9A82E0)],
    logoSprout: Color(0xFF4BC87E),
    logoLeaf: Color(0xFF3DBE6E),
    logoWater: Color(0xFF59A5DF),
    logoSoil: Color(0xFFBF895D),
    wordmark: Color(0xFFF5F2EA),
  );

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>() ?? light;

  /// Score tiers: 75+ good, 50–74 fair, below 50 poor.
  ToneSet forScore(int score) {
    if (score >= 75) return good;
    if (score >= 50) return fair;
    return poor;
  }

  @override
  AppPalette copyWith({
    ToneSet? water,
    ToneSet? nitrogen,
    ToneSet? market,
    ToneSet? good,
    ToneSet? fair,
    ToneSet? poor,
    List<Color>? phScale,
    Color? logoSprout,
    Color? logoLeaf,
    Color? logoWater,
    Color? logoSoil,
    Color? wordmark,
  }) {
    return AppPalette(
      water: water ?? this.water,
      nitrogen: nitrogen ?? this.nitrogen,
      market: market ?? this.market,
      good: good ?? this.good,
      fair: fair ?? this.fair,
      poor: poor ?? this.poor,
      phScale: phScale ?? this.phScale,
      logoSprout: logoSprout ?? this.logoSprout,
      logoLeaf: logoLeaf ?? this.logoLeaf,
      logoWater: logoWater ?? this.logoWater,
      logoSoil: logoSoil ?? this.logoSoil,
      wordmark: wordmark ?? this.wordmark,
    );
  }

  @override
  AppPalette lerp(covariant ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      water: water.lerp(other.water, t),
      nitrogen: nitrogen.lerp(other.nitrogen, t),
      market: market.lerp(other.market, t),
      good: good.lerp(other.good, t),
      fair: fair.lerp(other.fair, t),
      poor: poor.lerp(other.poor, t),
      phScale: t < 0.5 ? phScale : other.phScale,
      logoSprout: Color.lerp(logoSprout, other.logoSprout, t) ?? logoSprout,
      logoLeaf: Color.lerp(logoLeaf, other.logoLeaf, t) ?? logoLeaf,
      logoWater: Color.lerp(logoWater, other.logoWater, t) ?? logoWater,
      logoSoil: Color.lerp(logoSoil, other.logoSoil, t) ?? logoSoil,
      wordmark: Color.lerp(wordmark, other.wordmark, t) ?? wordmark,
    );
  }
}
