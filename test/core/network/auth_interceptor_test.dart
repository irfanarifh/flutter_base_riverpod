import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/core/errors/app_exception.dart';
import 'package:flutter_template/core/network/dio_provider.dart';
import 'package:flutter_template/core/network/interceptors/auth_interceptor.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

class MockResponseInterceptorHandler extends Mock
    implements ResponseInterceptorHandler {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

class FakeDioException extends Fake implements DioException {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  late MockStorageService mockStorageService;
  late ProviderContainer container;
  late AuthInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(FakeDioException());
    registerFallbackValue(FakeRequestOptions());
  });

  setUp(() {
    mockStorageService = MockStorageService();
    when(() => mockStorageService.deleteToken()).thenAnswer((_) => Future.value());
    container = ProviderContainer();
    final ref = container.read(Provider((ref) => ref));
    interceptor = AuthInterceptor(
      storageService: mockStorageService,
      ref: ref,
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthInterceptor', () {
    test('onRequest attaches Bearer token if present', () async {
      when(() => mockStorageService.readToken())
          .thenAnswer((_) async => 'valid_token_xyz');

      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer valid_token_xyz');
      verify(() => handler.next(options)).called(1);
    });

    test('onResponse passes through normal successful responses (code == "1")', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/data'),
        data: {'code': '1', 'message': 'OK', 'data': []},
        statusCode: 200,
      );
      final handler = MockResponseInterceptorHandler();

      await interceptor.onResponse(response, handler);

      verify(() => handler.next(response)).called(1);
      verifyNever(() => mockStorageService.deleteToken());
      expect(container.read(sessionExpiredProvider), 0);
    });

    test('onResponse detects code == "-99", deletes token, triggers sessionExpired, and rejects with UnauthorizedException', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/profile'),
        data: {'code': '-99', 'message': 'Session expired, please log in again', 'data': null},
        statusCode: 200,
      );
      final handler = MockResponseInterceptorHandler();

      await interceptor.onResponse(response, handler);

      verify(() => mockStorageService.deleteToken()).called(1);
      expect(container.read(sessionExpiredProvider), 1);

      final captured = verify(() => handler.reject(captureAny())).captured;
      expect(captured.first, isA<DioException>());
      final dioException = captured.first as DioException;
      expect(dioException.error, isA<UnauthorizedException>());
      expect((dioException.error as UnauthorizedException).message,
          'Session expired, please log in again');
    });

    test('onError triggers sessionExpired when response status is 401', () async {
      final error = DioException(
        requestOptions: RequestOptions(path: '/secure'),
        response: Response(
          requestOptions: RequestOptions(path: '/secure'),
          statusCode: 401,
        ),
      );
      final handler = MockErrorInterceptorHandler();

      await interceptor.onError(error, handler);

      verify(() => mockStorageService.deleteToken()).called(1);
      expect(container.read(sessionExpiredProvider), 1);
      verify(() => handler.next(error)).called(1);
    });

    test('onError triggers sessionExpired when response data code is -99', () async {
      final error = DioException(
        requestOptions: RequestOptions(path: '/secure'),
        response: Response(
          requestOptions: RequestOptions(path: '/secure'),
          data: {'code': '-99', 'message': 'Expired'},
          statusCode: 200,
        ),
      );
      final handler = MockErrorInterceptorHandler();

      await interceptor.onError(error, handler);

      verify(() => mockStorageService.deleteToken()).called(1);
      expect(container.read(sessionExpiredProvider), 1);
      verify(() => handler.next(error)).called(1);
    });
  });
}
