// lib/presentation/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color tomatoRed = Color(0xFFE94E4E);
  static const Color creamBeige = Color(0xFFF5EBD9);
  static const Color freshGreen = Color(0xFFA8C66C);
  static const Color warmBrown = Color(0xFF8C5E3C);
  static const Color orangePeel = Color(0xFFF77F00);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: tomatoRed,
      scaffoldBackgroundColor: creamBeige,
      colorScheme: const ColorScheme.light(
        primary: tomatoRed,
        secondary: orangePeel,
        surface: creamBeige,
        background: creamBeige,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: warmBrown,
        onBackground: warmBrown,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: creamBeige,
        elevation: 0,
        iconTheme: IconThemeData(color: warmBrown),
        titleTextStyle: TextStyle(
            color: warmBrown, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tomatoRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: orangePeel,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: warmBrown),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: tomatoRed,
        unselectedItemColor: warmBrown,
        showUnselectedLabels: true,
      ),
    );
  }
}