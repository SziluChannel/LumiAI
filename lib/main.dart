import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For your API Key

// Import the theme provider
import 'package:lumiai/features/settings/providers/theme_provider.dart';

// Auth and Login
import 'package:lumiai/features/auth/ui/login_screen.dart'; // Import LoginScreen
import 'package:lumiai/features/accessibility/font_size_feature.dart'; // For fontSizeProvider

Future<void> main() async {
  // 1. Ensure Flutter bindings are initialized before async code
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load the .env file (Since your GeminiApiClient uses it)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Only print error if not found, don't stop the app
    print("Error loading .env file: $e");
  }

  // 3. Wrap the app in ProviderScope for Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

// MyApp is a ConsumerWidget for Riverpod usage
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the computed full ThemeData object.
    final appTheme = ref.watch(selectedAppThemeProvider);

    // Watch the global font size scale factor
    final fontSizeState = ref.watch(fontSizeProvider);

    return MaterialApp(
      title: 'LumiAI',
      debugShowCheckedModeBanner: false,

      // Set the full ThemeData object from the provider.
      theme: appTheme,

      // Global font size scaling for all Text widgets
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(fontSizeState.scaleFactor)),
          child: child!,
        );
      },

      // This is the main screen which handles the set UI mode (standard/simplified).
      home: const LoginScreen(), // Set LoginScreen as the initial screen
    );
  }
}
