import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv is not used in the current implementation
import 'package:lumiai/src/minimal_ui.dart'; // Import the minimal UI
import 'package:lumiai/src/partial_ui.dart'; // Import the partial UI

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // Commented out as dotenv is not used
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _currentThemeMode = ThemeMode.light; // Start with light theme

  void _toggleThemeMode() {
    setState(() {
      _currentThemeMode = _currentThemeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LumiAI',
      theme: ThemeData(
        // Use a modern color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent, // A modern primary color
          brightness: Brightness.light, // Default to light theme
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // White AppBar background
          foregroundColor: Colors.black87, // Darker text for contrast
          elevation: 1.0, // Subtle shadow for depth
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Text/icon color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        // Dark theme colors
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent, // Keep the same seed color for consistency
          brightness: Brightness.dark, // Use dark theme
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // Dark AppBar background
          foregroundColor: Colors.white, // White text for contrast
          elevation: 1.0, // Subtle shadow for depth
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Text/icon color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
      // Use themeMode to switch between light and dark themes
      themeMode: _currentThemeMode, // Apply the current theme mode
      home: UIModeSwitcher( // Pass theme control to UIModeSwitcher
        currentThemeMode: _currentThemeMode,
        onThemeModeChanged: _toggleThemeMode,
      ),
    );
  }
}

/// A StatefulWidget to switch between MinimalFunctionalUI and PartialFunctionalUI,
/// and also to manage the theme mode (light/dark).
class UIModeSwitcher extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final VoidCallback onThemeModeChanged;

  const UIModeSwitcher({
    super.key,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
  });

  @override
  State<UIModeSwitcher> createState() => _UIModeSwitcherState();
}

class _UIModeSwitcherState extends State<UIModeSwitcher> {
  bool _isMinimalMode = true; // Start with minimal mode by default

  void _toggleUIMode() {
    setState(() {
      _isMinimalMode = !_isMinimalMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access theme colors for consistent styling
    final theme = Theme.of(context);
    final appBarColor = theme.appBarTheme.backgroundColor ?? theme.primaryColor;
    final appBarTextColor = theme.appBarTheme.foregroundColor ?? Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isMinimalMode ? 'LumiAI - Minimal Mode' : 'LumiAI - Partial Mode'),
        backgroundColor: appBarColor,
        foregroundColor: appBarTextColor,
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(widget.currentThemeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            tooltip: widget.currentThemeMode == ThemeMode.light ? 'Switch to Dark Mode' : 'Switch to Light Mode',
            onPressed: widget.onThemeModeChanged, // Use the passed callback
          ),
        ],
      ),
      body: _isMinimalMode ? const MinimalFunctionalUI() : const PartialFunctionalUI(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleUIMode,
        label: Text(_isMinimalMode ? 'Switch to Partial UI' : 'Switch to Minimal UI'),
        icon: const Icon(Icons.swap_horiz),
        tooltip: 'Toggle UI Mode',
        backgroundColor: theme.primaryColor, // Use theme primary color for FAB
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
