import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_template/core/errors/app_exception.dart';
import 'package:flutter_template/core/network/api_unwrap.dart';
import 'package:flutter_template/core/network/interceptors/api_response_interceptor.dart';
import 'package:flutter_template/core/network/interceptors/error_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

/// Returns a fixed JSON body with HTTP 200 for every request.
class _JsonAdapter implements HttpClientAdapter {
  _JsonAdapter(this.body);

  final Map<String, dynamic> body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dioReturning(Map<String, dynamic> body, {bool withInterceptors = true}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = _JsonAdapter(body);
  if (withInterceptors) {
    dio.interceptors.addAll([ApiResponseInterceptor(), ErrorInterceptor()]);
  }
  return dio;
}

void main() {
  group('ApiResponseInterceptor', () {
    test('passes through a successful envelope (code "1")', () async {
      final dio = _dioReturning({
        'code': '1',
        'message': 'OK',
        'data': {'name': 'item'},
      });

      final response = await dio.get<Map<String, dynamic>>('/items');
      final name = response.unwrap(
        (json) => (json! as Map<String, dynamic>)['name'] as String,
      );

      expect(name, 'item');
    });

    test('accepts a numeric success code', () async {
      final dio = _dioReturning({'code': 1, 'message': 'OK', 'data': 'x'});

      final response = await dio.get<Map<String, dynamic>>('/items');

      expect(response.unwrap((json) => json! as String), 'x');
    });

    test('rejects HTTP 200 with a failing code as ServerException', () async {
      final dio = _dioReturning({
        'code': '-1',
        'message': 'Wrong password',
        'data': null,
      });

      await expectLater(
        dio.post<Map<String, dynamic>>('/auth/login'),
        throwsA(
          isA<DioException>().having(
            (e) => e.error,
            'error',
            isA<ServerException>().having((e) => e.code, 'code', '-1').having((e) => e.message, 'message', 'Wrong password'),
          ),
        ),
      );
    });

    test('ignores bodies that are not an envelope', () async {
      final dio = _dioReturning({'foo': 1});

      final response = await dio.get<Map<String, dynamic>>('/plain');

      expect(response.data, {'foo': 1});
    });
  });

  group('ApiResponseUnwrap (without interceptors)', () {
    test('unwrap throws ServerException for a failing code', () async {
      final dio = _dioReturning(
        {'code': '-2', 'message': 'Invalid input'},
        withInterceptors: false,
      );
      final response = await dio.get<Map<String, dynamic>>('/x');

      expect(
        () => response.unwrap((json) => json),
        throwsA(
          isA<ServerException>().having((e) => e.code, 'code', '-2').having((e) => e.message, 'message', 'Invalid input'),
        ),
      );
    });

    test('unwrap throws UnknownException when data is missing', () async {
      final dio = _dioReturning(
        {'code': '1', 'message': 'OK'},
        withInterceptors: false,
      );
      final response = await dio.get<Map<String, dynamic>>('/x');

      expect(
        () => response.unwrap((json) => json),
        throwsA(isA<UnknownException>()),
      );
    });

    test('ensureSuccess passes for code "1" without data', () async {
      final dio = _dioReturning(
        {'code': '1', 'message': 'Deleted'},
        withInterceptors: false,
      );
      final response = await dio.get<Map<String, dynamic>>('/x');

      expect(response.ensureSuccess, returnsNormally);
    });
  });
}
