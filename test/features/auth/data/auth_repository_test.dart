import 'dart:convert';

import 'package:flutter_template/core/errors/app_exception.dart';
import 'package:flutter_template/features/auth/data/auth_api.dart';
import 'package:flutter_template/features/auth/data/auth_repository.dart';
import 'package:flutter_template/features/auth/model/auth_token.dart';
import 'package:flutter_template/features/auth/model/login_request.dart';
import 'package:flutter_template/features/auth/model/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

class AuthApiMock extends Mock implements AuthApi {}

void main() {
  const user = User(id: '1', email: 'ana@example.com', name: 'Ana');

  late AuthApiMock api;
  late MockStorageService storage;
  late AuthRepository repository;

  setUpAll(() {
    registerFallbackValue(
      const LoginRequest(email: 'a@b.com', password: 'password'),
    );
  });

  setUp(() {
    api = AuthApiMock();
    storage = MockStorageService();
    when(() => storage.saveToken(any())).thenAnswer((_) async {});
    when(() => storage.deleteToken()).thenAnswer((_) async {});
    when(() => storage.saveUserJson(any())).thenAnswer((_) async {});
    when(() => storage.readUserJson()).thenAnswer((_) async => null);
    when(() => storage.deleteUserJson()).thenAnswer((_) async {});
    repository = AuthRepository(authApi: api, storageService: storage);
  });

  group('restoreSession', () {
    test('returns null and skips the API when there is no token', () async {
      when(() => storage.readToken()).thenAnswer((_) async => null);

      expect(await repository.restoreSession(), isNull);
      verifyNever(() => api.getMe(any()));
    });

    test('returns the user and caches it when the token is valid', () async {
      when(() => storage.readToken()).thenAnswer((_) async => 'tok');
      when(() => api.getMe('tok')).thenAnswer((_) async => user);

      expect(await repository.restoreSession(), user);
      verify(() => storage.saveUserJson(any())).called(1);
    });

    test('clears the session when the server rejects the token', () async {
      when(() => storage.readToken()).thenAnswer((_) async => 'tok');
      when(() => api.getMe('tok')).thenThrow(const UnauthorizedException());

      expect(await repository.restoreSession(), isNull);
      verify(() => storage.deleteToken()).called(1);
      verify(() => storage.deleteUserJson()).called(1);
    });

    test('keeps the token and returns the cached user when offline', () async {
      when(() => storage.readToken()).thenAnswer((_) async => 'tok');
      when(() => api.getMe('tok')).thenThrow(const NetworkException());
      when(() => storage.readUserJson()).thenAnswer((_) async => jsonEncode(user.toJson()));

      expect(await repository.restoreSession(), user);
      verifyNever(() => storage.deleteToken());
    });

    test('keeps the token and returns null when offline without cache', () async {
      when(() => storage.readToken()).thenAnswer((_) async => 'tok');
      when(() => api.getMe('tok')).thenThrow(const NetworkException());

      expect(await repository.restoreSession(), isNull);
      verifyNever(() => storage.deleteToken());
    });
  });

  group('login', () {
    test('stores the token, caches the user and returns it', () async {
      when(() => api.login(any())).thenAnswer((_) async => const AuthToken(accessToken: 't'));
      when(() => api.getMe('t')).thenAnswer((_) async => user);

      expect(await repository.login('ana@example.com', 'password'), user);
      verify(() => storage.saveToken('t')).called(1);
      verify(() => storage.saveUserJson(any())).called(1);
    });

    test('removes the saved token when fetching the profile fails', () async {
      when(() => api.login(any())).thenAnswer((_) async => const AuthToken(accessToken: 't'));
      when(() => api.getMe('t')).thenThrow(const NetworkException());

      await expectLater(
        repository.login('ana@example.com', 'password'),
        throwsA(isA<NetworkException>()),
      );
      verify(() => storage.saveToken('t')).called(1);
      verify(() => storage.deleteToken()).called(1);
    });
  });

  test('logout clears token and cached user', () async {
    await repository.logout();

    verify(() => storage.deleteToken()).called(1);
    verify(() => storage.deleteUserJson()).called(1);
  });
}
