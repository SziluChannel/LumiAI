import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/accessibility/font_size_feature.dart';
import 'package:lumiai/features/settings/providers/theme_provider.dart';

// Fake ThemeController for testing
class FakeThemeController extends ThemeController {
  String? _fontFamily;

  FakeThemeController({String? initialFontFamily}) : _fontFamily = initialFontFamily;

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

void main() {
  testWidgets('renders font selection dropdown', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          themeControllerProvider.overrideWith(() => FakeThemeController()),
        ],
        child: const MaterialApp(home: AccessibilitySettingsScreen()),
      ),
    );

    // Check for "Font Type" label
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
        child: const MaterialApp(home: AccessibilitySettingsScreen()),
      ),
    );

    // Open dropdown
    await tester.tap(find.text('System Default'));
    await tester.pumpAndSettle();

    // Select 'Roboto'
    await tester.tap(find.text('Roboto').last);
    await tester.pumpAndSettle();

    // Verify selection updated (Roboto should be visible as the selected item)
    expect(find.text('Roboto'), findsAtLeastNWidgets(1));
  });
}
