import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardLight,
        background: AppColors.bgLight,
        error: Colors.redAccent,
      ),
      scaffoldBackgroundColor: AppColors.bgLight,
      textTheme:
          GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
        titleLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: AppColors.textLightPrimary,
        ),
        titleMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          color: AppColors.textLightPrimary,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: AppColors.textLightPrimary,
        ),
        bodyMedium: GoogleFonts.outfit(
          color: AppColors.textLightSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cardLight,
        elevation: 0,
        scrolledUnderElevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textLightPrimary),
        titleTextStyle: GoogleFonts.outfit(
          color: AppColors.textLightPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        labelStyle: GoogleFonts.outfit(color: AppColors.textLightSecondary),
        hintStyle: GoogleFonts.outfit(
            color: AppColors.textLightSecondary.withOpacity(0.7)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLightSecondary,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardDark,
        background: AppColors.bgDark,
        error: Colors.redAccent,
      ),
      scaffoldBackgroundColor: AppColors.bgDark,
      textTheme:
          GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        titleLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: AppColors.textDarkPrimary,
        ),
        titleMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          color: AppColors.textDarkPrimary,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: AppColors.textDarkPrimary,
        ),
        bodyMedium: GoogleFonts.outfit(
          color: AppColors.textDarkSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textDarkPrimary),
        titleTextStyle: GoogleFonts.outfit(
          color: AppColors.textDarkPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        labelStyle: GoogleFonts.outfit(color: AppColors.textDarkSecondary),
        hintStyle: GoogleFonts.outfit(
            color: AppColors.textDarkSecondary.withOpacity(0.7)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textDarkSecondary,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
