import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/settings/providers/haptic_feedback_provider.dart';

final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  return FeedbackService(ref);
});

class FeedbackService {
  final Ref _ref;

  FeedbackService(this._ref);

  /// Provides a light impact vibration for successful actions.
  Future<void> triggerSuccessFeedback() async {
    final isEnabled = await _ref.read(hapticFeedbackControllerProvider.future);
    if (isEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  /// Provides a heavy impact vibration for error or failed actions.
  Future<void> triggerErrorFeedback() async {
    final isEnabled = await _ref.read(hapticFeedbackControllerProvider.future);
    if (isEnabled) {
      HapticFeedback.heavyImpact();
    }
  }
}
