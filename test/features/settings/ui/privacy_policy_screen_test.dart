import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/settings/providers/privacy_policy_provider.dart';
import 'package:lumiai/features/settings/ui/privacy_policy_screen.dart';

class FakePrivacyPolicyController extends PrivacyPolicyController {
  bool _isAccepted = false;
  
  FakePrivacyPolicyController({bool initialValue = false}) : _isAccepted = initialValue;

  @override
  Future<bool> build() async => _isAccepted;

  @override
  Future<void> acceptPolicy() async {
    _isAccepted = true;
    state = const AsyncValue.data(true);
  }
}

void main() {
  testWidgets('renders privacy policy screen content', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          privacyPolicyControllerProvider.overrideWith(() => FakePrivacyPolicyController()),
        ],
        child: const MaterialApp(home: PrivacyPolicyScreen()),
      ),
    );

    expect(find.text('Adatvédelmi Nyilatkozat'), findsOneWidget); // AppBar
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text('Elfogadom'), findsOneWidget); // Default button
  });

  testWidgets('shows accepted state when already accepted', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          privacyPolicyControllerProvider.overrideWith(() => FakePrivacyPolicyController(initialValue: true)),
        ],
        child: const MaterialApp(home: PrivacyPolicyScreen()),
      ),
    );
     await tester.pumpAndSettle();

    expect(find.text('Elfogadva'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('changes to accepted after tapping accept', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          privacyPolicyControllerProvider.overrideWith(() => FakePrivacyPolicyController()),
        ],
        child: const MaterialApp(home: PrivacyPolicyScreen()),
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
}
