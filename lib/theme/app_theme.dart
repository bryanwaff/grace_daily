import 'package:flutter/material.dart';
import 'package:grace_daily/theme/gdaily_colors.dart';
import 'package:grace_daily/theme/gdaily_typography.dart';

/// Defines the global application themes based on the Lumen Grace design system.
class AppTheme {
  // --- Light Theme Configuration ---
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light, // Explicitly set to light mode

    // 1. Core Color Scheme (Material 3 approach)
    // This defines the primary, secondary, and other key colors used throughout the app.
    colorScheme: ColorScheme.light(
      primary: GdailyColors.primaryOlive, // Primary brand color
      onPrimary: Colors.white, // Color for text/icons placed on primary color
      secondary: GdailyColors.secondaryGold, // Secondary accent color
      onSecondary: Colors.white, // Color for text/icons placed on secondary color
      tertiary: GdailyColors.primaryLightOlive, // An additional accent color (example)
      onTertiary: GdailyColors.textDark,

      error: GdailyColors.errorRed, // Error indicator color
      onError: Colors.white, // Text/icons on error color

      background: GdailyColors.backgroundLight, // Main screen background color
      onBackground: GdailyColors.textDark, // Text/icons on background

      // surface: GdailyColors.surface, // Default surface color for cards, sheets, dialogs
      onSurface: GdailyColors.textDark, // Text/icons on surface

      // Optional: More granular colors from Material 3 if needed
      surfaceVariant: GdailyColors.dividerLight, // A lighter surface variant
      onSurfaceVariant: GdailyColors.textMedium,
      outline: GdailyColors.dividerLight, // For borders, dividers
      shadow: Colors.black12, // For shadows
    ),

    // Backwards compatibility for older widgets that might still use primaryColor
    primaryColor: GdailyColors.primaryOlive,

    // Define the default background color for Scaffolds
    scaffoldBackgroundColor: GdailyColors.backgroundLight,

    // 2. Typography Configuration
    // Assign our custom TextTheme which maps Lumen Grace styles to Material 3 text roles.
    textTheme: GdailyTypography.lightTextTheme,

    // 3. Shape Configuration (Default BorderRadius.circular(8.0))

    // Card Theme
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Apply to cards
      ),
      elevation: 2, // Consistent elevation for cards
      color: GdailyColors.surface, // Cards typically use the surface color
      margin: const EdgeInsets.all(8.0), // Default margin for cards
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Apply to elevated buttons
        ),
        backgroundColor: GdailyColors.primaryOlive, // Primary button background
        foregroundColor: Colors.white, // Text/icon color on primary button
        // Leverage GdailyTypography for button text style
        textStyle: GdailyTypography.lightTextTheme.labelLarge?.copyWith(
          color: Colors.white, // Ensure text is white on primary background
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 2,
        minimumSize: const Size(double.infinity, 48), // Ensure buttons are reasonably sized
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Apply to outlined buttons
        ),
        side: const BorderSide(color: GdailyColors.primaryOlive, width: 1.5), // Olive border
        foregroundColor: GdailyColors.primaryOlive, // Olive text/icon
        textStyle: GdailyTypography.lightTextTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: const Size(double.infinity, 48), // Ensure buttons are reasonably sized
      ),
    ),

    // Text Button Theme (for flat, low-emphasis buttons)
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: GdailyColors.primaryOlive,
        textStyle: GdailyTypography.lightTextTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    // Input Field (TextFormField/TextField) Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0), // Apply to input field borders
        borderSide: const BorderSide(color: GdailyColors.dividerLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: GdailyColors.primaryOlive, width: 2), // Focused border
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: GdailyColors.dividerLight, width: 1), // Enabled border
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: GdailyColors.errorRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: GdailyColors.errorRed, width: 2),
      ),
      fillColor: Colors.white, // Background color of the input field
      filled: true,
      hintStyle: GdailyTypography.lightTextTheme.bodyMedium?.copyWith(
        color: GdailyColors.textLight, // Hint text color
      ),
      labelStyle: GdailyTypography.lightTextTheme.bodyMedium,
      errorStyle: GdailyTypography.lightTextTheme.bodySmall?.copyWith(color: GdailyColors.errorRed),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      floatingLabelBehavior: FloatingLabelBehavior.auto, // Labels float above input
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: GdailyColors.backgroundLight, // Light background for app bars
      foregroundColor: GdailyColors.textDark, // Default text/icon color on app bar
      elevation: 0, // Often 0 for flat, modern designs
      centerTitle: true, // Center app bar titles by default
      // Leveraging GdailyTypography directly for the title style (IMPROVEMENT applied)
      titleTextStyle: GdailyTypography.lightTextTheme.titleLarge?.copyWith(
        color: GdailyColors.textDark, // Ensure title color matches
        fontSize: 20, // Override base titleLarge size if needed for app bar
      ),
      iconTheme: const IconThemeData(color: GdailyColors.textDark), // App bar icon colors
      actionsIconTheme: const IconThemeData(color: GdailyColors.textDark), // Action icons
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Apply to dialogs
      ),
      backgroundColor: GdailyColors.surface,
      titleTextStyle: GdailyTypography.lightTextTheme.titleMedium?.copyWith(color: GdailyColors.textDark),
      contentTextStyle: GdailyTypography.lightTextTheme.bodyMedium?.copyWith(color: GdailyColors.textDark),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: GdailyColors.primaryOlive,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Often slightly larger radius for FAB
      ),
      elevation: 4,
    ),

    // Divider Theme (for visual separators)
    dividerTheme: const DividerThemeData(
      color: GdailyColors.dividerLight,
      thickness: 1,
      space: 1,
      indent: 16,
      endIndent: 16,
    ),

    // Splash Color for inkwell/button presses
    splashColor: GdailyColors.primaryLightOlive.withOpacity(0.2),
    highlightColor: GdailyColors.primaryLightOlive.withOpacity(0.1),

    // Scrollbar Theme (if desired for consistent scrollbar appearance)
    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: MaterialStateProperty.all(true),
      thickness: MaterialStateProperty.all(4.0),
      radius: const Radius.circular(10),
      thumbColor: MaterialStateProperty.all(GdailyColors.primaryOlive.withOpacity(0.7)),
      minThumbLength: 50.0,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: GdailyColors.textDark,
      size: 24.0,
    ),
  );

// --- Dark Theme Configuration (Optional, for future implementation) ---
// If the Lumen Grace design system includes specific styling for a dark mode,
// define a separate 'darkTheme' here.
// static ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: const ColorScheme.dark(
//     primary: GdailyColors.primaryDarkOlive,
//     onPrimary: Colors.white,
//     secondary: GdailyColors.secondaryDarkGold,
//     onSecondary: Colors.white,
//     error: GdailyColors.errorRed,
//     onError: Colors.white,
//     background: GdailyColors.backgroundDark,
//     onBackground: Colors.white,
//     surface: GdailyColors.backgroundDark,
//     onSurface: Colors.white,
//     surfaceVariant: GdailyColors.textMedium, // Lighter variant for dark mode
//     onSurfaceVariant: GdailyColors.textLight,
//     outline: GdailyColors.textMedium,
//   ),
//   scaffoldBackgroundColor: GdailyColors.backgroundDark,
//   textTheme: GdailyTypography.darkTextTheme, // Assuming a darkTextTheme exists
//   // ... apply dark mode specific shapes and other properties
// );
}