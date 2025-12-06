import 'package:flutter_test/flutter_test.dart';
import 'package:lumiai/features/settings/providers/tts_settings_provider.dart';
import 'package:lumiai/features/settings/providers/theme_provider.dart';
import 'package:lumiai/features/global_listening/global_listening_state.dart';
import 'package:lumiai/features/live_chat/live_chat_state.dart';

void main() {
  // ==========================================================================
  // TtsSettingsState Tests
  // ==========================================================================
  group('TtsSettingsState', () {
    test('default constructor has correct default values', () {
      const state = TtsSettingsState();

      expect(state.pitch, 1.5);
      expect(state.speed, 1.0);
      expect(state.selectedVoice, 'en-US-Wavenet-F');
    });

    test('copyWith updates pitch only', () {
      const state = TtsSettingsState();
      final updated = state.copyWith(pitch: 2.0);

      expect(updated.pitch, 2.0);
      expect(updated.speed, 1.0); // unchanged
      expect(updated.selectedVoice, 'en-US-Wavenet-F'); // unchanged
    });

    test('copyWith updates speed only', () {
      const state = TtsSettingsState();
      final updated = state.copyWith(speed: 1.5);

      expect(updated.pitch, 1.5); // unchanged
      expect(updated.speed, 1.5);
      expect(updated.selectedVoice, 'en-US-Wavenet-F'); // unchanged
    });

    test('copyWith updates selectedVoice only', () {
      const state = TtsSettingsState();
      final updated = state.copyWith(selectedVoice: 'en-US-Wavenet-A');

      expect(updated.pitch, 1.5); // unchanged
      expect(updated.speed, 1.0); // unchanged
      expect(updated.selectedVoice, 'en-US-Wavenet-A');
    });

    test('copyWith updates all fields', () {
      const state = TtsSettingsState();
      final updated = state.copyWith(
        pitch: 0.5,
        speed: 2.0,
        selectedVoice: 'custom-voice',
      );

      expect(updated.pitch, 0.5);
      expect(updated.speed, 2.0);
      expect(updated.selectedVoice, 'custom-voice');
    });

    test('copyWith with no arguments returns equivalent state', () {
      const state = TtsSettingsState(
        pitch: 1.2,
        speed: 0.8,
        selectedVoice: 'test-voice',
      );
      final updated = state.copyWith();

      expect(updated.pitch, state.pitch);
      expect(updated.speed, state.speed);
      expect(updated.selectedVoice, state.selectedVoice);
    });
  });

  // ==========================================================================
  // ThemeState Tests
  // ==========================================================================
  group('ThemeState', () {
    test('default constructor has correct default values', () {
      const state = ThemeState();

      expect(state.appThemeMode, AppThemeMode.system);
      expect(state.customThemeType, CustomThemeType.none);
    });

    test('copyWith updates appThemeMode only', () {
      const state = ThemeState();
      final updated = state.copyWith(appThemeMode: AppThemeMode.dark);

      expect(updated.appThemeMode, AppThemeMode.dark);
      expect(updated.customThemeType, CustomThemeType.none); // unchanged
    });

    test('copyWith updates customThemeType only', () {
      const state = ThemeState();
      final updated = state.copyWith(customThemeType: CustomThemeType.amoled);

      expect(updated.appThemeMode, AppThemeMode.system); // unchanged
      expect(updated.customThemeType, CustomThemeType.amoled);
    });

    test('copyWith updates both fields', () {
      const state = ThemeState();
      final updated = state.copyWith(
        appThemeMode: AppThemeMode.light,
        customThemeType: CustomThemeType.highContrast,
      );

      expect(updated.appThemeMode, AppThemeMode.light);
      expect(updated.customThemeType, CustomThemeType.highContrast);
    });

    test('copyWith with no arguments returns equivalent state', () {
      const state = ThemeState(
        appThemeMode: AppThemeMode.dark,
        customThemeType: CustomThemeType.colorblindFriendly,
      );
      final updated = state.copyWith();

      expect(updated.appThemeMode, state.appThemeMode);
      expect(updated.customThemeType, state.customThemeType);
    });
  });

  // ==========================================================================
  // GlobalListeningState Tests
  // ==========================================================================
  group('GlobalListeningState', () {
    test('default constructor has correct default values', () {
      const state = GlobalListeningState();

      expect(state.status, GlobalListeningStatus.idle);
      expect(state.errorMessage, isNull);
      expect(state.cameraController, isNull);
      expect(state.isCameraInitialized, false);
    });

    test('copyWith updates status only', () {
      const state = GlobalListeningState();
      final updated = state.copyWith(status: GlobalListeningStatus.listening);

      expect(updated.status, GlobalListeningStatus.listening);
      expect(updated.errorMessage, isNull); // unchanged
      expect(updated.isCameraInitialized, false); // unchanged
    });

    test('copyWith updates errorMessage only', () {
      const state = GlobalListeningState();
      final updated = state.copyWith(errorMessage: 'Connection failed');

      expect(updated.status, GlobalListeningStatus.idle); // unchanged
      expect(updated.errorMessage, 'Connection failed');
      expect(updated.isCameraInitialized, false); // unchanged
    });

    test('copyWith updates isCameraInitialized only', () {
      const state = GlobalListeningState();
      final updated = state.copyWith(isCameraInitialized: true);

      expect(updated.status, GlobalListeningStatus.idle); // unchanged
      expect(updated.errorMessage, isNull); // unchanged
      expect(updated.isCameraInitialized, true);
    });

    test('copyWith updates multiple fields', () {
      const state = GlobalListeningState();
      final updated = state.copyWith(
        status: GlobalListeningStatus.cameraActive,
        isCameraInitialized: true,
      );

      expect(updated.status, GlobalListeningStatus.cameraActive);
      expect(updated.isCameraInitialized, true);
    });

    test('copyWith with no arguments returns equivalent state', () {
      const state = GlobalListeningState(
        status: GlobalListeningStatus.error,
        errorMessage: 'Test error',
        isCameraInitialized: true,
      );
      final updated = state.copyWith();

      expect(updated.status, state.status);
      expect(updated.errorMessage, state.errorMessage);
      expect(updated.isCameraInitialized, state.isCameraInitialized);
    });
  });

  // ==========================================================================
  // LiveChatState Tests
  // ==========================================================================
  group('LiveChatState', () {
    test('default constructor has correct default values', () {
      const state = LiveChatState();

      expect(state.status, LiveChatStatus.idle);
      expect(state.messages, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith updates status only', () {
      const state = LiveChatState();
      final updated = state.copyWith(status: LiveChatStatus.streaming);

      expect(updated.status, LiveChatStatus.streaming);
      expect(updated.messages, isNull); // unchanged
      expect(updated.errorMessage, isNull); // unchanged
    });

    test('copyWith updates messages only', () {
      const state = LiveChatState();
      final updated = state.copyWith(messages: 'Hello, world!');

      expect(updated.status, LiveChatStatus.idle); // unchanged
      expect(updated.messages, 'Hello, world!');
      expect(updated.errorMessage, isNull); // unchanged
    });

    test('copyWith updates errorMessage only', () {
      const state = LiveChatState();
      final updated = state.copyWith(errorMessage: 'Network error');

      expect(updated.status, LiveChatStatus.idle); // unchanged
      expect(updated.messages, isNull); // unchanged
      expect(updated.errorMessage, 'Network error');
    });

    test('copyWith updates all fields', () {
      const state = LiveChatState();
      final updated = state.copyWith(
        status: LiveChatStatus.processing,
        messages: 'Processing...',
        errorMessage: null,
      );

      expect(updated.status, LiveChatStatus.processing);
      expect(updated.messages, 'Processing...');
      expect(updated.errorMessage, isNull);
    });

    test('copyWith with no arguments returns equivalent state', () {
      const state = LiveChatState(
        status: LiveChatStatus.error,
        messages: 'Some messages',
        errorMessage: 'An error occurred',
      );
      final updated = state.copyWith();

      expect(updated.status, state.status);
      expect(updated.messages, state.messages);
      expect(updated.errorMessage, state.errorMessage);
    });
  });
}
