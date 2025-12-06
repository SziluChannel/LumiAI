import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'privacy_policy_provider.g.dart';

const _kPrivacyPolicyAcceptedKey = 'privacy_policy_accepted';

@Riverpod(keepAlive: true)
class PrivacyPolicyController extends _$PrivacyPolicyController {
  late final SharedPreferences _prefs;

  @override
  Future<bool> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(_kPrivacyPolicyAcceptedKey) ?? false;
  }

  Future<void> acceptPolicy() async {
    state = const AsyncValue.data(true);
    await _prefs.setBool(_kPrivacyPolicyAcceptedKey, true);
  }
}
