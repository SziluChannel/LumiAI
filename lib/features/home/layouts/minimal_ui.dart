import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/core/features/feature_action.dart';
import 'package:lumiai/core/services/feedback_service.dart';
import 'package:lumiai/core/features/feature_controller.dart';
import 'package:lumiai/features/live_chat/ui/live_chat_screen.dart';
import 'package:lumiai/features/settings/ui/settings_screen.dart';
import 'package:lumiai/features/accessibility/font_size_feature.dart'; // For fontSizeProvider
import 'package:lumiai/core/l10n/app_localizations.dart';

class MinimalFunctionalUI extends ConsumerWidget {
  const MinimalFunctionalUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featureController = ref.read(featureControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MinimalMenuButton(
          label: l10n.identifyObject,
          icon: Icons.camera_alt,
          onPressed: () {
            featureController.handleAction(FeatureAction.identifyObject);
          },
        ),
        _MinimalMenuButton(
          label: l10n.readText,
          icon: Icons.text_fields,
          onPressed: () {
            featureController.handleAction(FeatureAction.readText);
          },
        ),
        _MinimalMenuButton(
          label: l10n.readCurrency,
          icon: Icons.attach_money,
          onPressed: () {
            featureController.handleAction(FeatureAction.readCurrency);
          },
        ),
        _MinimalMenuButton(
          label: l10n.liveChat,
          icon: Icons.chat,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LiveChatScreen()),
            );
          },
        ),
        _MinimalMenuButton(
          label: l10n.settings,
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
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSizeState = ref.watch(fontSizeProvider);
    final double scaleFactor = fontSizeState.scaleFactor;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(16.0 * scaleFactor), // Scale padding
        child: InkWell(
          onTap: () async {
            await ref.read(feedbackServiceProvider).triggerSuccessFeedback();
            onPressed();
          },
          borderRadius: BorderRadius.circular(20 * scaleFactor),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFF5C6BC0), // Indigo blue
                  const Color(0xFF7E57C2), // Soft purple
                  const Color(0xFF7E57C2), // Soft purple
                  const Color(0xFF5C6BC0), // Indigo blue
                ],
                stops: const [0.0, 0.15, 0.85, 1.0], // Blue only at edges
              ),
              borderRadius: BorderRadius.circular(20 * scaleFactor),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withAlpha(80),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16 * scaleFactor,
              vertical: 16 * scaleFactor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 60 * scaleFactor,
                  color: const Color(0xFFFFD54F),
                ),
                SizedBox(width: 12 * scaleFactor),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 32 * scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFD54F), // Vibrant amber/gold
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
