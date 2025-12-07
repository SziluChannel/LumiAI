import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lumiai/core/l10n/app_localizations.dart';
import 'package:lumiai/features/accessibility/font_size_feature.dart';
import 'package:lumiai/features/settings/providers/theme_provider.dart';

// Fake ThemeController for testing
class FakeThemeController extends ThemeController {
  String? _fontFamily;

  FakeThemeController({String? initialFontFamily})
    : _fontFamily = initialFontFamily;

  @override
  Future<ThemeState> build() async {
    return ThemeState(fontFamily: _fontFamily);
  }

  @override
  void setFontFamily(String? fontFamily) async {
    _fontFamily = fontFamily;
    state = AsyncValue.data(ThemeState(fontFamily: fontFamily));
  }
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
  testWidgets('renders font selection dropdown', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          themeControllerProvider.overrideWith(() => FakeThemeController()),
        ],
        child: createLocalizedWidget(const AccessibilitySettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Check for "Font Type" label (English locale)
    expect(find.text('Font Type'), findsOneWidget);

    // Check for DropdownButton
    expect(find.byType(DropdownButton<String?>), findsOneWidget);

    // Check for "System Default" (default null value)
    expect(find.text('System Default'), findsOneWidget);
  });

  testWidgets('changing font updates selection', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          themeControllerProvider.overrideWith(() => FakeThemeController()),
        ],
        child: createLocalizedWidget(const AccessibilitySettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Open dropdown
    await tester.tap(find.text('System Default'));
    await tester.pumpAndSettle();

    // Select 'Roboto'
    await tester.tap(find.text('Roboto').last);
    await tester.pumpAndSettle();

    // Verify selection updated (Roboto should be visible as the selected item)
    expect(find.text('Roboto'), findsAtLeastNWidgets(1));
  });

  // Test with Hungarian locale
  testWidgets('renders font selection dropdown - Hungarian locale', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          themeControllerProvider.overrideWith(() => FakeThemeController()),
        ],
        child: createLocalizedWidget(
          const AccessibilitySettingsScreen(),
          locale: const Locale('hu'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Check that the screen renders with DropdownButton
    expect(find.byType(DropdownButton<String?>), findsOneWidget);

    // Verify the widget tree contains the expected elements
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
