import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_colors.dart';

class ThemeController extends ChangeNotifier {
  static const String _themeKey = 'cartly_theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Color get currentBackgroundColor {
    return _themeMode == ThemeMode.dark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
  }

  Future<void> loadTheme() async {
    try {
      final preferences = await SharedPreferences.getInstance();

      final savedTheme = preferences.getString(_themeKey);

      if (savedTheme == null) {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.name == savedTheme,
          orElse: () => ThemeMode.system,
        );
      }

      notifyListeners();
    } catch (error) {
      debugPrint('Unable to load theme preference: $error');
    }
  }

  Future<void> changeTheme(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    try {
      final preferences = await SharedPreferences.getInstance();

      await preferences.setString(_themeKey, mode.name);
    } catch (error) {
      debugPrint('Unable to save theme preference: $error');
    }
  }

  Future<void> toggleTheme() async {
    final newMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    await changeTheme(newMode);
  }
}
