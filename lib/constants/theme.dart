import 'package:flutter/material.dart';

/// Palette pastel et thème global de FermeManager.
/// Identité : sage green (agriculture) + crème + accents doux.
class AppTheme {
  // ── Base ──────────────────────────────────────────────
  static const Color background = Color(0xFFFAF8F3); // crème paper
  static const Color surface = Color(0xFFFFFFFF); // blanc
  static const Color card = Color(0xFFFFFFFF); // cartes blanches avec ombre
  static const Color cardAlt = Color(0xFFF4F1EA); // crème alternatif
  static const Color border = Color(0xFFEAE5D8); // beige doux

  // ── Texte ─────────────────────────────────────────────
  static const Color text = Color(0xFF3D3A32); // charbon chaud
  static const Color textSecondary = Color(0xFF8A857A); // gris chaud
  static const Color textOnAccent = Color(0xFFFFFFFF);

  // ── Accents (sage green, identité agricole) ──────────
  static const Color accent = Color(0xFF87A878); // sage
  static const Color accentSoft = Color(0xFFDFECD4); // sage très pâle
  static const Color accentDark = Color(0xFF5E8057); // sage foncé

  // ── Secondary (terracotta doux) ──────────────────────
  static const Color secondary = Color(0xFFD08A76);
  static const Color secondarySoft = Color(0xFFF5DCD1);

  // ── Status ───────────────────────────────────────────
  static const Color success = Color(0xFF88C293); // mint doux
  static const Color successSoft = Color(0xFFD9ECDB);
  static const Color warning = Color(0xFFE8B25F); // ambre chaud
  static const Color warningSoft = Color(0xFFFAE9C9);
  static const Color error = Color(0xFFE48A82); // corail doux
  static const Color errorSoft = Color(0xFFF5D6D1);

  /// Ombre subtile pour les cartes, donne un effet pastel moderne.
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ];

  /// Ombre moyenne pour cartes mises en avant.
  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.06),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        surface: surface,
        primary: accent,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.white,
        error: error,
        onSurface: text,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
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
        titleLarge: TextStyle(color: text, fontWeight: FontWeight.w800),
        titleMedium: TextStyle(color: text, fontWeight: FontWeight.w700),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accent,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
