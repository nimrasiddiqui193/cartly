import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand colors
  static const Color primary = Color(0xFFE68A45);
  static const Color primaryDark = Color(0xFFC96B2C);
  static const Color primaryLight = Color(0xFFFFB879);
  static const Color accent = Color(0xFFFFC58A);

  // Light theme
  static const Color lightBackground = Color(0xFFF7F7F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF202124);
  static const Color lightSecondaryText = Color(0xFF777777);
  static const Color lightBorder = Color(0xFFEAE8E4);
  static const Color lightDivider = Color(0xFFF0EEEA);

  // Dark theme
  static const Color darkBackground = Color(0xFF141414);
  static const Color darkSurface = Color(0xFF1D1D1D);
  static const Color darkCard = Color(0xFF242424);
  static const Color darkElevated = Color(0xFF2C2C2C);
  static const Color darkText = Color(0xFFF5F2EE);
  static const Color darkSecondaryText = Color(0xFFAAA39B);
  static const Color darkBorder = Color(0xFF383532);
  static const Color darkDivider = Color(0xFF302D2A);

  // Status colors
  static const Color success = Color(0xFF2E9D69);
  static const Color error = Color(0xFFD9534F);
  static const Color warning = Color(0xFFE7A23B);
  static const Color info = Color(0xFF438BCB);

  // Common colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // Light theme shadows
  static List<BoxShadow> lightCardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.045),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  // Dark theme shadows
  static List<BoxShadow> darkCardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.22),
      blurRadius: 20,
      offset: const Offset(0, 7),
    ),
  ];

  // Brand gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Premium dark gradient
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF303030), Color(0xFF1B1B1B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
