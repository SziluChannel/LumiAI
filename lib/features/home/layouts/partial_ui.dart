import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/core/features/feature_action.dart';
import 'package:lumiai/core/features/feature_controller.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'package:lumiai/features/settings/providers/tts_settings_provider.dart';

class PartialFunctionalUI extends ConsumerWidget {
  const PartialFunctionalUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildMenu(context, ref);
  }

  Widget _buildMenu(BuildContext context, WidgetRef ref) {
    final featureController = ref.read(featureControllerProvider.notifier);
    // Watch settings for the temporary sliders
    final ttsSettings = ref.watch(ttsSettingsControllerProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionHeader(title: "Object & Scene"),
        _FeatureCard(
          children: [
            _FeatureButton(
              label: "Identify Object",
              icon: Icons.camera_alt,
              onPressed: () {
                featureController.handleAction(FeatureAction.identifyObject);
              },
            ),
            _FeatureButton(
              label: "Describe Scene",
              icon: Icons.landscape,
              onPressed: () {
                featureController.handleAction(FeatureAction.describeScene);
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        _SectionHeader(title: "Text Assistance"),
        _FeatureCard(
          children: [
            _FeatureButton(
              label: "Read Text",
              icon: Icons.text_fields,
              onPressed: () {
                featureController.handleAction(FeatureAction.readText);
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        _SectionHeader(title: "Chat"),
        _FeatureCard(
          children: [
            _FeatureButton(
              label: "Live Chat",
              icon: Icons.chat,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LiveChatScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

// --- styled widgets for Partial UI ---

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final List<Widget> children;
  const _FeatureCard({required this.children});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: children,
        ),
      ),
    );
  }
}

class _FeatureButton extends ConsumerWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  // Removed const keyword from constructor because of dynamic scaleFactor
  const _FeatureButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSizeProvider = pr.Provider.of<FontSizeProvider>(context);
    final double scaleFactor = fontSizeProvider.scaleFactor;

    return InkWell(
      onTap: () {
        ref.read(feedbackServiceProvider).triggerSuccessFeedback();
        onPressed();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 120 * scaleFactor, // Scale button width
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40 * scaleFactor,
              color: Theme.of(context).primaryColor,
            ), // Scale icon size
            SizedBox(height: 8 * scaleFactor), // Scale spacing, removed const
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16 * scaleFactor, // Scale text size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
