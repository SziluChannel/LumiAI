import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/core/services/feedback_service.dart';

// =========================================================
// 1. CONFIRMATION VIEW (Image + Confirm/Retake)
// =========================================================

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
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: kIsWeb
                  ? Image.network(imageFile.path, fit: BoxFit.contain)
                  : Image.file(File(imageFile.path), fit: BoxFit.contain),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                label: "Retake",
                icon: Icons.refresh,
                color: Colors.red.shade700,
                onTap: onRetake,
              ),
              _ActionButton(
                label: "Confirm",
                icon: Icons.check,
                color: Colors.green.shade700,
                onTap: onConfirm,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =========================================================
// 2. RESULT VIEW (Text + Actions + Deep Dive)
// =========================================================

class ResultView extends StatelessWidget {
  final String text;
  final VoidCallback onDone;
  final VoidCallback? onAskMore; // Optional: For the quick Mic (if used)
  final VoidCallback? onStopAsk; // Optional: Stop quick Mic
  final VoidCallback? onDeepDive; // <--- NEW: Open the Live Chat Screen

  final bool isStreaming;
  final bool isListening;

  const ResultView({
    super.key,
    required this.text,
    required this.onDone,
    this.onAskMore,
    this.onStopAsk,
    this.onDeepDive,
    this.isStreaming = false,
    this.isListening = false,
  });

  @override
  Widget build(BuildContext context) {
    // 1. LISTENING OVERLAY (Black screen with Big Mic)
    if (isListening && onStopAsk != null) {
      return GestureDetector(
        onTap: onStopAsk,
        child: Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mic, color: Colors.redAccent, size: 120),
              const SizedBox(height: 30),
              const Text(
                "Listening...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Tap screen when done",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    // 2. STANDARD RESULT VIEW
    return Column(
      children: [
        // Status Icon or Spinner
        isStreaming
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: Colors.white),
              )
            : const Padding(
                padding: EdgeInsets.all(20),
                child: Icon(Icons.check_circle, size: 80, color: Colors.green),
              ),

        // Text Content
        Expanded(
          child: SingleChildScrollView(
            reverse: true, // Auto-scrolls to bottom
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 24,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ACTION BUTTONS
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 16),

                // Exit Button
                _ActionButton(
                  label: "Exit",
                  icon: Icons.exit_to_app,
                  color: Colors.blueGrey,
                  onTap: onDone,
                ),

                const SizedBox(width: 16),

                // Deep Dive (Live Chat) Button
                // Only show if we are not currently streaming text
                if (!isStreaming && onDeepDive != null)
                  _ActionButton(
                    label: "Live Chat",
                    icon: Icons.chat_bubble,
                    color: Colors.purple.shade700,
                    onTap: onDeepDive!,
                  ),

                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =========================================================
// 3. PRIVATE HELPER WIDGETS
// =========================================================

/// A consistent, large button style used across both views.
class _ActionButton extends ConsumerWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      icon: Icon(icon, size: 32),
      label: Text(label, style: const TextStyle(fontSize: 22)),
      onPressed: () {
        ref.read(feedbackServiceProvider).triggerSuccessFeedback();
        onTap();
      },
    );
  }
}
