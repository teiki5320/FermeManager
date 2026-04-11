import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palette Kultiva — pastel japonais kawaii.
class KultivaColors {
  const KultivaColors._();

  // --- Thème clair ---
  static const Color lightBackground = Color(0xFFF5FAF8);
  static const Color primaryGreen = Color(0xFF4A9B5A);
  static const Color lightGreen = Color(0xFFA8D5A2);
  static const Color terracotta = Color(0xFFE8A87C);
  static const Color textPrimary = Color(0xFF2A4A3A);
  static const Color textSecondary = Color(0xFF8AAB8A);
  static const Color lightCard = Color(0xFFFFFFFF);

  // --- Thème sombre ---
  static const Color darkBackground = Color(0xFF0F1F18);
  static const Color darkSurface = Color(0xFF1A2E22);
  static const Color darkPrimaryGreen = Color(0xFF5ABD6A);
  static const Color darkCard = Color(0xFF1F3528);

  // --- Dégradés saisonniers (fallback si pas d'image asset) ---
  static const Color springA = Color(0xFFFBD8E6);
  static const Color springB = Color(0xFFBCE5C1);
  static const Color summerA = Color(0xFFFFE7A0);
  static const Color summerB = Color(0xFFA8D5A2);
  static const Color autumnA = Color(0xFFF8CBA6);
  static const Color autumnB = Color(0xFFE8A87C);
  static const Color winterA = Color(0xFFE0EEFB);
  static const Color winterB = Color(0xFFC6D8E3);
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    final scheme = ColorScheme.fromSeed(
      seedColor: KultivaColors.primaryGreen,
      brightness: Brightness.light,
      primary: KultivaColors.primaryGreen,
      secondary: KultivaColors.terracotta,
      surface: KultivaColors.lightCard,
      onSurface: KultivaColors.textPrimary,
    );
    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: KultivaColors.lightBackground,
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).apply(
        bodyColor: KultivaColors.textPrimary,
        displayColor: KultivaColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: KultivaColors.lightBackground,
        foregroundColor: KultivaColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          color: KultivaColors.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
      cardTheme: CardTheme(
        color: KultivaColors.lightCard,
        elevation: 2,
        shadowColor: KultivaColors.primaryGreen.withOpacity(0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: KultivaColors.lightGreen.withOpacity(0.35),
        selectedColor: KultivaColors.primaryGreen,
        labelStyle: GoogleFonts.nunito(
          color: KultivaColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        secondaryLabelStyle: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KultivaColors.primaryGreen,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w800),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: KultivaColors.primaryGreen,
          textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: KultivaColors.textPrimary,
          textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w700),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: KultivaColors.lightGreen),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: KultivaColors.lightGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: KultivaColors.lightGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide:
              const BorderSide(color: KultivaColors.primaryGreen, width: 2),
        ),
        hintStyle:
            GoogleFonts.nunito(color: KultivaColors.textSecondary),
        labelStyle:
            GoogleFonts.nunito(color: KultivaColors.textSecondary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: KultivaColors.primaryGreen,
        unselectedItemColor: KultivaColors.textSecondary,
        selectedLabelStyle:
            GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 12),
        unselectedLabelStyle:
            GoogleFonts.nunito(fontWeight: FontWeight.w600, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(
        color: KultivaColors.lightGreen.withOpacity(0.5),
        thickness: 1,
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final scheme = ColorScheme.fromSeed(
      seedColor: KultivaColors.darkPrimaryGreen,
      brightness: Brightness.dark,
      primary: KultivaColors.darkPrimaryGreen,
      secondary: KultivaColors.terracotta,
      surface: KultivaColors.darkCard,
      onSurface: Colors.white,
    );
    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: KultivaColors.darkBackground,
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: KultivaColors.darkBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
      cardTheme: CardTheme(
        color: KultivaColors.darkCard,
        elevation: 2,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: KultivaColors.darkSurface,
        selectedColor: KultivaColors.darkPrimaryGreen,
        labelStyle:
            GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.w700),
        secondaryLabelStyle: GoogleFonts.nunito(
          color: Colors.black,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KultivaColors.darkPrimaryGreen,
          foregroundColor: Colors.black,
          textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w800),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: KultivaColors.darkPrimaryGreen,
          textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w700),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: KultivaColors.darkSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
              color: KultivaColors.darkPrimaryGreen, width: 2),
        ),
        hintStyle: GoogleFonts.nunito(color: Colors.white.withOpacity(0.6)),
        labelStyle: GoogleFonts.nunito(color: Colors.white.withOpacity(0.6)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: KultivaColors.darkSurface,
        selectedItemColor: KultivaColors.darkPrimaryGreen,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        selectedLabelStyle:
            GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 12),
        unselectedLabelStyle:
            GoogleFonts.nunito(fontWeight: FontWeight.w600, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.12),
        thickness: 1,
      ),
    );
  }
}
