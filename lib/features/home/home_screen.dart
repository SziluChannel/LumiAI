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
import 'package:lumiai/features/home/providers/smart_camera_mode_provider.dart';
import 'package:lumiai/features/accessibility/color_identifier/color_identifier_controller.dart';
import 'package:lumiai/features/accessibility/color_identifier/color_identifier_state.dart';
import 'package:lumiai/features/accessibility/light_meter/light_meter_controller.dart';
import 'package:lumiai/features/accessibility/light_meter/light_meter_state.dart';

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
    
    // 3. Listen to Smart Camera Mode
    final smartCameraMode = ref.watch(smartCameraStateProvider);

    // Listen to mode changes to trigger initialization/disposal for Color/Light features
    ref.listen<SmartCameraMode>(smartCameraStateProvider, (previous, next) {
      // PROACTIVELY CLOSE Global Listening Camera if switching to a specific mode
      // This prevents "Camera is busy" errors on mobile devices
      if (next != SmartCameraMode.off) {
         ref.read(globalListeningControllerProvider.notifier).closeCamera();
      } else {
         // Re-initialize Global Listening when returning to standard mode
         ref.read(globalListeningControllerProvider.notifier).initialize();
      }

      if (previous == SmartCameraMode.color && next != SmartCameraMode.color) {
        ref.read(colorIdentifierControllerProvider.notifier).disposeCamera();
      }
      if (previous == SmartCameraMode.light && next != SmartCameraMode.light) {
        ref.read(lightMeterControllerProvider.notifier).disposeCamera();
      }

      if (next == SmartCameraMode.color) {
        ref.read(colorIdentifierControllerProvider.notifier).initialize();
      } else if (next == SmartCameraMode.light) {
        ref.read(lightMeterControllerProvider.notifier).initialize();
      }
    });

    // 4. Determine the Title and Background Color based on mode
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
          // --- MUTE BUTTON ---
          IconButton(
            icon: Icon(
              listeningState.isMuted ? Icons.mic_off : Icons.mic,
              color: listeningState.isMuted ? Colors.red : null,
            ),
            tooltip: listeningState.isMuted
                ? 'Unmute Microphone'
                : 'Mute Microphone',
            onPressed: () {
              ref.read(feedbackServiceProvider).triggerSuccessFeedback();
              ref.read(globalListeningControllerProvider.notifier).toggleMute();
            },
          ),
          // --- UI MODE TOGGLE BUTTON ---
          IconButton(
            icon: Icon(
              isSimplified ? Icons.toggle_on : Icons.toggle_off,
              size: 30,
            ),
            tooltip: 'Switch UI Mode',
            onPressed: () {
              ref
                  .read(feedbackServiceProvider)
                  .triggerSuccessFeedback(); // Haptic feedback
              ref.read(uiModeControllerProvider.notifier).toggleMode();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              ref
                  .read(feedbackServiceProvider)
                  .triggerSuccessFeedback(); // Haptic feedback
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
          
          // Smart Camera Feature Overlay (Color/Light)
          if (smartCameraMode != SmartCameraMode.off)
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
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                       smartCameraMode == SmartCameraMode.color
                          ? const _ColorScannerView()
                          : const _LightMeterView(),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ColorScannerView extends ConsumerWidget {
  const _ColorScannerView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(colorIdentifierControllerProvider);

     if (state.status == ColorIdentifierStatus.loading || !state.isCameraInitialized || state.cameraController == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (state.status == ColorIdentifierStatus.error) {
      return const Center(child: Icon(Icons.error, color: Colors.red));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera Layer - Matches Global Listening AspectRatio behavior EXACTLY (No Center)
        AspectRatio(
          aspectRatio: state.cameraController!.value.aspectRatio,
          child: CameraPreview(state.cameraController!),
        ),
        
        // Color Info Overlay
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.all(4),
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    color: state.currentColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    state.currentColorName,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LightMeterView extends ConsumerWidget {
  const _LightMeterView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lightMeterControllerProvider);

    if (state.status == LightMeterStatus.loading || !state.isCameraInitialized || state.cameraController == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (state.status == LightMeterStatus.error) {
       return const Center(child: Icon(Icons.error, color: Colors.red));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera Layer - Matches Global Listening AspectRatio behavior EXACTLY (No Center)
        AspectRatio(
          aspectRatio: state.cameraController!.value.aspectRatio,
          child: CameraPreview(state.cameraController!),
        ),
        
        // Light Info Overlay
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
             color: Colors.black54,
             padding: const EdgeInsets.all(4),
             width: double.infinity,
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Text(
                   "${(state.brightness * 100).toInt()}%",
                   style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                 ),
                 Text(
                   state.brightnessCategory,
                   style: const TextStyle(color: Colors.white, fontSize: 10),
                   overflow: TextOverflow.ellipsis,
                 ),
               ],
             ),
           ),
        )
      ],
    );
  }
}
