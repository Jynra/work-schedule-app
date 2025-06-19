import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'is_dark_mode';

  /// Récupère le mode de thème sauvegardé
  Future<ThemeMode> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      return isDark ? ThemeMode.dark : ThemeMode.light;
    } catch (e) {
      print('Erreur lors du chargement du thème: $e');
      return ThemeMode.light; // Thème par défaut
    }
  }

  /// Sauvegarde le mode de thème
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = themeMode == ThemeMode.dark;
      await prefs.setBool(_themeKey, isDark);
      print('Thème sauvegardé: ${isDark ? 'sombre' : 'clair'}');
    } catch (e) {
      print('Erreur lors de la sauvegarde du thème: $e');
    }
  }

  /// Bascule entre les thèmes et sauvegarde
  Future<ThemeMode> toggleTheme(ThemeMode currentTheme) async {
    final newTheme = currentTheme == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    await saveThemeMode(newTheme);
    return newTheme;
  }

  /// Vérifie si le mode sombre est activé
  static bool isDarkMode(ThemeMode themeMode) {
    return themeMode == ThemeMode.dark;
  }
}