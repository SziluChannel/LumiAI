import 'package:flutter/foundation.dart';
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
    // New features for visually impaired users
    FeatureAction.findObject: FeatureConfig(
      prompt: '', // Dynamic - set at runtime with user input
      requiresCamera: true,
      feedbackMessage: 'Searching for object...',
      requiresUserInput: true,
      inputHint: 'What are you looking for?',
    ),
    FeatureAction.readCurrency: FeatureConfig(
      prompt: AppPrompts.readCurrency,
      requiresCamera: true,
      feedbackMessage: 'Identifying money...',
    ),
    FeatureAction.describeClothing: FeatureConfig(
      prompt: AppPrompts.describeClothing,
      requiresCamera: true,
      feedbackMessage: 'Describing clothing...',
    ),
    FeatureAction.readExpiryDate: FeatureConfig(
      prompt: AppPrompts.readExpiryDate,
      requiresCamera: true,
      feedbackMessage: 'Reading expiry date...',
    ),
    FeatureAction.readMenu: FeatureConfig(
      prompt: AppPrompts.readMenu,
      requiresCamera: true,
      feedbackMessage: 'Reading menu...',
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

    // For features requiring user input, use handleActionWithInput instead
    if (config.requiresUserInput) {
      debugPrint(
        '⚠️ Feature $action requires user input. Use handleActionWithInput().',
      );
      return;
    }

    await _executeAction(action, config.prompt);
  }

  /// Handles a feature action that requires user input (like findObject).
  Future<void> handleActionWithInput(
    FeatureAction action,
    String userInput,
  ) async {
    final config = _configs[action];
    if (config == null) return;

    // Generate dynamic prompt based on action type
    String prompt;
    switch (action) {
      case FeatureAction.findObject:
        prompt = AppPrompts.findSpecificObjectLive(userInput);
        break;
      default:
        prompt = config.prompt;
    }

    await _executeAction(action, prompt);
  }

  /// Core action execution logic shared by handleAction and handleActionWithInput.
  Future<void> _executeAction(FeatureAction action, String prompt) async {
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
    debugPrint("📷 Camera was already open: $wasCameraOpen");

    // Provide feedback
    if (config.feedbackMessage != null) {
      tts?.speak(config.feedbackMessage!);
    }

    // Open camera if required and not already open
    if (config.requiresCamera && !wasCameraOpen) {
      debugPrint("📷 Opening camera...");
      await globalController.openCamera();
      debugPrint("📷 Waiting for camera to be ready...");
      await _waitForCameraReady(config.cameraWaitTimeout);
      debugPrint("📷 Camera ready: ${globalController.isCameraActive}");
    }

    // Always wait for frames to be sent before prompting (frames are sent at 1 FPS)
    // This ensures the model has fresh video frames to analyze
    if (config.requiresCamera) {
      debugPrint("📷 Waiting 10 seconds for frames to be sent...");
      await Future.delayed(const Duration(seconds: 10));
      debugPrint("📷 Done waiting, sending prompt...");
    }

    // Send the prompt to Gemini
    globalController.sendUserPrompt(prompt);

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
