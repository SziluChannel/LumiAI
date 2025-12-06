import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumiai/core/constants/app_themes.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'package:lumiai/core/services/feedback_service.dart';
import 'package:lumiai/features/settings/providers/haptic_feedback_provider.dart';
import 'package:lumiai/features/settings/providers/theme_provider.dart';
import 'package:lumiai/features/settings/providers/tts_settings_provider.dart';
import 'package:lumiai/features/settings/providers/ui_mode_provider.dart';
import 'package:lumiai/features/settings/ui/settings_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_screen_test.mocks.dart';

@GenerateMocks([TtsService, FeedbackService])
// We need to mock the Notifiers or use FakeNotifiers to control state
// Simpler approach for widget test: Override the providers with values.
class FakeUiModeController extends UiModeController {
  FakeUiModeController() : super();
  @override
  Future<UiMode> build() async => UiMode.standard;
}

class FakeThemeController extends ThemeController {
  FakeThemeController() : super();

  @override
  Future<ThemeState> build() async => const ThemeState(
    appThemeMode: AppThemeMode.system,
    customThemeType: CustomThemeType.none,
  );
}

class FakeHapticFeedbackController extends HapticFeedbackController {
  FakeHapticFeedbackController() : super();
  @override
  Future<bool> build() async => true;
}

class FakeTtsSettingsController extends TtsSettingsController {
  FakeTtsSettingsController() : super();
  @override
  TtsSettingsState build() =>
      const TtsSettingsState(pitch: 1.0, speed: 0.5, selectedVoice: 'en-US');
}

void main() {
  late MockTtsService mockTtsService;
  late MockFeedbackService mockFeedbackService;

  setUp(() {
    mockTtsService = MockTtsService();
    mockFeedbackService = MockFeedbackService();
    // Default TTS mock
    when(mockTtsService.availableVoices).thenReturn([
      const VoiceOption(name: 'English (US)', identifier: 'en-US'),
    ]);
  });

  Widget createSubject() {
    return ProviderScope(
      overrides: [
        uiModeControllerProvider.overrideWith(() => FakeUiModeController()),
        themeControllerProvider.overrideWith(() => FakeThemeController()),
        hapticFeedbackControllerProvider.overrideWith(
          () => FakeHapticFeedbackController(),
        ),
        ttsSettingsControllerProvider.overrideWith(
          () => FakeTtsSettingsController(),
        ),
        ttsServiceProvider.overrideWithValue(AsyncValue.data(mockTtsService)),
        feedbackServiceProvider.overrideWithValue(mockFeedbackService),
      ],
      child: const MaterialApp(home: SettingsScreen()),
    );
  }

  testWidgets('renders all settings sections', (WidgetTester tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.text('MEGJELENÉS'), findsOneWidget);
    expect(find.text('HANGBEÁLLÍTÁSOK'), findsOneWidget);
    expect(find.text('HAPTIC FEEDBACK'), findsOneWidget);
    expect(find.text('INFORMÁCIÓ'), findsOneWidget);
  });

  testWidgets('renders UI mode setting', (WidgetTester tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.text('Felület Módja'), findsOneWidget);
    expect(find.text('Standard nézet'), findsOneWidget);
  });

  testWidgets('renders Theme settings', (WidgetTester tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.text('Téma Mód'), findsOneWidget);
    expect(find.text('SYSTEM'), findsOneWidget); // Dropdown value

    expect(find.text('Hozzáférhetőségi Téka'), findsOneWidget);
    expect(find.text('NONE'), findsOneWidget); // Dropdown value
  });

  testWidgets('renders TTS settings', (WidgetTester tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.text('Hang (Voice)'), findsOneWidget);
    expect(find.text('English (US)'), findsOneWidget);

    expect(find.text('Hangmagasság (Pitch)'), findsOneWidget);
    expect(find.byType(Slider), findsNWidgets(2)); // Pitch and Speed sliders
  });

  testWidgets('renders Haptic Feedback setting', (WidgetTester tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.text('Haptic Feedback'), findsOneWidget);
    expect(find.text('Enabled'), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(2)); // UiMode and Haptic switches
  });
}
