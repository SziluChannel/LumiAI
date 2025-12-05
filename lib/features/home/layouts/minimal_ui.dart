import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/core/constants/app_prompts.dart';
import 'package:lumiai/core/services/feedback_service.dart';
import 'package:lumiai/features/global_listening/global_listening_controller.dart';
import 'package:lumiai/features/live_chat/ui/live_chat_screen.dart';
import 'package:lumiai/features/settings/ui/settings_screen.dart';
import 'package:provider/provider.dart' as pr; // Alias for Provider.of
import 'package:lumiai/features/accessibility/font_size_feature.dart'; // For FontSizeProvider

class MinimalFunctionalUI extends ConsumerWidget {
  const MinimalFunctionalUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalController = ref.read(
      globalListeningControllerProvider.notifier,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MinimalMenuButton(
          label: 'Identify Object',
          icon: Icons.camera_alt,
          onPressed: () {
            // Send prompt directly - model will open camera, analyze, and speak
            globalController.sendUserPrompt(AppPrompts.identifyObjectLive);
          },
        ),
        _MinimalMenuButton(
          label: 'Read Text',
          icon: Icons.text_fields,
          onPressed: () {
            // Send read text prompt
            globalController.sendUserPrompt(AppPrompts.readText);
          },
        ),
        _MinimalMenuButton(
          label: 'Live Chat',
          icon: Icons.chat,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LiveChatScreen()),
            );
          },
        ),
        _MinimalMenuButton(
          label: 'Settings',
          icon: Icons.settings,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }
}

class _MinimalMenuButton extends ConsumerWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  // Removed const keyword due to dynamic scaling
  const _MinimalMenuButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSizeProvider = pr.Provider.of<FontSizeProvider>(context);
    final double scaleFactor = fontSizeProvider.scaleFactor;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(16.0 * scaleFactor), // Scale padding
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor.withAlpha(200),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20 * scaleFactor), // Scale border radius
            ),
            padding: EdgeInsets.symmetric(horizontal: 16 * scaleFactor, vertical: 12 * scaleFactor), // Scale padding
          ),
          icon: Icon(icon, size: 60 * scaleFactor), // Scale icon size
          label: Text(
            label,
            style: TextStyle(
              fontSize: 32 * scaleFactor, // Scale text size
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            ref.read(feedbackServiceProvider).triggerSuccessFeedback();
            onPressed();
          },
        ),
      ),
    );
  }
}
