import 'package:flutter/material.dart';

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
    // Basic validation logic
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == 'user' && password == 'password') {
      setState(() {
        _errorMessage = null; // Clear any previous errors
      });
      // Handle successful login (e.g., navigate to home screen)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
      // In a real app, you would navigate away
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      setState(() {
        _errorMessage = 'Incorrect username or password.';
      });
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
            // Username Input Field
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
            // Password Input Field
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: Semantics(
                  label: _isPasswordVisible ? 'Hide password' : 'Show password',
                  button: true,
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
              onSubmitted: (_) => _login(),
            ),
            const SizedBox(height: 24.0),
            // Error Reporting
            if (_errorMessage != null)
              Semantics(
                liveRegion: true,
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
              height: 48.0, // Ensure minimum tappable size
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
