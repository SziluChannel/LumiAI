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
    
    // Figyeljük a kiszámított ThemeMode-ot, ami olvassa a mentett beállítást.
    final themeMode = ref.watch(materialThemeModeProvider);

    return MaterialApp(
      title: 'LumiAI',
      debugShowCheckedModeBanner: false,
      
      // 1. Beállítjuk a themeMode-ot a provider értékére
      themeMode: themeMode, 

      // 2. Világos téma (Light Theme)
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, 
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      
      // 3. Sötét téma (Dark Theme)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, 
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      // Ez a fő képernyő, ami a beállított UI módot (standard/simplified) is kezeli.
      home: const LoginScreen(), // Set LoginScreen as the initial screen
    );
  }
}
