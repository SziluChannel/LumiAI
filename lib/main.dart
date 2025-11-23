import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For your API Key
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/home/home_screen.dart'; // <-- IMPORT THIS

void main() async {
  // 1. Ensure Flutter bindings are initialized before async code
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load the .env file (Since your GeminiApiClient uses it)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e");
  }

  // 3. Wrap the app in ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LumiAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define your standard theme here
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      // This should point to the HomeScreen we created earlier
      // which decides whether to show Minimal or Partial UI
      home: HomeScreen(),
    );
  }
}
