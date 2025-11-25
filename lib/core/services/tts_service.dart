import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumiai/features/settings/providers/tts_settings_provider.dart';

part 'tts_service.g.dart';

@Riverpod(keepAlive: true)
TtsService ttsService(Ref ref) {
  final service = TtsService();

  // 1. Listen to settings changes and update the service immediately
  ref.listen(ttsSettingsControllerProvider, (previous, next) {
    service.setPitch(next.pitch);
    service.setRate(next.speed);
  });

  // 2. Apply initial settings (in case they are already loaded)
  final currentSettings = ref.read(ttsSettingsControllerProvider);
  service.setPitch(currentSettings.pitch);
  service.setRate(currentSettings.speed);

  return service;
}

/// A service class to manage Text-to-Speech functionality.
class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  /// Private constructor to initialize the TTS engine with default settings.
  TtsService() {
    _flutterTts.setLanguage("en-US");
    // Defaults are now managed by the provider, but we keep these as fallbacks
    _flutterTts.setSpeechRate(1);
    _flutterTts.setPitch(1.5);
    _flutterTts.awaitSpeakCompletion(true);
    _flutterTts.setVolume(1.0);
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

  // --- Configuration Methods ---

  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }

  Future<void> setRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }
}
