import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumiai/features/settings/providers/tts_settings_provider.dart';

part 'tts_service.g.dart';

class VoiceOption {
  final String name;
  final String identifier;

  const VoiceOption({required this.name, required this.identifier});
}

// These are example voices, actual availability depends on device/platform.
// You might fetch them dynamically using _flutterTts.getVoices()
const List<VoiceOption> _defaultVoices = [
  VoiceOption(name: "Woman 1 (US)", identifier: "en-US-Wavenet-F"),
  VoiceOption(name: "Woman 2 (US)", identifier: "en-US-Wavenet-E"),
  VoiceOption(name: "Man 1 (US)", identifier: "en-US-Wavenet-A"),
];

@Riverpod(keepAlive: true)
Future<TtsService> ttsService(Ref ref) async {
  final service = TtsService();
  await service.init(); // Await initialization of voices

  // 1. Listen to settings changes and update the service immediately
  ref.listen(ttsSettingsControllerProvider, (previous, next) {
    service.setPitch(next.pitch);
    service.setRate(next.speed);
    service.setVoice(next.selectedVoice);
    service.setLanguage(next.language);
  });

  // 2. Apply initial settings (in case they are already loaded)
  final currentSettings = ref.read(ttsSettingsControllerProvider);
  service.setPitch(currentSettings.pitch);
  service.setRate(currentSettings.speed);
  service.setVoice(currentSettings.selectedVoice);
  service.setLanguage(currentSettings.language);

  return service;
}

/// A service class to manage Text-to-Speech functionality.
class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  List<VoiceOption> _availableVoices = _defaultVoices;

  List<VoiceOption> get availableVoices => _availableVoices;

  /// Private constructor to initialize the TTS engine with default settings.
  TtsService() {
    _flutterTts.setLanguage("en-US");
    // Defaults are now managed by the provider, but we keep these as fallbacks
    _flutterTts.setSpeechRate(1);
    _flutterTts.setPitch(1.5);
    _flutterTts.awaitSpeakCompletion(true);
    _flutterTts.setVolume(1.0);
  }

  Future<void> init() async {
    await _initVoices();
  }

  Future<void> _initVoices() async {
    try {
      final voices = await _flutterTts.getVoices;
      if (voices != null) {
        // Filter for US English voices and map to VoiceOption
        _availableVoices = voices
            .where((v) => v['locale'] == 'en-US' && v['name'] != null)
            .map(
              (v) => VoiceOption(
                name: v['name'] as String,
                identifier: v['name'] as String,
              ),
            )
            .toList();

        // Add a fallback if no specific voices are found
        if (_availableVoices.isEmpty) {
          _availableVoices = _defaultVoices;
        }
        debugPrint(
          'Available voices: ${_availableVoices.map((v) => v.name).join(', ')}',
        );
      }
    } catch (e) {
      debugPrint('Error getting voices: $e');
      _availableVoices = _defaultVoices; // Fallback to default on error
    }
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

  Future<void> setVoice(String? voiceIdentifier) async {
    if (voiceIdentifier != null && voiceIdentifier.isNotEmpty) {
      await _flutterTts.setVoice({"name": voiceIdentifier, "locale": "en-US"});
    }
  }

  Future<void> setLanguage(String language) async {
    await _flutterTts.setLanguage(language);
  }
}
