import 'package:flutter/material.dart';

/// Design tokens for BOB.
///
/// Palette rules that must be respected across the app:
/// - Gold accent is for ACTIONS only (buttons, primary calls to action).
/// - Green and red are for DATA signals only (price direction, indicators),
///   never on buttons.
/// - Teal backgrounds are for immersive surfaces (splash, onboarding, chat
///   header), off-white surfaces carry the main light-mode content.
class AppColors {
  const AppColors._();

  // Teal canvas.
  static const Color bgBase = Color(0xFF0B2E2C);
  static const Color bgElevated = Color(0xFF0F3B38);
  static const Color bgSunken = Color(0xFF082523);

  // Off-white surfaces.
  static const Color surface = Color(0xFFF4F1E9);
  static const Color surfaceAlt = Color(0xFFE8E4D8);
  static const Color surfaceLine = Color(0xFFD6D1C4);

  // Text.
  static const Color textOnTeal = Color(0xFFF4F1E9);
  static const Color textOnTeal2 = Color(0xFFA9C4C0);
  static const Color textPrimary = Color(0xFF14312F);
  static const Color textSecondary = Color(0xFF5A6B69);

  // Gold accent, for actions only.
  static const Color accent = Color(0xFFE9B84A);
  static const Color accentPress = Color(0xFFC99A2F);

  /// Dark text placed on top of the gold accent (buttons).
  static const Color textOnAccent = Color(0xFF2A2000);

  // Data signals, never on buttons.
  static const Color bullish = Color(0xFF22C55E);
  static const Color bullishSoft = Color(0xFF16351F);
  static const Color bearish = Color(0xFFFF5A4D);
  static const Color bearishSoft = Color(0xFF3A1614);
  static const Color neutral = Color(0xFF9AA8A6);

  // Radii.
  static const double radiusCard = 18.0;
  static const double radiusSmall = 12.0;

  /// Fully rounded pill shape used by primary buttons.
  static const double radiusPill = 999.0;
}
