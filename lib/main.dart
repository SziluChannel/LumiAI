import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lumiai/src/minimal_ui.dart'; // Import the minimal UI
import 'package:lumiai/src/partial_ui.dart'; // Import the partial UI

Future<void> main() async {
  //await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LumiAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

/// A StatefulWidget to switch between MinimalFunctionalUI and PartialFunctionalUI.
class UIModeSwitcher extends StatefulWidget {
  const UIModeSwitcher({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
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
