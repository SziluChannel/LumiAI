import 'package:lumiai/core/constants/app_prompts.dart';
import 'package:lumiai/core/features/feature_action.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'package:lumiai/features/global_listening/global_listening_controller.dart';
import 'package:lumiai/features/global_listening/global_listening_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feature_controller.g.dart';

/// Central controller for handling feature actions triggered by UI buttons.
/// Manages camera lifecycle and prompt sending for each feature.
@Riverpod(keepAlive: true)
class FeatureController extends _$FeatureController {
  /// Map of actions to their configurations
  static final Map<FeatureAction, FeatureConfig> _configs = {
    FeatureAction.identifyObject: FeatureConfig(
      prompt: AppPrompts.identifyObjectLive,
      requiresCamera: true,
      feedbackMessage: 'Identifying objects...',
    ),
    FeatureAction.readText: FeatureConfig(
      prompt: AppPrompts.readText,
      requiresCamera: true,
      feedbackMessage: 'Reading text...',
    ),
    FeatureAction.describeScene: FeatureConfig(
      prompt: AppPrompts.describeScene,
      requiresCamera: true,
      feedbackMessage: 'Describing scene...',
    ),
  };

  @override
  void build() {
    // Stateless controller - no state to initialize
  }

  /// Handles a feature action request.
  /// Opens camera if needed, sends prompt, and manages the action lifecycle.
  Future<void> handleAction(FeatureAction action) async {
    final config = _configs[action];
    if (config == null) return;

    final globalController = ref.read(
      globalListeningControllerProvider.notifier,
    );
    final ttsAsyncValue = ref.read(ttsServiceProvider);
    final tts = ttsAsyncValue.value;

    // Check if connected
    if (!globalController.isInitialized) {
      tts?.speak('Please wait, connecting...');
      return;
    }

    // Track if camera was already open
    final wasCameraOpen = globalController.isCameraActive;
    print("📷 Camera was already open: $wasCameraOpen");

    // Provide feedback
    if (config.feedbackMessage != null) {
      tts?.speak(config.feedbackMessage!);
    }

    // Open camera if required and not already open
    if (config.requiresCamera && !wasCameraOpen) {
      print("📷 Opening camera...");
      await globalController.openCamera();
      print("📷 Waiting for camera to be ready...");
      await _waitForCameraReady(config.cameraWaitTimeout);
      print("📷 Camera ready: ${globalController.isCameraActive}");
    }

    // Always wait for frames to be sent before prompting (frames are sent at 1 FPS)
    // This ensures the model has fresh video frames to analyze
    if (config.requiresCamera) {
      print("📷 Waiting 10 seconds for frames to be sent...");
      await Future.delayed(const Duration(seconds: 10));
      print("📷 Done waiting, sending prompt...");
    }

    // Send the prompt to Gemini
    globalController.sendUserPrompt(config.prompt);

    // Note: Camera closing is handled by the AI model via tool calls
    // because the model knows when it's done with the analysis
  }

  /// Waits for the camera to become ready with a timeout.
  Future<void> _waitForCameraReady(Duration timeout) async {
    final deadline = DateTime.now().add(timeout);

    while (true) {
      // Re-read state each iteration to detect changes
      final currentState = ref.read(globalListeningControllerProvider);
      if (currentState.status == GlobalListeningStatus.cameraActive) break;
      if (DateTime.now().isAfter(deadline)) break;
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Gets the configuration for a specific action.
  /// Useful for UI to know what features require what.
  static FeatureConfig? getConfig(FeatureAction action) => _configs[action];
}
