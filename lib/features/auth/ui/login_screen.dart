import 'package:flutter/material.dart';
import 'package:lumiai/features/home/home_screen.dart'; // Import the actual HomeScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage;

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
      // Navigate to the actual HomeScreen using Navigator.of(context).pushReplacement(...)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // Failure Condition
      setState(() {
        _errorMessage = 'Incorrect username or password.';
      });
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
            // Button & Tap Size:
            // The Login ElevatedButton must have a minimum height of 48.0 pixels.
            SizedBox(
              width: double.infinity,
              height: 48.0, // WCAG recommended minimum tappable size
              child: ElevatedButton(
                onPressed: _login,
                child: const Text('Login', style: TextStyle(fontSize: 18.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
