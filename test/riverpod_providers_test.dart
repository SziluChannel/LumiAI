import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/settings/providers/ui_mode_provider.dart';
import 'package:lumiai/features/settings/providers/haptic_feedback_provider.dart';
import 'package:lumiai/features/settings/providers/theme_provider.dart';

void main() {
  // ==========================================================================
  // UiMode Enum Tests
  // ==========================================================================
  group('UiMode Enum', () {
    test('has expected values', () {
      expect(UiMode.values.length, 2);
      expect(UiMode.values, contains(UiMode.standard));
      expect(UiMode.values, contains(UiMode.simplified));
    });

    test('standard is first value', () {
      expect(UiMode.standard.index, 0);
    });

    test('simplified is second value', () {
      expect(UiMode.simplified.index, 1);
    });
  });

  // ==========================================================================
  // UiModeController Tests
  // ==========================================================================
  group('UiModeController', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is standard when no saved preference', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Wait for async build to complete
      final uiMode = await container.read(uiModeControllerProvider.future);

      expect(uiMode, UiMode.standard);
    });

    test('initial state loads saved preference', () async {
      SharedPreferences.setMockInitialValues({'ui_mode': 'simplified'});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final uiMode = await container.read(uiModeControllerProvider.future);

      expect(uiMode, UiMode.simplified);
    });

    test('setMode updates state to simplified', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Wait for initial load
      await container.read(uiModeControllerProvider.future);

      // Set mode
      container.read(uiModeControllerProvider.notifier).setMode(UiMode.simplified);

      // Give async operation time to complete
      await Future.delayed(const Duration(milliseconds: 50));

      final uiMode = container.read(uiModeControllerProvider).value;
      expect(uiMode, UiMode.simplified);
    });

    test('setMode updates state to standard', () async {
      SharedPreferences.setMockInitialValues({'ui_mode': 'simplified'});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(uiModeControllerProvider.future);

      container.read(uiModeControllerProvider.notifier).setMode(UiMode.standard);

      await Future.delayed(const Duration(milliseconds: 50));

      final uiMode = container.read(uiModeControllerProvider).value;
      expect(uiMode, UiMode.standard);
    });

    test('toggleMode switches from standard to simplified', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(uiModeControllerProvider.future);

      container.read(uiModeControllerProvider.notifier).toggleMode();

      await Future.delayed(const Duration(milliseconds: 50));

      final uiMode = container.read(uiModeControllerProvider).value;
      expect(uiMode, UiMode.simplified);
    });

    test('toggleMode switches from simplified to standard', () async {
      SharedPreferences.setMockInitialValues({'ui_mode': 'simplified'});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(uiModeControllerProvider.future);

      container.read(uiModeControllerProvider.notifier).toggleMode();

      await Future.delayed(const Duration(milliseconds: 50));

      final uiMode = container.read(uiModeControllerProvider).value;
      expect(uiMode, UiMode.standard);
    });
  });

  // ==========================================================================
  // HapticFeedbackController Tests
  // ==========================================================================
  group('HapticFeedbackController', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is true when no saved preference', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final isEnabled = await container.read(hapticFeedbackControllerProvider.future);

      expect(isEnabled, true);
    });

    test('initial state loads saved preference (false)', () async {
      SharedPreferences.setMockInitialValues({'haptic_feedback_enabled': false});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final isEnabled = await container.read(hapticFeedbackControllerProvider.future);

      expect(isEnabled, false);
    });

    test('initial state loads saved preference (true)', () async {
      SharedPreferences.setMockInitialValues({'haptic_feedback_enabled': true});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final isEnabled = await container.read(hapticFeedbackControllerProvider.future);

      expect(isEnabled, true);
    });

    test('setHapticFeedback updates state to false', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(hapticFeedbackControllerProvider.future);

      container.read(hapticFeedbackControllerProvider.notifier).setHapticFeedback(false);

      await Future.delayed(const Duration(milliseconds: 50));

      final isEnabled = container.read(hapticFeedbackControllerProvider).value;
      expect(isEnabled, false);
    });

    test('setHapticFeedback updates state to true', () async {
      SharedPreferences.setMockInitialValues({'haptic_feedback_enabled': false});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(hapticFeedbackControllerProvider.future);

      container.read(hapticFeedbackControllerProvider.notifier).setHapticFeedback(true);

      await Future.delayed(const Duration(milliseconds: 50));

      final isEnabled = container.read(hapticFeedbackControllerProvider).value;
      expect(isEnabled, true);
    });
  });

  // ==========================================================================
  // AppThemeMode Enum Tests
  // ==========================================================================
  group('AppThemeMode Enum', () {
    test('has expected values', () {
      expect(AppThemeMode.values.length, 3);
      expect(AppThemeMode.values, contains(AppThemeMode.light));
      expect(AppThemeMode.values, contains(AppThemeMode.dark));
      expect(AppThemeMode.values, contains(AppThemeMode.system));
    });
  });

  // ==========================================================================
  // CustomThemeType Enum Tests
  // ==========================================================================
  group('CustomThemeType Enum', () {
    test('has expected values', () {
      expect(CustomThemeType.values.length, 4);
      expect(CustomThemeType.values, contains(CustomThemeType.none));
      expect(CustomThemeType.values, contains(CustomThemeType.highContrast));
      expect(CustomThemeType.values, contains(CustomThemeType.colorblindFriendly));
      expect(CustomThemeType.values, contains(CustomThemeType.amoled));
    });
  });

  // ==========================================================================
  // ThemeController Tests
  // ==========================================================================
  group('ThemeController', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state has system mode and no custom theme', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final themeState = await container.read(themeControllerProvider.future);

      expect(themeState.appThemeMode, AppThemeMode.system);
      expect(themeState.customThemeType, CustomThemeType.none);
    });

    test('loads saved app theme mode', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'dark'});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final themeState = await container.read(themeControllerProvider.future);

      expect(themeState.appThemeMode, AppThemeMode.dark);
    });

    test('loads saved custom theme type', () async {
      SharedPreferences.setMockInitialValues({'custom_theme_type': 'amoled'});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final themeState = await container.read(themeControllerProvider.future);

      expect(themeState.customThemeType, CustomThemeType.amoled);
    });

    test('loads both saved preferences', () async {
      SharedPreferences.setMockInitialValues({
        'app_theme_mode': 'light',
        'custom_theme_type': 'highContrast',
      });
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final themeState = await container.read(themeControllerProvider.future);

      expect(themeState.appThemeMode, AppThemeMode.light);
      expect(themeState.customThemeType, CustomThemeType.highContrast);
    });

    test('setAppThemeMode updates state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(themeControllerProvider.future);

      container.read(themeControllerProvider.notifier).setAppThemeMode(AppThemeMode.dark);

      await Future.delayed(const Duration(milliseconds: 50));

      final themeState = container.read(themeControllerProvider).value;
      expect(themeState?.appThemeMode, AppThemeMode.dark);
    });

    test('setCustomThemeType updates state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(themeControllerProvider.future);

      container.read(themeControllerProvider.notifier).setCustomThemeType(CustomThemeType.colorblindFriendly);

      await Future.delayed(const Duration(milliseconds: 50));

      final themeState = container.read(themeControllerProvider).value;
      expect(themeState?.customThemeType, CustomThemeType.colorblindFriendly);
    });

    test('handles invalid saved app theme mode gracefully', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'invalid_mode'});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final themeState = await container.read(themeControllerProvider.future);

      expect(themeState.appThemeMode, AppThemeMode.system); // Falls back to default
    });

    test('handles invalid saved custom theme type gracefully', () async {
      SharedPreferences.setMockInitialValues({'custom_theme_type': 'invalid_type'});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final themeState = await container.read(themeControllerProvider.future);

      expect(themeState.customThemeType, CustomThemeType.none); // Falls back to default
    });
  });
}
