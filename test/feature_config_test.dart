import 'package:flutter_test/flutter_test.dart';
import 'package:lumiai/core/features/feature_action.dart';

void main() {
  // ==========================================================================
  // FeatureAction Enum Tests
  // ==========================================================================
  group('FeatureAction Enum', () {
    test('has all expected values', () {
      expect(FeatureAction.values.length, 8);
      expect(FeatureAction.values, contains(FeatureAction.identifyObject));
      expect(FeatureAction.values, contains(FeatureAction.readText));
      expect(FeatureAction.values, contains(FeatureAction.describeScene));
      expect(FeatureAction.values, contains(FeatureAction.findObject));
      expect(FeatureAction.values, contains(FeatureAction.readCurrency));
      expect(FeatureAction.values, contains(FeatureAction.describeClothing));
      expect(FeatureAction.values, contains(FeatureAction.readExpiryDate));
      expect(FeatureAction.values, contains(FeatureAction.readMenu));
    });

    test('each value has correct name', () {
      expect(FeatureAction.identifyObject.name, 'identifyObject');
      expect(FeatureAction.readText.name, 'readText');
      expect(FeatureAction.describeScene.name, 'describeScene');
      expect(FeatureAction.findObject.name, 'findObject');
      expect(FeatureAction.readCurrency.name, 'readCurrency');
      expect(FeatureAction.describeClothing.name, 'describeClothing');
      expect(FeatureAction.readExpiryDate.name, 'readExpiryDate');
      expect(FeatureAction.readMenu.name, 'readMenu');
    });
  });

  // ==========================================================================
  // FeatureConfig Tests
  // ==========================================================================
  group('FeatureConfig', () {
    test('constructor with required fields only', () {
      const config = FeatureConfig(prompt: 'Test prompt', requiresCamera: true);

      expect(config.prompt, 'Test prompt');
      expect(config.requiresCamera, true);
      expect(config.feedbackMessage, isNull);
      expect(config.cameraWaitTimeout, const Duration(seconds: 10));
    });

    test('constructor with all fields', () {
      const config = FeatureConfig(
        prompt: 'Full prompt',
        requiresCamera: false,
        feedbackMessage: 'Starting...',
        cameraWaitTimeout: Duration(seconds: 5),
      );

      expect(config.prompt, 'Full prompt');
      expect(config.requiresCamera, false);
      expect(config.feedbackMessage, 'Starting...');
      expect(config.cameraWaitTimeout, const Duration(seconds: 5));
    });

    test('default cameraWaitTimeout is 10 seconds', () {
      const config = FeatureConfig(prompt: 'Test', requiresCamera: true);

      expect(config.cameraWaitTimeout.inSeconds, 10);
    });

    test('custom cameraWaitTimeout is respected', () {
      const config = FeatureConfig(
        prompt: 'Test',
        requiresCamera: true,
        cameraWaitTimeout: Duration(seconds: 30),
      );

      expect(config.cameraWaitTimeout.inSeconds, 30);
    });

    test('feedbackMessage can be null', () {
      const config = FeatureConfig(prompt: 'Test', requiresCamera: false);

      expect(config.feedbackMessage, isNull);
    });

    test('feedbackMessage can be set', () {
      const config = FeatureConfig(
        prompt: 'Test',
        requiresCamera: true,
        feedbackMessage: 'Processing your request...',
      );

      expect(config.feedbackMessage, 'Processing your request...');
    });

    test('requiresCamera false configuration', () {
      const config = FeatureConfig(
        prompt: 'Voice only prompt',
        requiresCamera: false,
      );

      expect(config.requiresCamera, false);
    });

    test('requiresCamera true configuration', () {
      const config = FeatureConfig(
        prompt: 'Camera prompt',
        requiresCamera: true,
      );

      expect(config.requiresCamera, true);
    });
  });
}
