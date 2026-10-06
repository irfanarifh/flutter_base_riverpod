import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_template/features/auth/view/login_screen.dart';
import 'package:flutter_template/shared/widgets/buttons/primary_button.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    when(() => mockAuthRepository.restoreSession())
        .thenAnswer((_) async => null);
  });

  group('LoginScreen', () {
    testWidgets('shows validation errors when submitted empty', (tester) async {
      await tester.pumpApp(
        child: const LoginScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Tap submit button without entering credentials
      final loginButton = find.byType(PrimaryButton);
      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Form validation errors should be displayed
      expect(find.text('Email address is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);

      verifyNever(() => mockAuthRepository.login(any(), any()));
    });

    testWidgets('calls login on repository when valid input is submitted', (tester) async {
      when(() => mockAuthRepository.login('test@example.com', 'password123'))
          .thenAnswer((_) async => TestFixtures.testUser);

      await tester.pumpApp(
        child: const LoginScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Enter valid email and password
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      await tester.enterText(textFields.at(0), 'test@example.com');
      await tester.enterText(textFields.at(1), 'password123');
      await tester.pumpAndSettle();

      // Submit form
      final loginButton = find.byType(PrimaryButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      verify(() => mockAuthRepository.login('test@example.com', 'password123'))
          .called(1);
    });
  });
}
