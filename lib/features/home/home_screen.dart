import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/global_listening/global_listening_controller.dart';
import 'package:lumiai/features/global_listening/global_listening_state.dart';
import 'package:lumiai/features/settings/providers/ui_mode_provider.dart';
import 'package:lumiai/features/accessibility/font_size_feature.dart'; // Import ScaledTextWidget
import 'package:lumiai/core/services/feedback_service.dart'; // Import FeedbackService

// Imports for your specific features and settings
import 'layouts/minimal_ui.dart';
import 'layouts/partial_ui.dart';
import 'package:lumiai/features/settings/ui/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize Global Listening on Startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(globalListeningControllerProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Listen to the global UI Mode state
    final uiMode = ref.watch(uiModeControllerProvider);

    // 2. Listen to Global Listening State
    final listeningState = ref.watch(globalListeningControllerProvider);

    // 3. Determine the Title and Background Color based on mode
    final isSimplified = uiMode.value == UiMode.simplified;
    final String title = isSimplified ? "LumiAI (Simple)" : "LumiAI";
    final Color? appBarColor = isSimplified
        ? Colors.blueGrey[900]
        : null; // High contrast for simple

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Use ScaledTextWidget for the title
            ScaledTextWidget(
              text: title,
              baseFontSize: 20, // Base font size for the app bar title
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(width: 10),
            // Status Indicator
            if (listeningState.status == GlobalListeningStatus.listening)
              const Icon(Icons.mic, color: Colors.green, size: 20)
            else if (listeningState.status ==
                GlobalListeningStatus.cameraActive)
              const Icon(Icons.videocam, color: Colors.red, size: 20)
            else if (listeningState.status == GlobalListeningStatus.connecting)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        backgroundColor: appBarColor,
        foregroundColor: isSimplified ? Colors.white : null,
        actions: [
          // --- TEMPORARY TOGGLE BUTTON ---
          IconButton(
            icon: Icon(
              isSimplified ? Icons.toggle_on : Icons.toggle_off,
              size: 30,
            ),
            tooltip: 'Switch UI Mode',
            onPressed: () {
              FeedbackService.triggerSuccessFeedback(); // Haptic feedback
              ref.read(uiModeControllerProvider.notifier).toggleMode();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              FeedbackService.triggerSuccessFeedback(); // Haptic feedback
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      // 4. Stack for Camera Overlay
      body: Stack(
        children: [
          // Main Content
          switch (uiMode) {
            AsyncData<UiMode>(:final value) => switch (value) {
              UiMode.simplified => const MinimalFunctionalUI(),
              UiMode.standard => const PartialFunctionalUI(),
            },
            AsyncLoading<UiMode>() => const Center(
              child: CircularProgressIndicator(),
            ),
            AsyncError<UiMode>(:final error) => Center(
              child: Text('Error: $error'),
            ),
          },

          // Camera Overlay (When Active)
          if (listeningState.status == GlobalListeningStatus.cameraActive) ...[
            if (listeningState.cameraController != null &&
                listeningState.isCameraInitialized)
              Positioned(
                bottom: 20,
                right: 20,
                width: 150,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      color: Colors.black,
                    ),
                    child: AspectRatio(
                      aspectRatio:
                          listeningState.cameraController!.value.aspectRatio,
                      child: CameraPreview(listeningState.cameraController!),
                    ),
                  ),
                ),
              )
            else
              const Positioned(
                bottom: 20,
                right: 20,
                child: Text(
                  "Camera Active but not initialized",
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
