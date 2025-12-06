/// Enum defining all available feature actions that can be triggered by UI buttons.
enum FeatureAction {
  /// Identify objects in the camera view
  identifyObject,

  /// Read any visible text
  readText,

  /// Describe the overall scene
  describeScene,

  /// Find a specific object the user is looking for
  findObject,

  /// Recognize currency (bills and coins) and state the amount
  readCurrency,

  /// Describe clothing (color, pattern, type)
  describeClothing,

  /// Read expiry date from food products
  readExpiryDate,

  /// Read and navigate restaurant menus
  readMenu,
}

/// Configuration for each feature action.
/// Contains all the information needed to execute a feature.
class FeatureConfig {
  /// The prompt to send to Gemini
  final String prompt;

  /// Whether this feature requires the camera to be active
  final bool requiresCamera;

  /// Optional TTS feedback message when action starts
  final String? feedbackMessage;

  /// Maximum time to wait for camera to become ready
  final Duration cameraWaitTimeout;

  /// Whether this feature requires user input (like object name to find)
  final bool requiresUserInput;

  /// Input prompt hint for UI (if requiresUserInput is true)
  final String? inputHint;

  const FeatureConfig({
    required this.prompt,
    required this.requiresCamera,
    this.feedbackMessage,
    this.cameraWaitTimeout = const Duration(seconds: 10),
    this.requiresUserInput = false,
    this.inputHint,
  });
}
