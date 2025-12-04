import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';

class AppTheme {
  static ThemeData getTheme(String languageCode, String themeName) {
    switch (themeName) {
      case 'forest':
        return _forestTheme(languageCode);
      case 'ocean':
        return _oceanTheme(languageCode);
      case 'asir':
        return _asirTheme(languageCode);
      default:
        return _honeyTheme(languageCode);
    }
  }

  static ThemeData _honeyTheme(String languageCode) {
    final isArabic = languageCode == 'ar';
    final baseTextTheme = isArabic ? GoogleFonts.cairoTextTheme() : GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: TextTheme(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        titleSmall: baseTextTheme.titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16, color: AppColors.textPrimary),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, color: AppColors.textPrimary),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, color: AppColors.textSecondary),
        labelLarge: baseTextTheme.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: baseTextTheme.labelMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
        labelSmall: baseTextTheme.labelSmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: (isArabic ? GoogleFonts.cairo() : GoogleFonts.poppins()).copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSmall)),
          textStyle: (isArabic ? GoogleFonts.cairo() : GoogleFonts.poppins()).copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMedium)),
        color: Colors.white,
      ),
    );
  }

  static ThemeData _forestTheme(String languageCode) {
    final isArabic = languageCode == 'ar';
    final baseTextTheme = isArabic ? GoogleFonts.cairoTextTheme() : GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF2E7D32),
        secondary: const Color(0xFF558B2F),
        surface: Colors.white,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: const Color(0xFFF1F8E9),
      textTheme: TextTheme(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        titleSmall: baseTextTheme.titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16, color: AppColors.textPrimary),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, color: AppColors.textPrimary),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, color: AppColors.textSecondary),
        labelLarge: baseTextTheme.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: baseTextTheme.labelMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
        labelSmall: baseTextTheme.labelSmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: (isArabic ? GoogleFonts.cairo() : GoogleFonts.poppins()).copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSmall)),
          textStyle: (isArabic ? GoogleFonts.cairo() : GoogleFonts.poppins()).copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMedium)),
        color: Colors.white,
      ),
    );
  }

  static ThemeData _oceanTheme(String languageCode) {
    final isArabic = languageCode == 'ar';
    final baseTextTheme = isArabic ? GoogleFonts.cairoTextTheme() : GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF0277BD),
        secondary: const Color(0xFF0288D1),
        surface: Colors.white,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: const Color(0xFFE1F5FE),
      textTheme: TextTheme(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        titleSmall: baseTextTheme.titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16, color: AppColors.textPrimary),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, color: AppColors.textPrimary),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, color: AppColors.textSecondary),
        labelLarge: baseTextTheme.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: baseTextTheme.labelMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
        labelSmall: baseTextTheme.labelSmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF0277BD),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: (isArabic ? GoogleFonts.cairo() : GoogleFonts.poppins()).copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0277BD),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSmall)),
          textStyle: (isArabic ? GoogleFonts.cairo() : GoogleFonts.poppins()).copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: const BorderSide(color: Color(0xFF0277BD), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMedium)),
        color: Colors.white,
      ),
    );
  }

  static ThemeData _asirTheme(String languageCode) {
    final isArabic = languageCode == 'ar';
    final baseTextTheme = isArabic ? GoogleFonts.cairoTextTheme() : GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF8B6F47),
        secondary: const Color(0xFFD4A574),
        surface: Colors.white,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: const Color(0xFFFAF8F3),
      textTheme: TextTheme(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        titleSmall: baseTextTheme.titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16, color: AppColors.textPrimary),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, color: AppColors.textPrimary),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, color: AppColors.textSecondary),
        labelLarge: baseTextTheme.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: baseTextTheme.labelMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
        labelSmall: baseTextTheme.labelSmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF8B6F47),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: (isArabic ? GoogleFonts.cairo() : GoogleFonts.poppins()).copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B6F47),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSmall)),
          textStyle: (isArabic ? GoogleFonts.cairo() : GoogleFonts.poppins()).copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: const BorderSide(color: Color(0xFF8B6F47), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMedium)),
        color: Colors.white,
      ),
    );
  }
}
