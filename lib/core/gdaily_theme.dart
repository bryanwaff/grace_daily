import 'package:flutter/material.dart';

class SacredTheme {
  static const Color primaryOlive = Color(0xFFEA638C);
  static const Color deepOlive = Color(0xFFF321B8);
  static const Color backgroundCream = Color(0xFFF9F8F4);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundCream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryOlive,
        primary: deepOlive,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Newsreader', fontSize: 32, fontStyle: FontStyle.italic),
        bodyLarge: TextStyle(fontFamily: 'Manrope', fontSize: 18),
      ),
    );
  }
}