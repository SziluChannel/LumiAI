import 'package:flutter_tts/flutter_tts.dart';

/// The singleton instance of the Text-to-Speech service.
final ttsService = _TtsService();

/// A service class to manage Text-to-Speech functionality.
///
/// This class is private and should not be instantiated directly.
/// Use the global [ttsService] instance instead.
class _TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  /// Private constructor to initialize the TTS engine with default settings.
  _TtsService() {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.8);
    _flutterTts.setPitch(1.5);
  }

  /// Speaks the given [text] using the device's TTS engine.
  ///
  /// Does nothing if the [text] is empty.
  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  /// Immediately stops the current speech.
  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
