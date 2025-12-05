import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'haptic_feedback_provider.g.dart';

const _kHapticFeedbackEnabledKey = 'haptic_feedback_enabled';

@Riverpod(keepAlive: true)
class HapticFeedbackController extends _$HapticFeedbackController {
  late final SharedPreferences _prefs;

  @override
  Future<bool> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(_kHapticFeedbackEnabledKey) ?? true;
  }

  void setHapticFeedback(bool isEnabled) {
    state = AsyncValue.data(isEnabled);
    _prefs.setBool(_kHapticFeedbackEnabledKey, isEnabled);
  }
}
