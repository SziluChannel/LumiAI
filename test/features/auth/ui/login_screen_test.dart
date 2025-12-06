import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumiai/core/services/biometric_auth_service.dart';
import 'package:lumiai/core/services/feedback_service.dart';
import 'package:lumiai/features/auth/ui/login_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_screen_test.mocks.dart';

@GenerateMocks([BiometricAuthService, FeedbackService])
void main() {
  late MockBiometricAuthService mockBiometricAuthService;
  late MockFeedbackService mockFeedbackService;

  setUp(() {
    mockBiometricAuthService = MockBiometricAuthService();
    mockFeedbackService = MockFeedbackService();

    // Default mock behavior
    when(mockBiometricAuthService.canCheckBiometrics())
        .thenAnswer((_) async => false);
    when(mockFeedbackService.triggerSuccessFeedback())
        .thenAnswer((_) async => {});
    when(mockFeedbackService.triggerErrorFeedback())
        .thenAnswer((_) async => {});
  });

  Widget createSubject() {
    return ProviderScope(
      overrides: [
        biometricAuthServiceProvider.overrideWithValue(mockBiometricAuthService),
        feedbackServiceProvider.overrideWithValue(mockFeedbackService),
      ],
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  testWidgets('renders login screen elements', (WidgetTester tester) async {
    await tester.pumpWidget(createSubject());

    expect(find.text('Login'), findsOneWidget); // AppBar title
    expect(find.byType(TextField), findsNWidgets(2)); // Username and Password
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget); // Login button
  });

  testWidgets('shows error message on invalid credentials',
      (WidgetTester tester) async {
    await tester.pumpWidget(createSubject());

    // Enter invalid credentials
    await tester.enterText(find.bySemanticsLabel('Username'), 'wrong');
    await tester.enterText(find.bySemanticsLabel('Password'), 'wrong');
    await tester.pump();

    // Tap login
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    // Verify error message
    expect(find.text('Incorrect username or password.'), findsOneWidget);
    
    // Verify error feedback triggered
    verify(mockFeedbackService.triggerErrorFeedback()).called(1);
  });

  testWidgets('shows biometric login button when available', (WidgetTester tester) async {
    // Setup mock to return true for biometrics
    when(mockBiometricAuthService.canCheckBiometrics())
        .thenAnswer((_) async => true);

    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle(); // Wait for future builder/init state

    expect(find.text('Login with Fingerprint/Face ID'), findsOneWidget);
  });

   testWidgets('password visibility toggle works', (WidgetTester tester) async {
    await tester.pumpWidget(createSubject());

    final passwordFieldFinder = find.bySemanticsLabel('Password');
    final toggleButtonFinder = find.byIcon(Icons.visibility_off);

    // Initial state: obscured
    expect(
      tester.widget<TextField>(find.descendant(of: passwordFieldFinder, matching: find.byType(TextField))).obscureText,
      isTrue
    );

    // Tap toggle
    await tester.tap(toggleButtonFinder);
    await tester.pump();

    // New state: visible
     expect(
      tester.widget<TextField>(find.descendant(of: passwordFieldFinder, matching: find.byType(TextField))).obscureText,
      isFalse
    );
    
    // Verify success feedback triggered on toggle
    verify(mockFeedbackService.triggerSuccessFeedback()).called(1);
  });
} 
