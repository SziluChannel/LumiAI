import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

final biometricAuthServiceProvider = Provider<BiometricAuthService>((ref) {
  return BiometricAuthService();
});

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Checks if the device supports biometrics and has enrolled biometrics.
  Future<bool> canCheckBiometrics() async {
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) return false;

      final List<BiometricType> availableBiometrics = await _localAuth
          .getAvailableBiometrics();

      return availableBiometrics.isNotEmpty;
    } on PlatformException catch (e) {
      // Handle exceptions (e.g., no hardware, not enrolled)
      debugPrint("Error checking biometrics: $e");
      return false;
    }
  }

  /// Triggers the biometric authentication prompt.
  /// Returns true if authentication is successful, false otherwise.
  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to log in to LumiAI',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'LumiAI Biometric Login',
            cancelButton: 'Cancel',
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      // Handle exceptions (e.g., user canceled, no biometrics enrolled, locked out)
      debugPrint("Biometric authentication error: $e");
      return false;
    }
  }
}
