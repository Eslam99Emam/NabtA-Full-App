import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nabta/core/theme/app_palette.dart';
import 'package:nabta/core/theme/spacing.dart';

/// Hand-tuned light and dark themes built on the NabtA identity.
/// Light: Field Cream background, white cards, Space Navy text, Leaf Green
/// primary. Dark: deep green-black surfaces with softened Sprout accents.
abstract final class AppTheme {
  static ThemeData light(String languageCode) =>
      _build(_lightScheme, AppPalette.light, languageCode);

  static ThemeData dark(String languageCode) =>
      _build(_darkScheme, AppPalette.dark, languageCode);

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1D7E4B),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFCDEFD9),
    onPrimaryContainer: Color(0xFF0A3B21),
    secondary: Color(0xFF0E2233),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDCE6EE),
    onSecondaryContainer: Color(0xFF0E2233),
    tertiary: Color(0xFF8A5A36),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFF3E4D6),
    onTertiaryContainer: Color(0xFF3B2412),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    surface: Color(0xFFF5F2EA),
    onSurface: Color(0xFF0E2233),
    onSurfaceVariant: Color(0xFF4B5966),
    surfaceDim: Color(0xFFE2DED3),
    surfaceBright: Color(0xFFFBFAF6),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFFAF8F3),
    surfaceContainer: Color(0xFFF0EDE4),
    surfaceContainerHigh: Color(0xFFEAE6DC),
    surfaceContainerHighest: Color(0xFFE3DFD3),
    outline: Color(0xFF7A8792),
    outlineVariant: Color(0xFFDDD7C9),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF0E2233),
    onInverseSurface: Color(0xFFF5F2EA),
    inversePrimary: Color(0xFF7EDBA3),
    surfaceTint: Color(0xFF1D7E4B),
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF7EDBA3),
    onPrimary: Color(0xFF00391E),
    primaryContainer: Color(0xFF17573A),
    onPrimaryContainer: Color(0xFFC8F0D6),
    secondary: Color(0xFFB9CCDC),
    onSecondary: Color(0xFF0E2233),
    secondaryContainer: Color(0xFF223A4E),
    onSecondaryContainer: Color(0xFFDCE6EE),
    tertiary: Color(0xFFE2B793),
    onTertiary: Color(0xFF3B2412),
    tertiaryContainer: Color(0xFF5A3B22),
    onTertiaryContainer: Color(0xFFF3E4D6),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF0C1613),
    onSurface: Color(0xFFE3ECE6),
    onSurfaceVariant: Color(0xFFB2C3BA),
    surfaceDim: Color(0xFF0C1613),
    surfaceBright: Color(0xFF2A3833),
    surfaceContainerLowest: Color(0xFF07100D),
    surfaceContainerLow: Color(0xFF111C18),
    surfaceContainer: Color(0xFF15221D),
    surfaceContainerHigh: Color(0xFF1C2B25),
    surfaceContainerHighest: Color(0xFF24342E),
    outline: Color(0xFF8B9C93),
    outlineVariant: Color(0xFF2E413A),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE3ECE6),
    onInverseSurface: Color(0xFF16211D),
    inversePrimary: Color(0xFF1D7E4B),
    surfaceTint: Color(0xFF7EDBA3),
  );

  /// Card fill: white on cream in light mode, a lifted tonal surface in dark.
  static Color cardColor(ColorScheme scheme) => scheme.brightness == Brightness.light
      ? scheme.surfaceContainerLowest
      : scheme.surfaceContainer;

  static ThemeData _build(ColorScheme scheme, AppPalette palette, String languageCode) {
    final base = ThemeData(colorScheme: scheme, brightness: scheme.brightness);
    final textTheme = _textTheme(base.textTheme, languageCode)
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
    const pill = StadiumBorder();

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      extensions: [palette],
      cardTheme: CardThemeData(
        color: cardColor(scheme),
        elevation: 0,
        margin: EdgeInsetsDirectional.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.card),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(Sizes.minTarget, Sizes.primaryTarget),
          shape: pill,
          textStyle: textTheme.titleMedium,
          padding: const EdgeInsetsDirectional.fromSTEB(Space.l, Space.s, Space.l, Space.s),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(Sizes.minTarget, Sizes.minTarget),
          shape: pill,
          side: BorderSide(color: scheme.outline),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(Sizes.minTarget, Sizes.minTarget),
          shape: pill,
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: StadiumBorder(side: BorderSide(color: scheme.outlineVariant)),
        labelStyle: textTheme.labelLarge,
        padding: const EdgeInsetsDirectional.fromSTEB(Space.s, Space.half, Space.s, Space.half),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.input)),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onInverseSurface),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(Radii.card + Space.s)),
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1, space: Space.l),
    );
  }

  /// Inter is the brand UI face (bundled in assets/google_fonts). Cairo covers
  /// Arabic. Both fall back to the platform font when unavailable.
  static TextTheme _textTheme(TextTheme base, String languageCode) {
    final sized = base.copyWith(
      displaySmall: base.displaySmall?.copyWith(fontSize: 40, fontWeight: FontWeight.w700),
      headlineSmall: base.headlineSmall?.copyWith(fontSize: 26, fontWeight: FontWeight.w700),
      titleLarge: base.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
      titleMedium: base.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
      titleSmall: base.titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: 17, height: 1.5),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: 16, height: 1.5),
      bodySmall: base.bodySmall?.copyWith(fontSize: 14, height: 1.4),
      labelLarge: base.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      labelMedium: base.labelMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
    );
    return languageCode == 'ar'
        ? GoogleFonts.cairoTextTheme(sized)
        : GoogleFonts.interTextTheme(sized);
  }
}
