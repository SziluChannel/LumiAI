import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lumiai/core/l10n/app_localizations.dart';
import 'package:lumiai/features/settings/providers/privacy_policy_provider.dart';
import 'package:lumiai/features/settings/ui/privacy_policy_screen.dart';

class FakePrivacyPolicyController extends PrivacyPolicyController {
  bool _isAccepted = false;

  FakePrivacyPolicyController({bool initialValue = false})
    : _isAccepted = initialValue;

  @override
  Future<bool> build() async => _isAccepted;

  @override
  Future<void> acceptPolicy() async {
    _isAccepted = true;
    state = const AsyncValue.data(true);
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
  // English locale tests
  group('English locale', () {
    testWidgets('renders privacy policy screen content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            privacyPolicyControllerProvider.overrideWith(
              () => FakePrivacyPolicyController(),
            ),
          ],
          child: createLocalizedWidget(const PrivacyPolicyScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Privacy Policy'), findsOneWidget); // AppBar
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('I Accept'), findsOneWidget); // Default button
    });

    testWidgets('shows accepted state when already accepted', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            privacyPolicyControllerProvider.overrideWith(
              () => FakePrivacyPolicyController(initialValue: true),
            ),
          ],
          child: createLocalizedWidget(const PrivacyPolicyScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Accepted'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('changes to accepted after tapping accept', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            privacyPolicyControllerProvider.overrideWith(
              () => FakePrivacyPolicyController(),
            ),
          ],
          child: createLocalizedWidget(const PrivacyPolicyScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('I Accept'), findsOneWidget);

      // Tap button
      await tester.tap(find.text('I Accept'));
      await tester.pumpAndSettle();

      // Verify accepted state
      expect(find.text('Accepted'), findsOneWidget);
    });
  });

  // Hungarian locale tests
  group('Hungarian locale', () {
    testWidgets('renders privacy policy screen content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            privacyPolicyControllerProvider.overrideWith(
              () => FakePrivacyPolicyController(),
            ),
          ],
          child: createLocalizedWidget(
            const PrivacyPolicyScreen(),
            locale: const Locale('hu'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Adatvédelmi Nyilatkozat'), findsOneWidget); // AppBar
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('Elfogadom'), findsOneWidget); // Default button
    });

    testWidgets('shows accepted state when already accepted', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            privacyPolicyControllerProvider.overrideWith(
              () => FakePrivacyPolicyController(initialValue: true),
            ),
          ],
          child: createLocalizedWidget(
            const PrivacyPolicyScreen(),
            locale: const Locale('hu'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Elfogadva'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('changes to accepted after tapping accept', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            privacyPolicyControllerProvider.overrideWith(
              () => FakePrivacyPolicyController(),
            ),
          ],
          child: createLocalizedWidget(
            const PrivacyPolicyScreen(),
            locale: const Locale('hu'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('Elfogadom'), findsOneWidget);

      // Tap button
      await tester.tap(find.text('Elfogadom'));
      await tester.pumpAndSettle();

      // Verify accepted state
      expect(find.text('Elfogadva'), findsOneWidget);
    });
  });
}
