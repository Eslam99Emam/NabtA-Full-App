import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:nabta/core/theme/app_theme.dart';
import 'package:nabta/features/planner/presentation/input/input_screen.dart';
import 'package:nabta/features/settings/settings_controller.dart';
import 'package:nabta/l10n/delegates.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

class NabtaApp extends StatelessWidget {
  const NabtaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final languageCode = settings.locale.languageCode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: appLocalizationsDelegates,
      theme: AppTheme.light(languageCode),
      darkTheme: AppTheme.dark(languageCode),
      themeMode: settings.themeMode,
      home: const InputScreen(),
    );
  }
}
