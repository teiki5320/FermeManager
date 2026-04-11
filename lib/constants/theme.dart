import 'package:flutter/material.dart';

/// Palette et thème global de FermeManager.
/// Équivalent Flutter de l'ancien `constants/theme.ts` Expo.
class AppTheme {
  // Couleurs de base inspirées de l'ancien theme.ts
  static const Color background = Color(0xFF0A1628);
  static const Color surface = Color(0xFF132A3E);
  static const Color card = Color(0xFF1B3550);
  static const Color border = Color(0xFF264A6B);
  static const Color text = Color(0xFFF0F4F8);
  static const Color textSecondary = Color(0xFF8BA3BA);
  static const Color accent = Color(0xFFD4A74A);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: accent,
        secondary: accent,
        error: error,
        onSurface: text,
        onPrimary: Color(0xFF0A1628),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: text,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      iconTheme: const IconThemeData(color: textSecondary),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: text),
        bodyMedium: TextStyle(color: text),
        bodySmall: TextStyle(color: textSecondary),
        titleLarge: TextStyle(
          color: text,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          color: text,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accent,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
