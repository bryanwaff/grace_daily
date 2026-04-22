import 'package:flutter/material.dart';
import 'package:grace_daily/theme/gdaily_colors.dart';


/// Defines the typography styles for the Lumen Grace design system.
/// Uses 'Newsreader' (Serif) for display/headlines and 'Manrope' (Sans-serif) for body/labels.
class GdailyTypography {
  // Private constants for font family names, ensuring consistency
  static const String _newsreader = 'Newsreader'; // Serif font for prominence
  static const String _manrope = 'Manrope';     // Sans-serif font for readability

  // --- Light Text Theme Configuration ---
  // This TextTheme maps standard Material Design text styles to our custom Lumen Grace styles.
  static TextTheme lightTextTheme = TextTheme(
    // Display styles (large, impactful text - often Newsreader)
    displayLarge: const TextStyle(
      fontFamily: _newsreader,
      fontSize: 57,
      fontWeight: FontWeight.bold,
      color: GdailyColors.textDark, // Use textDark for primary display
    ),
    displayMedium: const TextStyle(
      fontFamily: _newsreader,
      fontSize: 45,
      fontWeight: FontWeight.bold,
      color: GdailyColors.textDark,
    ),
    displaySmall: const TextStyle(
      fontFamily: _newsreader,
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: GdailyColors.textDark,
    ),

    // Headline styles (section titles, important headers - often Newsreader or bold Manrope)
    headlineLarge: const TextStyle(
      fontFamily: _newsreader,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: GdailyColors.textDark,
    ),
    headlineMedium: const TextStyle(
      fontFamily: _newsreader,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: GdailyColors.textDark,
    ),
    headlineSmall: const TextStyle(
      fontFamily: _newsreader,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: GdailyColors.textDark,
    ),

    // Title styles (smaller headers, app bar titles - usually Manrope or slightly lighter Newsreader)
    titleLarge: const TextStyle(
      fontFamily: _manrope, // Manrope for cleaner titles
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: GdailyColors.textDark,
    ),
    titleMedium: const TextStyle(
      fontFamily: _manrope,
      fontSize: 18,
      fontWeight: FontWeight.w600, // Semi-bold Manrope
      color: GdailyColors.textDark,
    ),
    titleSmall: const TextStyle(
      fontFamily: _manrope,
      fontSize: 16,
      fontWeight: FontWeight.w500, // Medium Manrope
      color: GdailyColors.textDark,
    ),

    // Body styles (main content text - typically Manrope for readability)
    bodyLarge: const TextStyle(
      fontFamily: _manrope,
      fontSize: 16,
      fontWeight: FontWeight.normal, // Regular weight Manrope
      color: GdailyColors.textDark,
      height: 1.5, // Good line spacing for readability
    ),
    bodyMedium: const TextStyle(
      fontFamily: _manrope,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: GdailyColors.textDark,
      height: 1.4,
    ),
    bodySmall: const TextStyle(
      fontFamily: _manrope,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: GdailyColors.textMedium, // Slightly lighter for secondary body text
      height: 1.3,
    ),

    // Label styles (buttons, captions, tags - usually Manrope)
    labelLarge: const TextStyle(
      fontFamily: _manrope,
      fontSize: 14,
      fontWeight: FontWeight.bold, // Bold for buttons
      letterSpacing: 0.5, // Common for labels/buttons
      color: GdailyColors.textDark,
    ),
    labelMedium: const TextStyle(
      fontFamily: _manrope,
      fontSize: 12,
      fontWeight: FontWeight.w600, // Semi-bold
      letterSpacing: 0.4,
      color: GdailyColors.textDark,
    ),
    labelSmall: const TextStyle(
      fontFamily: _manrope,
      fontSize: 10,
      fontWeight: FontWeight.w500, // Medium
      letterSpacing: 0.5,
      color: GdailyColors.textMedium, // Lighter for small captions
    ),
  );

// --- Dark Text Theme (Optional, for future implementation) ---
// If the Lumen Grace design system includes specific typography for a dark mode,
// define a separate 'darkTextTheme' here. This would typically involve:
// - Using GdailyColors.textLight or Colors.white for text color.
// - Potentially adjusting weights or sizes if the design system specifies it.
// static TextTheme darkTextTheme = TextTheme(
//   displayLarge: const TextStyle(
//     fontFamily: _newsreader,
//     fontSize: 57,
//     fontWeight: FontWeight.bold,
//     color: GdailyColors.textLight, // Lighter text color for dark mode
//   ),
//   // ... define all other text styles for dark mode
// );
}