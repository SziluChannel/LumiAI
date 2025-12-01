import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/live_chat/ui/live_chat_screen.dart';
import '../object_id_controller.dart';
import '../object_id_state.dart';
import '../../shared/widgets/task_views.dart';

/// Shared widget for handling ObjectId task flow in both minimal and partial UIs.
/// This ensures consistent behavior across different UI modes.
class ObjectIdTaskHandler extends ConsumerWidget {
  const ObjectIdTaskHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectIdState = ref.watch(objectIdControllerProvider);
    final objectIdController = ref.read(objectIdControllerProvider.notifier);

    return switch (objectIdState.status) {
      // ERROR STATE
      ObjectIdStatus.error => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              "Error: ${objectIdState.errorMessage}",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: objectIdController.reset,
              child: const Text("Close"),
            ),
          ],
        ),
      ),

      // LOADING/PROCESSING STATE
      ObjectIdStatus.processing => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 6),
            SizedBox(height: 20),
            Text("Analyzing...", style: TextStyle(fontSize: 24)),
          ],
        ),
      ),

      // CONFIRMATION STATE
      ObjectIdStatus.confirmingImage => ConfirmationView(
        imageFile: objectIdState.imageFile!,
        onRetake: objectIdController.retakeImage,
        onConfirm: objectIdController.confirmAndAnalyze,
      ),

      // STREAMING OR SUCCESS STATE
      ObjectIdStatus.streaming || ObjectIdStatus.success => ResultView(
        text: objectIdState.resultText ?? "",
        isStreaming: objectIdState.status == ObjectIdStatus.streaming,
        onDone: objectIdController.reset,
        // Live Chat button - appears when analysis is complete
        onDeepDive: () async {
          final imageFile = objectIdState.imageFile;
          if (imageFile != null) {
            final bytes = await imageFile.readAsBytes();

            if (context.mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LiveChatScreen(imageBytes: bytes),
                ),
              );
            }
          }
        },
      ),

      // IDLE or unknown - should not happen, but be safe
      _ => const SizedBox.shrink(),
    };
  }
}
