import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData highContrastTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black, // Deep, dark gray or black
    colorScheme: const ColorScheme.dark(
      primary: Colors.cyanAccent, // Vibrant color
      onPrimary: Colors.black, // Ensures text on primary is visible
      background: Colors.black,
      onBackground: Colors.white, // Pure white text
      surface: Colors.black,
      onSurface: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      // Add other text styles as needed
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    useMaterial3: true,
  );

  static final ThemeData colorblindTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Colors.blue, // Distinct blue
      secondary: Colors.deepOrange, // Distinct orange
      // Avoid red/green where these colors are used for differentiation
    ),
    useMaterial3: true,
  );

  static final ThemeData amoledTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF000000), // True black
    colorScheme: const ColorScheme.dark(
      background: Color(0xFF000000),
      surface: Color(0xFF000000),
      onBackground: Color(0xFFF2F2F2), // Soft, slightly off-white text
      onSurface: Color(0xFFF2F2F2),
      primary: Colors.blueAccent, // Example primary for dark theme
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFF2F2F2)),
      bodyMedium: TextStyle(color: Color(0xFFF2F2F2)),
      // Add other text styles as needed
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF000000),
      foregroundColor: Color(0xFFF2F2F2),
    ),
    useMaterial3: true,
  );
}
