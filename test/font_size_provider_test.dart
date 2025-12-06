import 'package:flutter_test/flutter_test.dart';
import 'package:lumiai/features/accessibility/font_size_feature.dart';

void main() {
  // ==========================================================================
  // FontSizeProvider Tests
  // ==========================================================================
  group('FontSizeProvider', () {
    late FontSizeProvider provider;

    setUp(() {
      provider = FontSizeProvider();
    });

    test('initial scaleFactor is 1.0', () {
      expect(provider.scaleFactor, 1.0);
    });

    test('minScaleFactor is 1.0', () {
      expect(FontSizeProvider.minScaleFactor, 1.0);
    });

    test('maxScaleFactor is 2.0', () {
      expect(FontSizeProvider.maxScaleFactor, 2.0);
    });

    test('setScaleFactor updates value within bounds', () {
      provider.setScaleFactor(1.5);
      expect(provider.scaleFactor, 1.5);
    });

    test('setScaleFactor accepts minimum value', () {
      provider.setScaleFactor(1.0);
      expect(provider.scaleFactor, 1.0);
    });

    test('setScaleFactor accepts maximum value', () {
      provider.setScaleFactor(2.0);
      expect(provider.scaleFactor, 2.0);
    });

    test('setScaleFactor ignores value below minimum', () {
      provider.setScaleFactor(1.5); // Set a valid value first
      provider.setScaleFactor(0.5); // Try to set below minimum

      expect(provider.scaleFactor, 1.5); // Should remain unchanged
    });

    test('setScaleFactor ignores value above maximum', () {
      provider.setScaleFactor(1.5); // Set a valid value first
      provider.setScaleFactor(2.5); // Try to set above maximum

      expect(provider.scaleFactor, 1.5); // Should remain unchanged
    });

    test('setScaleFactor ignores negative values', () {
      provider.setScaleFactor(-1.0);

      expect(provider.scaleFactor, 1.0); // Should remain at initial value
    });

    test('setScaleFactor ignores zero', () {
      provider.setScaleFactor(0);

      expect(provider.scaleFactor, 1.0); // Should remain at initial value
    });

    test('setScaleFactor accepts values in valid range', () {
      final testValues = [1.0, 1.2, 1.4, 1.6, 1.8, 2.0];

      for (final value in testValues) {
        provider.setScaleFactor(value);
        expect(provider.scaleFactor, value);
      }
    });

    test('notifies listeners when scaleFactor changes', () {
      var notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      provider.setScaleFactor(1.5);

      expect(notificationCount, 1);
    });

    test('does not notify listeners when value is out of bounds', () {
      var notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      provider.setScaleFactor(0.5); // Out of bounds

      expect(notificationCount, 0);
    });

    test('notifies listeners for each valid change', () {
      var notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      provider.setScaleFactor(1.2);
      provider.setScaleFactor(1.6);
      provider.setScaleFactor(2.0);

      expect(notificationCount, 3);
    });
  });
}
