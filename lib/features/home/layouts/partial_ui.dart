import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/core/constants/app_prompts.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'package:lumiai/features/global_listening/global_listening_controller.dart';
import 'package:lumiai/features/settings/providers/tts_settings_provider.dart';

class PartialFunctionalUI extends ConsumerWidget {
  const PartialFunctionalUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildMenu(context, ref);
  }

  Widget _buildMenu(BuildContext context, WidgetRef ref) {
    final globalController = ref.read(
      globalListeningControllerProvider.notifier,
    );
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
                globalController.sendUserPrompt(AppPrompts.identifyObjectLive);
              },
            ),
            _FeatureButton(
              label: "Describe Scene",
              icon: Icons.landscape,
              onPressed: () {
                globalController.sendUserPrompt(AppPrompts.describeScene);
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
                globalController.sendUserPrompt(AppPrompts.readText);
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
