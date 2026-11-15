import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/widgets/nabta_logo.dart';
import 'package:nabta/features/settings/settings_controller.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Flat app bar with the NabtA logo (or a page title), the language
/// switch and the light/dark switch.
class NabtaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NabtaAppBar({super.key, this.title});

  final Widget? title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      title: title ?? const NabtaLogo(),
      centerTitle: false,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      actions: const [
        LanguageToggleButton(),
        ThemeToggleButton(),
        SizedBox(width: Space.s),
      ],
    );
  }
}

/// Shows the *other* language's name ("العربية" / "English").
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: l10n.languageToggleTooltip,
      child: TextButton.icon(
        onPressed: () => context.read<SettingsController>().toggleLanguage(),
        icon: const Icon(Icons.translate),
        label: Text(l10n.languageToggleLabel),
      ),
    );
  }
}

/// Sun in dark mode (go light), moon in light mode (go dark).
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    return IconButton(
      tooltip: isDark ? l10n.themeToLightTooltip : l10n.themeToDarkTooltip,
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: () => context.read<SettingsController>().toggleBrightness(brightness),
    );
  }
}
