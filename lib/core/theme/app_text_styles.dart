import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto';

  // Main headings
  static const TextStyle headingLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    height: 1.2,
    color: AppColors.lightText,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.25,
    color: AppColors.lightText,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.lightText,
  );

  // Section headings
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.lightText,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.lightText,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.lightText,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.lightSecondaryText,
  );

  // Buttons
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  // Product information
  static const TextStyle productName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.lightText,
  );

  static const TextStyle productPrice = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
    color: AppColors.primaryDark,
  );

  static const TextStyle oldPrice = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
    color: AppColors.lightSecondaryText,
  );

  // Navigation
  static const TextStyle navigationLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  // Dark mode helpers
  static TextStyle darkHeading({double fontSize = 24}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
      color: AppColors.darkText,
    );
  }

  static TextStyle darkBody({double fontSize = 14}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      height: 1.5,
      color: AppColors.darkSecondaryText,
    );
  }
}
