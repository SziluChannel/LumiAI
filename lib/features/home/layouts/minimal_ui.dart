import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../object_id/object_id_controller.dart';
import '../../object_id/object_id_state.dart';
import '../../shared/widgets/task_views.dart';

class MinimalFunctionalUI extends ConsumerWidget {
  const MinimalFunctionalUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the Logic
    final objectIdState = ref.watch(objectIdControllerProvider);
    final objectIdController = ref.read(objectIdControllerProvider.notifier);

    // 1. ERROR STATE
    if (objectIdState.status == ObjectIdStatus.error) {
      return Center(child: Text("Error: ${objectIdState.errorMessage}"));
    }

    // 2. LOADING STATE
    if (objectIdState.status == ObjectIdStatus.processing) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 6),
            SizedBox(height: 20),
            Text("Analyzing...", style: TextStyle(fontSize: 24)),
          ],
        ),
      );
    }

    // 3. CONFIRMATION STATE
    if (objectIdState.status == ObjectIdStatus.confirmingImage) {
      return ConfirmationView(
        imageFile: objectIdState.imageFile!,
        onRetake: objectIdController.retakeImage,
        onConfirm: objectIdController.confirmAndAnalyze,
      );
    }

    // 4. STREAMING OR SUCCESS STATE
    if (objectIdState.status == ObjectIdStatus.success ||
        objectIdState.status == ObjectIdStatus.streaming) {
      return ResultView(
        text: objectIdState.resultText ?? "",
        onDone: objectIdController.reset,
        isStreaming: objectIdState.status == ObjectIdStatus.streaming,
      );
    }

    // 5. IDLE (MAIN MENU)
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
          onPressed: () {},
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
