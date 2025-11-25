import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tts_settings_provider.g.dart';

class TtsSettingsState {
  final double pitch;
  final double speed;

  const TtsSettingsState({
    this.pitch = 1.5, // Default matching your existing TtsService
    this.speed = 1.0, // Default matching your existing TtsService
  });

  TtsSettingsState copyWith({double? pitch, double? speed}) {
    return TtsSettingsState(
      pitch: pitch ?? this.pitch,
      speed: speed ?? this.speed,
    );
  }
}

@Riverpod(keepAlive: true)
class TtsSettingsController extends _$TtsSettingsController {
  static const _pitchKey = 'tts_pitch';
  static const _speedKey = 'tts_speed';

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

    if (pitch != null || speed != null) {
      state = state.copyWith(pitch: pitch, speed: speed);
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
}
