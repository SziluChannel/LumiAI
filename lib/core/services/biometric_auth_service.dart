import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Checks if the device supports biometrics and has enrolled biometrics.
  Future<bool> canCheckBiometrics() async {
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) return false;

      final List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();

      return availableBiometrics.isNotEmpty;
    } on PlatformException catch (e) {
      // Handle exceptions (e.g., no hardware, not enrolled)
      print("Error checking biometrics: $e");
      return false;
    }
  }

  /// Triggers the biometric authentication prompt.
  /// Returns true if authentication is successful, false otherwise.
  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authenticate to log in to LumiAI',
        options: const AuthenticationOptions(
          stickyAuth: true, // Keep the authentication UI on screen until app is in foreground again
          biometricOnly: true, // Only allow biometrics, no fallback to device PIN/pattern
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      // Handle exceptions (e.g., user canceled, no biometrics enrolled, locked out)
      print("Biometric authentication error: $e");
      return false;
    }
  }
}
