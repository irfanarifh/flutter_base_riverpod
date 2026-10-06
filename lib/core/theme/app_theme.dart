import 'package:flutter/material.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_radius.dart';
import 'package:flutter_template/core/theme/app_text_styles.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primarySeed,
      brightness: Brightness.light,
    );
    return _buildTheme(colorScheme);
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primarySeed,
      brightness: Brightness.dark,
    );
    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
        clipBehavior: Clip.antiAlias,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        TextTheme(
          displayLarge: AppTextStyles.displayLarge.copyWith(color: colorScheme.onSurface),
          displayMedium: AppTextStyles.displayMedium.copyWith(color: colorScheme.onSurface),
          displaySmall: AppTextStyles.displaySmall.copyWith(color: colorScheme.onSurface),
          headlineLarge: AppTextStyles.headlineLarge.copyWith(color: colorScheme.onSurface),
          headlineMedium: AppTextStyles.headlineMedium.copyWith(color: colorScheme.onSurface),
          headlineSmall: AppTextStyles.headlineSmall.copyWith(color: colorScheme.onSurface),
          titleLarge: AppTextStyles.titleLarge.copyWith(color: colorScheme.onSurface),
          titleMedium: AppTextStyles.titleMedium.copyWith(color: colorScheme.onSurface),
          titleSmall: AppTextStyles.titleSmall.copyWith(color: colorScheme.onSurface),
          bodyLarge: AppTextStyles.bodyLarge.copyWith(color: colorScheme.onSurface),
          bodyMedium: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
          bodySmall: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
          labelLarge: AppTextStyles.labelLarge.copyWith(color: colorScheme.onSurface),
          labelMedium: AppTextStyles.labelMedium.copyWith(color: colorScheme.onSurfaceVariant),
          labelSmall: AppTextStyles.labelSmall.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
