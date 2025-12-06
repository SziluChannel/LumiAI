import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/accessibility/font_size_feature.dart';

void main() {
  // ==========================================================================
  // FontSizeState Tests
  // ==========================================================================
  group('FontSizeState', () {
    test('default constructor has scaleFactor of 1.0', () {
      const state = FontSizeState();
      expect(state.scaleFactor, 1.0);
    });

    test('minScaleFactor is 1.0', () {
      expect(FontSizeState.minScaleFactor, 1.0);
    });

    test('maxScaleFactor is 2.0', () {
      expect(FontSizeState.maxScaleFactor, 2.0);
    });

    test('constructor accepts custom scaleFactor', () {
      const state = FontSizeState(scaleFactor: 1.5);
      expect(state.scaleFactor, 1.5);
    });

    test('copyWith updates scaleFactor', () {
      const state = FontSizeState(scaleFactor: 1.0);
      final updated = state.copyWith(scaleFactor: 1.8);
      expect(updated.scaleFactor, 1.8);
    });

    test('copyWith with no arguments returns equivalent state', () {
      const state = FontSizeState(scaleFactor: 1.5);
      final updated = state.copyWith();
      expect(updated.scaleFactor, state.scaleFactor);
    });
  });

  // ==========================================================================
  // FontSizeNotifier Tests
  // ==========================================================================
  group('FontSizeNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial scaleFactor is 1.0', () {
      final state = container.read(fontSizeProvider);
      expect(state.scaleFactor, 1.0);
    });

    test('setScaleFactor updates value within bounds', () {
      container.read(fontSizeProvider.notifier).setScaleFactor(1.5);
      final state = container.read(fontSizeProvider);
      expect(state.scaleFactor, 1.5);
    });

    test('setScaleFactor accepts minimum value', () {
      container.read(fontSizeProvider.notifier).setScaleFactor(1.0);
      final state = container.read(fontSizeProvider);
      expect(state.scaleFactor, 1.0);
    });

    test('setScaleFactor accepts maximum value', () {
      container.read(fontSizeProvider.notifier).setScaleFactor(2.0);
      final state = container.read(fontSizeProvider);
      expect(state.scaleFactor, 2.0);
    });

    test('setScaleFactor ignores value below minimum', () {
      container.read(fontSizeProvider.notifier).setScaleFactor(1.5);
      container.read(fontSizeProvider.notifier).setScaleFactor(0.5);
      final state = container.read(fontSizeProvider);
      expect(state.scaleFactor, 1.5); // Should remain unchanged
    });

    test('setScaleFactor ignores value above maximum', () {
      container.read(fontSizeProvider.notifier).setScaleFactor(1.5);
      container.read(fontSizeProvider.notifier).setScaleFactor(2.5);
      final state = container.read(fontSizeProvider);
      expect(state.scaleFactor, 1.5); // Should remain unchanged
    });

    test('setScaleFactor ignores negative values', () {
      container.read(fontSizeProvider.notifier).setScaleFactor(-1.0);
      final state = container.read(fontSizeProvider);
      expect(state.scaleFactor, 1.0); // Should remain at initial value
    });

    test('setScaleFactor ignores zero', () {
      container.read(fontSizeProvider.notifier).setScaleFactor(0);
      final state = container.read(fontSizeProvider);
      expect(state.scaleFactor, 1.0); // Should remain at initial value
    });

    test('setScaleFactor accepts values in valid range', () {
      final notifier = container.read(fontSizeProvider.notifier);
      final testValues = [1.0, 1.2, 1.4, 1.6, 1.8, 2.0];

      for (final value in testValues) {
        notifier.setScaleFactor(value);
        final state = container.read(fontSizeProvider);
        expect(state.scaleFactor, value);
      }
    });
  });
}
