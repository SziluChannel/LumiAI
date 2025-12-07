import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lumiai/core/l10n/app_localizations.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'package:lumiai/core/services/feedback_service.dart';
import 'package:lumiai/features/settings/providers/haptic_feedback_provider.dart';
import 'package:lumiai/features/settings/providers/language_provider.dart';
import 'package:lumiai/features/settings/providers/theme_provider.dart';
import 'package:lumiai/features/settings/providers/tts_settings_provider.dart';
import 'package:lumiai/features/settings/providers/ui_mode_provider.dart';
import 'package:lumiai/features/settings/ui/settings_screen.dart';
import 'package:lumiai/features/settings/ui/settings_tile.dart';
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

class FakeLanguageController extends LanguageController {
  final Locale _locale;
  FakeLanguageController({Locale locale = const Locale('en')})
    : _locale = locale;

  @override
  Locale build() => _locale;
}

Widget createLocalizedWidget(
  Widget child, {
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('hu')],
    home: child,
  );
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

  Widget createSubject({Locale locale = const Locale('en')}) {
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
        languageControllerProvider.overrideWith(
          () => FakeLanguageController(locale: locale),
        ),
      ],
      child: createLocalizedWidget(const SettingsScreen(), locale: locale),
    );
  }

  // English locale tests
  group('English locale', () {
    testWidgets('renders all settings sections', (WidgetTester tester) async {
      await tester.pumpWidget(createSubject());
      await tester.pumpAndSettle();

      // Verify the screen rendered by checking for key components
      expect(find.byType(ListView), findsOneWidget);
      // Check for multiple SectionHeader widgets (at least 4 sections)
      expect(find.byType(SettingsTile), findsAtLeastNWidgets(4));
    });

    testWidgets('renders UI mode setting', (WidgetTester tester) async {
      await tester.pumpWidget(createSubject());
      await tester.pumpAndSettle();

      expect(find.text('UI Mode'), findsOneWidget);
      expect(find.text('Standard View'), findsOneWidget);
    });

    testWidgets('renders Theme settings', (WidgetTester tester) async {
      await tester.pumpWidget(createSubject());
      await tester.pumpAndSettle();

      expect(find.text('Theme Mode'), findsOneWidget);
      // SYSTEM appears in the dropdown (both appThemeMode and could appear elsewhere)
      expect(find.text('SYSTEM'), findsAtLeastNWidgets(1));
      expect(find.text('Accessibility Theme'), findsOneWidget);
      expect(find.text('NONE'), findsAtLeastNWidgets(1));
    });

    testWidgets('renders TTS settings', (WidgetTester tester) async {
      await tester.pumpWidget(createSubject());
      await tester.pumpAndSettle();

      // The Voice title and subtitle both show 'English (US)'
      expect(find.text('Voice'), findsAtLeastNWidgets(1));
      expect(find.text('English (US)'), findsAtLeastNWidgets(1));
      expect(find.text('Pitch'), findsOneWidget);
      expect(find.byType(Slider), findsNWidgets(2)); // Pitch and Speed sliders
    });

    testWidgets('renders Haptic Feedback setting', (WidgetTester tester) async {
      await tester.pumpWidget(createSubject());
      await tester.pumpAndSettle();

      // Check for at least 1 switch (data loading may affect count)
      expect(find.byType(Switch), findsAtLeastNWidgets(1));
    });
  });

  // Hungarian locale tests
  group('Hungarian locale', () {
    testWidgets('renders all settings sections', (WidgetTester tester) async {
      await tester.pumpWidget(createSubject(locale: const Locale('hu')));
      await tester.pumpAndSettle();

      // Verify the screen rendered by checking for key components
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(SettingsTile), findsAtLeastNWidgets(4));
    });

    testWidgets('renders UI mode setting', (WidgetTester tester) async {
      await tester.pumpWidget(createSubject(locale: const Locale('hu')));
      await tester.pumpAndSettle();

      expect(find.text('Felület Módja'), findsOneWidget);
      expect(find.text('Standard nézet'), findsOneWidget);
    });

    testWidgets('renders Theme settings', (WidgetTester tester) async {
      await tester.pumpWidget(createSubject(locale: const Locale('hu')));
      await tester.pumpAndSettle();

      expect(find.text('Téma Mód'), findsOneWidget);
      expect(find.text('SYSTEM'), findsAtLeastNWidgets(1));
      expect(find.text('Hozzáférhetőségi Téma'), findsOneWidget);
      expect(find.text('NONE'), findsAtLeastNWidgets(1));
    });

    testWidgets('renders TTS settings', (WidgetTester tester) async {
      await tester.pumpWidget(createSubject(locale: const Locale('hu')));
      await tester.pumpAndSettle();

      expect(find.text('Hang'), findsAtLeastNWidgets(1));
      expect(find.text('English (US)'), findsAtLeastNWidgets(1));
      expect(find.text('Hangmagasság'), findsOneWidget);
      expect(find.byType(Slider), findsNWidgets(2)); // Pitch and Speed sliders
    });

    testWidgets('renders Haptic Feedback setting', (WidgetTester tester) async {
      await tester.pumpWidget(createSubject(locale: const Locale('hu')));
      await tester.pumpAndSettle();

      // Check for at least 1 switch (data loading may affect count)
      expect(find.byType(Switch), findsAtLeastNWidgets(1));
    });
  });
}
