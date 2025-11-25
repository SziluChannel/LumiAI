import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'ui_mode_provider.g.dart';

enum UiMode { standard, simplified }

const _kUiModeKey = 'ui_mode';

@Riverpod(keepAlive: true)
class UiModeController extends _$UiModeController {
  
  late final SharedPreferences _prefs;
  
  @override
  // AsyncNotifier-t használunk, a kezdőállapot aszinkron betöltődik
  Future<UiMode> build() async {
    _prefs = await SharedPreferences.getInstance();

    final savedModeString = _prefs.getString(_kUiModeKey);

    if (savedModeString == null) {
      return UiMode.standard; // Alapértelmezett
    }

    return UiMode.values.firstWhere(
      (mode) => mode.name == savedModeString,
      orElse: () => UiMode.standard,
    );
  }

  // Segédmetódus a mentéshez
  Future<void> _saveMode(UiMode mode) async {
    state = AsyncValue.data(mode); // Frissíti a provider állapotát
    await _prefs.setString(_kUiModeKey, mode.name); // Elmenti a tárolóba
  }

  void toggleMode() {
    if (state.hasValue) {
      final currentMode = state.requireValue;
      final newMode = currentMode == UiMode.standard
          ? UiMode.simplified
          : UiMode.standard;
      _saveMode(newMode);
    }
  }

  void setMode(UiMode mode) {
    if (state.hasValue) {
      _saveMode(mode);
    }
  }
}