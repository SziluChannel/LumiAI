import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../object_id/object_id_controller.dart';
import '../../object_id/object_id_state.dart';
import '../../object_id/ui/object_id_task_handler.dart';
import 'package:lumiai/features/settings/ui/settings_screen.dart';

class MinimalFunctionalUI extends ConsumerWidget {
  const MinimalFunctionalUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectIdState = ref.watch(objectIdControllerProvider);
    final objectIdController = ref.read(objectIdControllerProvider.notifier);

    // If a task is active, show the shared task handler
    if (objectIdState.status != ObjectIdStatus.idle) {
      return const ObjectIdTaskHandler();
    }

    // Otherwise, show the minimal menu
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MinimalMenuButton(
          label: 'Identify Object',
          icon: Icons.camera_alt,
          onPressed: objectIdController.captureImage,
        ),
        _MinimalMenuButton(
          label: 'Read Text',
          icon: Icons.text_fields,
          onPressed: () {
            // Call TextReaderController.captureImage()
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
