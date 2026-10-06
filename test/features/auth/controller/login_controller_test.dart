import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/core/errors/app_exception.dart';
import 'package:flutter_template/features/auth/controller/login_controller.dart';
import 'package:flutter_template/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_template/features/auth/model/user.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    // Default restoreSession behavior for AuthController initialization
    when(() => mockAuthRepository.restoreSession())
        .thenAnswer((_) async => null);

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('LoginController', () {
    test('initial state is AsyncData(null)', () {
      final state = container.read(loginControllerProvider);
      expect(state, const AsyncData<void>(null));
    });

    test('submit succeeds and returns true on valid credentials', () async {
      when(() => mockAuthRepository.login('test@example.com', 'password123'))
          .thenAnswer((_) async => TestFixtures.testUser);

      final success = await container
          .read(loginControllerProvider.notifier)
          .submit('test@example.com', 'password123');

      expect(success, isTrue);
      final state = container.read(loginControllerProvider);
      expect(state.hasError, isFalse);
      expect(state.isLoading, isFalse);
      verify(() => mockAuthRepository.login('test@example.com', 'password123'))
          .called(1);
    });

    test('submit sets AsyncError and returns false when repository throws', () async {
      const exception = UnauthorizedException('Invalid credentials');
      when(() => mockAuthRepository.login('test@example.com', 'wrongpassword'))
          .thenThrow(exception);

      final success = await container
          .read(loginControllerProvider.notifier)
          .submit('test@example.com', 'wrongpassword');

      expect(success, isFalse);
      final state = container.read(loginControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.error, equals(exception));
      expect(state.isLoading, isFalse);
    });

    test('transitions through AsyncLoading during submission', () async {
      final completer = Completer<User>();
      when(() => mockAuthRepository.login(any(), any()))
          .thenAnswer((_) => completer.future);

      final future = container
          .read(loginControllerProvider.notifier)
          .submit('test@example.com', 'password123');

      // State is immediately loading while pending
      expect(container.read(loginControllerProvider).isLoading, isTrue);

      completer.complete(TestFixtures.testUser);
      final result = await future;

      expect(result, isTrue);
      expect(container.read(loginControllerProvider).isLoading, isFalse);
      expect(container.read(loginControllerProvider).hasError, isFalse);
    });
  });
}
