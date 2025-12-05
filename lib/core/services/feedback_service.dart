import 'package:flutter/services.dart';

class FeedbackService {
  /// Provides a light impact vibration for successful actions.
  static void triggerSuccessFeedback() {
    HapticFeedback.lightImpact();
  }

  /// Provides a heavy impact vibration for error or failed actions.
  static void triggerErrorFeedback() {
    HapticFeedback.heavyImpact();
  }
}
