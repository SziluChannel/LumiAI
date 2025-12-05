import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For your API Key

// ÚJ IMPORT: A témavezérlő provider importálása
import 'package:lumiai/features/settings/providers/theme_provider.dart'; 

// A meglévő Home Screen importálása
import 'package:lumiai/features/home/home_screen.dart';
import 'package:lumiai/features/auth/ui/login_screen.dart'; // Import LoginScreen

Future<void> main() async {
  // 1. Ensure Flutter bindings are initialized before async code
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load the .env file (Since your GeminiApiClient uses it)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Csak a hibát írjuk ki, ha nem találja, ne állítsa le az appot
    print("Error loading .env file: $e"); 
  }

  // 3. Wrap the app in ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}

// MyApp mostantól ConsumerWidget a Riverpod használatához
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    // Figyeljük a kiszámított teljes ThemeData objektumot.
    final appTheme = ref.watch(selectedAppThemeProvider);

    return MaterialApp(
      title: 'LumiAI',
      debugShowCheckedModeBanner: false,
      
      // A teljes ThemeData objektum beállítása a provider értékére.
      theme: appTheme,

      // Ez a fő képernyő, ami a beállított UI módot (standard/simplified) is kezeli.
      home: const LoginScreen(), // Set LoginScreen as the initial screen
    );
  }
}
