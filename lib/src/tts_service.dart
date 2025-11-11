import 'package:flutter_tts/flutter_tts.dart';

// 1. Make the class private by adding an underscore.
class _TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  // Private constructor
  _TtsService() {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.8);
    _flutterTts.setPitch(1.5);
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}

// 2. Create and export a single, global instance of the service.
// This is the variable you will use everywhere in your app.
final ttsService = _TtsService();
