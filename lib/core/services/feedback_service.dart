import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/settings/providers/haptic_feedback_provider.dart';

final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  return FeedbackService(ref);
});

class FeedbackService {
  final Ref _ref;

  FeedbackService(this._ref);

  /// Checks if haptic feedback is enabled (defaults to true if loading)
  bool get _isHapticEnabled {
    final asyncValue = _ref.read(hapticFeedbackControllerProvider);
    return asyncValue.hasValue ? asyncValue.value! : true;
  }

  /// Provides a light impact vibration for successful actions.
  void triggerSuccessFeedback() {
    if (_isHapticEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  /// Provides a heavy impact vibration for error or failed actions.
  void triggerErrorFeedback() {
    if (_isHapticEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  /// Provides a medium impact vibration.
  void triggerMediumFeedback() {
    if (_isHapticEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Provides a selection click feedback.
  void triggerSelectionFeedback() {
    if (_isHapticEnabled) {
      HapticFeedback.selectionClick();
    }
  }
}
