import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global theme mode controller.
/// Starts with system theme and can be overridden by user selection.
abstract final class ThemeModeController {
  ThemeModeController._();

  static const _themeModeKey = 'app_theme_mode';

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  static Future<void> loadSavedThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeModeKey);
    switch (saved) {
      case 'dark':
        themeMode.value = ThemeMode.dark;
      case 'light':
        themeMode.value = ThemeMode.light;
      default:
        themeMode.value = ThemeMode.system;
    }
  }

  static Future<void> setUserTheme({required bool isDark}) async {
    final prefs = await SharedPreferences.getInstance();
    final selected = isDark ? ThemeMode.dark : ThemeMode.light;
    themeMode.value = selected;
    await prefs.setString(_themeModeKey, isDark ? 'dark' : 'light');
  }
}
