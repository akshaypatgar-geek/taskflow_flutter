import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskflowapp/core/utils/constants.dart';

/// Global theme mode controller.
/// Starts with system theme and can be overridden by user selection.
abstract final class ThemeModeController {
  ThemeModeController._();

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  static Future<void> loadSavedThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(PreferencesKeys.themeMode);
    switch (saved) {
      case PreferencesKeys.themeDark:
        themeMode.value = ThemeMode.dark;
      case PreferencesKeys.themeLight:
        themeMode.value = ThemeMode.light;
      default:
        themeMode.value = ThemeMode.system;
    }
  }

  static Future<void> setUserTheme({required bool isDark}) async {
    final prefs = await SharedPreferences.getInstance();
    final selected = isDark ? ThemeMode.dark : ThemeMode.light;
    themeMode.value = selected;
    await prefs.setString(
      PreferencesKeys.themeMode,
      isDark ? PreferencesKeys.themeDark : PreferencesKeys.themeLight,
    );
  }
}
