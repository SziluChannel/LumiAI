import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumiai/features/settings/ui/privacy_policy_screen.dart';

void main() {
  testWidgets('renders privacy policy screen content', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrivacyPolicyScreen()));

    expect(find.text('Adatvédelmi Nyilatkozat'), findsOneWidget); // AppBar
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    // Determine if content is scrollable/present without checking exact string for now
    expect(find.byType(Text), findsWidgets); 
  });
}
