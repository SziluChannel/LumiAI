import 'package:flutter/material.dart';
import 'package:lumiai/src/minimal_ui.dart'; // Import the minimal UI
import 'package:lumiai/src/partial_ui.dart'; // Import the partial UI

Future<void> main() async {
  //await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LumiAI',
      theme: ThemeData(
        // Use a modern color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent, // A modern primary color
          brightness: Brightness.light, // Use light theme
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
      home: const UIModeSwitcher(), // Set UIModeSwitcher as the home
    );
  }
}

/// A StatefulWidget to switch between MinimalFunctionalUI and PartialFunctionalUI.
class UIModeSwitcher extends StatefulWidget {
  const UIModeSwitcher({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isMinimalMode ? 'LumiAI - Minimal Mode' : 'LumiAI - Partial Mode'),
        backgroundColor: _isMinimalMode ? Colors.black : Colors.deepPurple,
      ),
      body: _isMinimalMode ? const MinimalFunctionalUI() : const PartialFunctionalUI(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleUIMode,
        label: Text(_isMinimalMode ? 'Switch to Partial UI' : 'Switch to Minimal UI'),
        icon: const Icon(Icons.swap_horiz),
        tooltip: 'Toggle UI Mode',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
