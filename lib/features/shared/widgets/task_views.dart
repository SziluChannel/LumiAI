import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Shows the captured image and asks for confirmation
class ConfirmationView extends StatelessWidget {
  final XFile imageFile;
  final VoidCallback onConfirm;
  final VoidCallback onRetake;

  const ConfirmationView({
    super.key,
    required this.imageFile,
    required this.onConfirm,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: kIsWeb
              ? Image.network(imageFile.path)
              : Image.file(File(imageFile.path)),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BigButton(
                label: "Retake",
                icon: Icons.refresh,
                color: Colors.red,
                onTap: onRetake,
              ),
              _BigButton(
                label: "Confirm",
                icon: Icons.check,
                color: Colors.green,
                onTap: onConfirm,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ResultView extends StatelessWidget {
  final String text;
  final VoidCallback onDone;
  final bool isStreaming; // <--- NEW PARAMETER

  const ResultView({
    super.key,
    required this.text,
    required this.onDone,
    this.isStreaming = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Visual indicator changes based on state
        isStreaming
            ? const CircularProgressIndicator() // Small spinner while typing
            : const Icon(Icons.check_circle, size: 100, color: Colors.green),

        const SizedBox(height: 20),

        // The Scrollable Text Area
        Expanded(
          child: SingleChildScrollView(
            reverse: true, // Auto-scroll to bottom as new text arrives
            padding: const EdgeInsets.all(20.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 24, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Button is disabled or hidden while streaming to prevent premature exit
        // (Or you could change it to a "Stop" button)
        _BigButton(
          label: isStreaming ? "Listening..." : "Done",
          icon: isStreaming ? Icons.hearing : Icons.home,
          color: isStreaming ? Colors.grey : Colors.blue,
          onTap: isStreaming ? () {} : onDone, // No-op while streaming
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _BigButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BigButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        textStyle: TextStyle(fontSize: 24),
      ),
      icon: Icon(icon, size: 40),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
