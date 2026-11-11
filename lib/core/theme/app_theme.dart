import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primaryDark,
      surface: AppColors.lightSurface,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      fontFamily: AppTextStyles.fontFamily,

      // Main text theme
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.headingLarge,
        displayMedium: AppTextStyles.headingMedium,
        headlineLarge: AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        headlineSmall: AppTextStyles.headingSmall,
        titleLarge: AppTextStyles.headingMedium,
        titleMedium: AppTextStyles.sectionTitle,
        titleSmall: AppTextStyles.productName,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.button,
      ),

      // App bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightText,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headingSmall,
        iconTheme: IconThemeData(color: AppColors.lightText, size: 23),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      // Elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          disabledForegroundColor: AppColors.white,
          elevation: 3,
          shadowColor: AppColors.primary.withValues(alpha: 0.25),
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Outlined buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: const BorderSide(color: AppColors.primary, width: 1.2),
          minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Text buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 17,
        ),
        hintStyle: const TextStyle(
          color: AppColors.lightSecondaryText,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: AppColors.lightSecondaryText,
          fontSize: 14,
        ),
        prefixIconColor: AppColors.lightSecondaryText,
        suffixIconColor: AppColors.lightSecondaryText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      // Bottom navigation
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.13),
        elevation: 8,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            );
          }

          return const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.lightSecondaryText,
          );
        }),
      ),

      // Dividers
      dividerColor: AppColors.lightDivider,

      // Icons
      iconTheme: const IconThemeData(color: AppColors.lightText, size: 22),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),

      // Snackbars
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF292929),
        contentTextStyle: const TextStyle(color: AppColors.white, fontSize: 14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightBackground,
        selectedColor: AppColors.primary.withValues(alpha: 0.15),
        disabledColor: AppColors.lightDivider,
        labelStyle: const TextStyle(
          color: AppColors.lightText,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide.none,
      ),

      // Progress indicators
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.lightDivider,
      ),

      // Floating action button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 5,
        shape: CircleBorder(),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      surface: AppColors.darkSurface,
      error: const Color(0xFFFF7772),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      fontFamily: AppTextStyles.fontFamily,

      // Main text theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.darkHeading(fontSize: 30),
        displayMedium: AppTextStyles.darkHeading(fontSize: 26),
        headlineLarge: AppTextStyles.darkHeading(fontSize: 28),
        headlineMedium: AppTextStyles.darkHeading(fontSize: 24),
        headlineSmall: AppTextStyles.darkHeading(fontSize: 20),
        titleLarge: AppTextStyles.darkHeading(fontSize: 22),
        titleMedium: AppTextStyles.darkHeading(fontSize: 17),
        titleSmall: AppTextStyles.darkHeading(fontSize: 14),
        bodyLarge: AppTextStyles.darkBody(fontSize: 16),
        bodyMedium: AppTextStyles.darkBody(fontSize: 14),
        bodySmall: AppTextStyles.darkBody(fontSize: 12),
        labelLarge: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.darkText,
        ),
      ),

      // App bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.darkText,
        ),
        iconTheme: IconThemeData(color: AppColors.darkText, size: 23),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.35),
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      // Elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.35),
          disabledForegroundColor: AppColors.white,
          elevation: 4,
          shadowColor: AppColors.primary.withValues(alpha: 0.2),
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Outlined buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.65),
            width: 1.2,
          ),
          minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Text buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          textStyle: AppTextStyles.button,
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 17,
        ),
        hintStyle: const TextStyle(
          color: AppColors.darkSecondaryText,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: AppColors.darkSecondaryText,
          fontSize: 14,
        ),
        prefixIconColor: AppColors.darkSecondaryText,
        suffixIconColor: AppColors.darkSecondaryText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFF7772)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFF7772), width: 1.5),
        ),
      ),

      // Bottom navigation
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        elevation: 8,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLight,
            );
          }

          return const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.darkSecondaryText,
          );
        }),
      ),

      // Dividers
      dividerColor: AppColors.darkDivider,

      // Icons
      iconTheme: const IconThemeData(color: AppColors.darkText, size: 22),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkElevated,
        surfaceTintColor: Colors.transparent,
        elevation: 14,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),

      // Snackbars
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkElevated,
        contentTextStyle: const TextStyle(
          color: AppColors.darkText,
          fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkElevated,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        disabledColor: AppColors.darkSurface,
        labelStyle: const TextStyle(
          color: AppColors.darkText,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide.none,
      ),

      // Progress indicators
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryLight,
        linearTrackColor: AppColors.darkElevated,
      ),

      // Floating action button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 5,
        shape: CircleBorder(),
      ),
    );
  }
}
