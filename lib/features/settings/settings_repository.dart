import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the chosen language and theme mode.
class SettingsRepository {
  SettingsRepository({SharedPreferencesAsync? preferences})
      : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  static const String _languageKey = 'settings.languageCode';
  static const String _themeKey = 'settings.themeMode';

  Future<String?> readLanguageCode() async {
    try {
      return await _preferences.getString(_languageKey);
    } on Exception {
      return null;
    }
  }

  Future<ThemeMode?> readThemeMode() async {
    try {
      final name = await _preferences.getString(_themeKey);
      return ThemeMode.values.where((mode) => mode.name == name).firstOrNull;
    } on Exception {
      return null;
    }
  }

  Future<void> saveLanguageCode(String code) async {
    try {
      await _preferences.setString(_languageKey, code);
    } on Exception {
      // Best effort: the app keeps working with the in-memory value.
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    try {
      await _preferences.setString(_themeKey, mode.name);
    } on Exception {
      // Best effort: the app keeps working with the in-memory value.
    }
  }
}
