import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/core/features/feature_action.dart';
import 'package:lumiai/core/features/feature_controller.dart';
import 'package:lumiai/features/settings/ui/settings_screen.dart';

class MinimalFunctionalUI extends ConsumerWidget {
  const MinimalFunctionalUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featureController = ref.read(featureControllerProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MinimalMenuButton(
          label: 'Identify Object',
          icon: Icons.camera_alt,
          onPressed: () {
            featureController.handleAction(FeatureAction.identifyObject);
          },
        ),
        _MinimalMenuButton(
          label: 'Read Text',
          icon: Icons.text_fields,
          onPressed: () {
            featureController.handleAction(FeatureAction.readText);
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

class _MinimalMenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _MinimalMenuButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor.withAlpha(200),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          icon: Icon(icon, size: 60),
          label: Text(label, style: const TextStyle(fontSize: 32)),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
