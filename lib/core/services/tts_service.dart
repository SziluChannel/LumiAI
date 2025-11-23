import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tts_service.g.dart';

@Riverpod(keepAlive: true)
TtsService ttsService(Ref ref) {
  return TtsService();
}

/// A service class to manage Text-to-Speech functionality.
class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  /// Private constructor to initialize the TTS engine with default settings.
  TtsService() {
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
