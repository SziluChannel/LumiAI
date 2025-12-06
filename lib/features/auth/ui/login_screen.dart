import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/home/home_screen.dart'; // Import the actual HomeScreen
import 'package:lumiai/core/services/biometric_auth_service.dart'; // Import BiometricAuthService
import 'package:lumiai/core/services/feedback_service.dart'; // Import FeedbackService

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage;
  bool _isBiometricAvailable = false; // New state variable

  // Removed direct instantiation


  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final biometricService = ref.read(biometricAuthServiceProvider);
    final bool available = await biometricService.canCheckBiometrics();
    setState(() {
      _isBiometricAvailable = available;
    });
  }

  Future<void> _authenticateBiometrics() async {
    final biometricService = ref.read(biometricAuthServiceProvider);
    final bool authenticated = await biometricService.authenticate();
    if (authenticated) {
      // Success Condition: Navigate to HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // Failure Condition: Show SnackBar feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric authentication failed or canceled.')),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // CRITICAL LOGIC REQUIREMENT: Hardcoded credentials for demonstration
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == 'user' && password == 'password') {
      // Success Condition
      setState(() {
        _errorMessage = null; // Clear any previous errors
      });
      ref.read(feedbackServiceProvider).triggerSuccessFeedback(); // Trigger success haptic feedback
      // Navigate to the actual HomeScreen using Navigator.of(context).pushReplacement(...)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // Failure Condition
      setState(() {
        _errorMessage = 'Incorrect username or password.';
      });
      ref.read(feedbackServiceProvider).triggerErrorFeedback(); // Trigger error haptic feedback
      // The Semantics(liveRegion: true) widget will ensure this error is announced.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input Fields (Username & Password):
            // TextField with clear labelText for screen reader announcement.
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                // Password Visibility Toggle:
                // IconButton wrapped in a Semantics widget with dynamic label.
                suffixIcon: Semantics(
                  label: _isPasswordVisible ? 'Hide password' : 'Show password',
                  button: true, // Mark it as a button for screen readers
                  child: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                      ref.read(feedbackServiceProvider).triggerSuccessFeedback(); // Trigger success haptic feedback on toggle
                    },
                  ),
                ),
              ),
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onSubmitted: (_) => _login(), // Allow login on keyboard done action
            ),
            const SizedBox(height: 24.0),
            // Error Reporting (Live Region):
            // The error message text must be wrapped in a Semantics widget with liveRegion: true.
            if (_errorMessage != null)
              Semantics(
                liveRegion: true, // Ensures immediate announcement by screen readers
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
            ),
            const SizedBox(height: 24.0),
            // Login Button
            SizedBox(
              width: double.infinity,
              height: 48.0, // WCAG recommended minimum tappable size
              child: ElevatedButton(
                onPressed: _login,
                child: const Text('Login', style: TextStyle(fontSize: 18.0)),
              ),
            ),
            // Biometric Login Button
            if (_isBiometricAvailable) ...[
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 48.0, // WCAG recommended minimum tappable size
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.fingerprint, size: 24.0),
                  label: const Text('Login with Fingerprint/Face ID', style: TextStyle(fontSize: 18.0)),
                  onPressed: _authenticateBiometrics,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
