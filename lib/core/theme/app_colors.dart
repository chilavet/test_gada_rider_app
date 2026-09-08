import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFFFF5C00); // Gada signature orange
  static const Color primaryLight = Color(0xFFFF7A28);
  static const Color primaryDark = Color(0xFFCC4A00);
  static const Color darkCta = Color(0xFF101010); // Figma pure black for buttons & cards

  // Light Mode Background & Surfaces (Figma Exact)
  static const Color background = Color(0xFFF9F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF3F4F6);
  static const Color surfaceLight = Color(0xFFF3F4F6);
  static const Color surfaceDark = Color(0xFF101010);
  static const Color cardBorder = Color(0xFFEBEBEF);

  // Dark / Night Mode Background & Surfaces
  static const Color backgroundNight = Color(0xFF0D0D11);
  static const Color surfaceNight = Color(0xFF16161C);
  static const Color surfaceElevatedNight = Color(0xFF202028);
  static const Color cardBorderNight = Color(0xFF272732);

  // Light Mode Text
  static const Color textPrimary = Color(0xFF101010);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkMuted = Color(0xFF9E9E9E);

  // Night Mode Text
  static const Color textPrimaryNight = Color(0xFFF8F9FA);
  static const Color textSecondaryNight = Color(0xFFA1A1AA);
  static const Color textTertiaryNight = Color(0xFF71717A);

  // Status & Feedback
  static const Color onlineGreen = Color(0xFF10B981);
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFE8F8F0);

  static const Color offlineGray = Color(0xFF9CA3AF);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEE2E2);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoBg = Color(0xFFEFF6FF);

  // Chips & Badges
  static const Color chipBackground = Color(0xFFF3F4F6);
  static const Color chipBorder = Color(0xFFE5E7EB);

  // Dynamic Theme Helpers
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color getBackground(BuildContext context) =>
      isDark(context) ? backgroundNight : background;

  static Color getSurface(BuildContext context) =>
      isDark(context) ? surfaceNight : surface;

  static Color getSurfaceElevated(BuildContext context) =>
      isDark(context) ? surfaceElevatedNight : surfaceElevated;

  static Color getCardBorder(BuildContext context) =>
      isDark(context) ? cardBorderNight : cardBorder;

  static Color getTextPrimary(BuildContext context) =>
      isDark(context) ? textPrimaryNight : textPrimary;

  static Color getTextSecondary(BuildContext context) =>
      isDark(context) ? textSecondaryNight : textSecondary;

  static Color getTextTertiary(BuildContext context) =>
      isDark(context) ? textTertiaryNight : textTertiary;
}
