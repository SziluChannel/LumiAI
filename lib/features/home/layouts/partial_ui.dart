import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'package:lumiai/features/settings/providers/tts_settings_provider.dart'; // Import settings
import '../../object_id/object_id_controller.dart';
import '../../object_id/object_id_state.dart';
import '../../shared/widgets/task_views.dart';

class PartialFunctionalUI extends ConsumerWidget {
  const PartialFunctionalUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the Logic
    final objectIdState = ref.watch(objectIdControllerProvider);

    // If we are doing a task, hijack the screen to show the task flow
    // This ensures consistency between minimal and partial modes
    if (objectIdState.status != ObjectIdStatus.idle) {
      return Scaffold(
        appBar: AppBar(title: Text("Processing...")),
        body: _buildActiveTaskView(ref, objectIdState),
      );
    }

    // Otherwise, show the fancy menu
    return _buildMenu(context, ref);
  }

  Widget _buildActiveTaskView(WidgetRef ref, ObjectIdState state) {
    final controller = ref.read(objectIdControllerProvider.notifier);

    return switch (state.status) {
      ObjectIdStatus.processing => const Center(
        child: CircularProgressIndicator(),
      ),
      ObjectIdStatus.confirmingImage => ConfirmationView(
        imageFile: state.imageFile!,
        onRetake: controller.retakeImage,
        onConfirm: controller.confirmAndAnalyze,
      ),
      ObjectIdStatus.success => ResultView(
        text: state.resultText!,
        onDone: controller.reset,
      ),
      ObjectIdStatus.error => Center(
        child: Column(
          children: [
            Text("Error: ${state.errorMessage}"),
            ElevatedButton(onPressed: controller.reset, child: Text("Close")),
          ],
        ),
      ),
      _ => SizedBox.shrink(),
    };
  }

  Widget _buildMenu(BuildContext context, WidgetRef ref) {
    final objectIdController = ref.read(objectIdControllerProvider.notifier);
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
              onPressed: objectIdController.captureImage,
            ),
            _FeatureButton(
              label: "Describe Scene",
              icon: Icons.landscape,
              onPressed: () {
                /* Add specific logic */
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
                /* trigger text reader */
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        _SectionHeader(title: "Debug"),
        _FeatureCard(
          children: [
            _FeatureButton(
              label: "Test TTS",
              icon: Icons.record_voice_over,
              onPressed: () {
                ref
                    .read(ttsServiceProvider)
                    .speak("This is a test of the text to speech system.");
              },
            ),
          ],
        ),

        // --- TEMPORARY DEBUG CONTROLS (Easy to remove) ---
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors
                .yellow
                .shade100, // Distinct color to remind you to remove it
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "TEMP: TTS Controls",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Row(
                children: [
                  Text("Pitch: ${ttsSettings.pitch.toStringAsFixed(1)}"),
                  Expanded(
                    child: Slider(
                      value: ttsSettings.pitch,
                      min: 0.5,
                      max: 2.0,
                      divisions: 15,
                      onChanged: (val) => ref
                          .read(ttsSettingsControllerProvider.notifier)
                          .setPitch(val),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Speed: ${ttsSettings.speed.toStringAsFixed(1)}"),
                  Expanded(
                    child: Slider(
                      value: ttsSettings.speed,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      onChanged: (val) => ref
                          .read(ttsSettingsControllerProvider.notifier)
                          .setSpeed(val),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // -------------------------------------------------
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

class _FeatureButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _FeatureButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
