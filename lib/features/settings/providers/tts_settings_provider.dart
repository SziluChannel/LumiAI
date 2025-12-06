import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tts_settings_provider.g.dart';

class TtsSettingsState {
  final double pitch;
  final double speed;
  final String selectedVoice;

  const TtsSettingsState({
    this.pitch = 1.5, // Default matching your existing TtsService
    this.speed = 1.0, // Default matching your existing TtsService
    this.selectedVoice = "en-US-Wavenet-F", // Default voice
  });

  TtsSettingsState copyWith({double? pitch, double? speed, String? selectedVoice}) {
    return TtsSettingsState(
      pitch: pitch ?? this.pitch,
      speed: speed ?? this.speed,
      selectedVoice: selectedVoice ?? this.selectedVoice,
    );
  }
}

@Riverpod(keepAlive: true)
class TtsSettingsController extends _$TtsSettingsController {
  static const _pitchKey = 'tts_pitch';
  static const _speedKey = 'tts_speed';
  static const _voiceKey = 'tts_selected_voice';

  @override
  TtsSettingsState build() {
    // Load settings asynchronously on initialization
    _loadSettings();
    return const TtsSettingsState();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final pitch = prefs.getDouble(_pitchKey);
    final speed = prefs.getDouble(_speedKey);
    final voice = prefs.getString(_voiceKey);


    if (pitch != null || speed != null || voice != null) {
      state = state.copyWith(pitch: pitch, speed: speed, selectedVoice: voice);
    }
  }

  Future<void> setPitch(double pitch) async {
    state = state.copyWith(pitch: pitch);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_pitchKey, pitch);
  }

  Future<void> setSpeed(double speed) async {
    state = state.copyWith(speed: speed);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_speedKey, speed);
  }

  Future<void> setSelectedVoice(String voiceIdentifier) async {
    state = state.copyWith(selectedVoice: voiceIdentifier);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_voiceKey, voiceIdentifier);
  }
}
