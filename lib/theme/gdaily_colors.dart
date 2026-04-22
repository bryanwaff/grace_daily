import 'package:flutter/material.dart';

/// Lumen Grace Design System Color Palette
/// Based on the official design guide for the Grace Daily app
class GdailyColors {
  // === PRIMARY PALETTE ===
  /// Primary Olive Green - #6C7E44
  /// Main brand color used for primary buttons, highlights, and key UI elements
  static const Color primaryOlive = Color(0xFF6C7E44);
  static const Color primaryOliveDark = Color(0xFF556035);
  static const Color primaryOliveLight = Color(0xFF8FA05C);

  // === SECONDARY PALETTE ===
  /// Secondary Muted Green - #737A5F
  /// Used for secondary buttons, accents, and supporting UI elements
  static const Color secondaryMuted = Color(0xFF737A5F);
  static const Color secondaryMutedDark = Color(0xFF5D6249);
  static const Color secondaryMutedLight = Color(0xFF8F9777);

  // === TERTIARY PALETTE ===
  /// Tertiary Gold/Brown - #88763B
  /// Used for tertiary buttons, warm accents, and badges
  static const Color tertiaryGold = Color(0xFF88763B);
  static const Color tertiaryGoldDark = Color(0xFF6B5D2E);
  static const Color tertiaryGoldLight = Color(0xFFA69452);

  // === NEUTRAL PALETTE ===
  /// Neutral Cream/Off-White - #FDFBF7
  /// Primary background and light surfaces
  static const Color neutralLight = Color(0xFFFDFBF7);
  
  /// Dark text for primary content
  static const Color textDark = Color(0xFF333333);
  
  /// Medium text for secondary content
  static const Color textMedium = Color(0xFF666666);
  
  /// Light text for disabled/placeholder text
  static const Color textLight = Color(0xFF999999);

  // === BACKGROUND & SURFACE ===
  /// Light background for screens and cards
  static const Color backgroundLight = Color(0xFFFDFBF7);
  
  /// Dark background (for potential dark mode or specific sections)
  static const Color backgroundDark = Color(0xFF2C2C2C);
  
  /// White surface, primary card background
  static const Color surface = Colors.white;
  
  /// Light divider color for subtle separators
  static const Color dividerLight = Color(0xFFE0E0E0);

  // === FUNCTIONAL COLORS ===
  /// Success feedback color
  static const Color successGreen = Color(0xFF4CAF50);
  
  /// Warning feedback color
  static const Color warningOrange = Color(0xFFFF9800);
  
  /// Error feedback color
  static const Color errorRed = Color(0xFFF44336);

  // === ICON BUTTON COLORS ===
  /// Yellow icon button background
  static const Color iconYellow = Color(0xFFFDD835);
  
  /// Light green icon button background
  static const Color iconLightGreen = Color(0xFFC6E7A9);
  
  /// Red icon button background
  static const Color iconRed = Color(0xFFC5333A);
}