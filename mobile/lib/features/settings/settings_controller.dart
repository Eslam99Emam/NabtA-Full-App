import 'package:material_ui/material_ui.dart';

import 'package:nabta/features/settings/settings_repository.dart';

/// App-wide language and light/dark choice.
class SettingsController extends ChangeNotifier {
  SettingsController(this._repository);

  final SettingsRepository _repository;

  static const String english = 'en';
  static const String arabic = 'ar';

  Locale _locale = const Locale(english);
  ThemeMode _themeMode = ThemeMode.system;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get isArabic => _locale.languageCode == arabic;

  /// First launch follows the device language if it is Arabic, else English.
  Future<void> load({required String deviceLanguageCode}) async {
    final saved = await _repository.readLanguageCode();
    final code = (saved == english || saved == arabic)
        ? saved
        : (deviceLanguageCode == arabic ? arabic : english);
    _locale = Locale(code ?? english);
    _themeMode = await _repository.readThemeMode() ?? ThemeMode.system;
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _locale = Locale(isArabic ? english : arabic);
    notifyListeners();
    await _repository.saveLanguageCode(_locale.languageCode);
  }

  /// Flips from whatever is on screen now (which may come from "system").
  Future<void> toggleBrightness(Brightness current) async {
    _themeMode = current == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    await _repository.saveThemeMode(_themeMode);
  }
}
