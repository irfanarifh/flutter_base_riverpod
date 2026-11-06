import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_template/core/network/api_manager.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockAdapter implements HttpClientAdapter {
  _MockAdapter(this.handler);

  final ResponseBody Function(RequestOptions options) handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('ApiManager', () {
    test('get<T> with fromJson parses envelope data', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = _MockAdapter(
          (options) => ResponseBody.fromString(
            jsonEncode({'code': '1', 'message': 'OK', 'data': {'id': '123', 'name': 'Item 1'}}),
            200,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
          ),
        );

      final apiManager = ApiManager(dio);
      final result = await apiManager.get<Map<String, dynamic>>(
        '/items/123',
        fromJson: (json) => json! as Map<String, dynamic>,
      );

      expect(result['id'], equals('123'));
      expect(result['name'], equals('Item 1'));
    });

    test('get without fromJson returns raw Response', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = _MockAdapter(
          (options) => ResponseBody.fromString(
            jsonEncode({'code': '1', 'message': 'OK', 'data': 'raw'}),
            200,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
          ),
        );

      final apiManager = ApiManager(dio);
      final response = await apiManager.get('/raw');

      expect(response, isA<Response<dynamic>>());
      expect((response as Response).statusCode, equals(200));
    });

    test('post<T> passes data and parses envelope', () async {
      String? capturedMethod;
      dynamic capturedData;

      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = _MockAdapter(
          (options) {
            capturedMethod = options.method;
            capturedData = options.data;
            return ResponseBody.fromString(
              jsonEncode({'code': '1', 'message': 'Created', 'data': {'token': 'jwt_123'}}),
              201,
              headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
            );
          },
        );

      final apiManager = ApiManager(dio);
      final result = await apiManager.post<String>(
        '/auth/login',
        data: {'email': 'test@example.com'},
        fromJson: (json) => (json! as Map<String, dynamic>)['token'] as String,
      );

      expect(capturedMethod, equals('POST'));
      expect(capturedData, equals({'email': 'test@example.com'}));
      expect(result, equals('jwt_123'));
    });

    test('put<T> passes data and parses envelope', () async {
      String? capturedMethod;

      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = _MockAdapter(
          (options) {
            capturedMethod = options.method;
            return ResponseBody.fromString(
              jsonEncode({'code': '1', 'message': 'Updated', 'data': {'success': true}}),
              200,
              headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
            );
          },
        );

      final apiManager = ApiManager(dio);
      final result = await apiManager.put<bool>(
        '/items/1',
        data: {'name': 'Updated'},
        fromJson: (json) => (json! as Map<String, dynamic>)['success'] as bool,
      );

      expect(capturedMethod, equals('PUT'));
      expect(result, isTrue);
    });

    test('patch<T> passes data and parses envelope', () async {
      String? capturedMethod;

      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = _MockAdapter(
          (options) {
            capturedMethod = options.method;
            return ResponseBody.fromString(
              jsonEncode({'code': '1', 'message': 'Patched', 'data': {'status': 'active'}}),
              200,
              headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
            );
          },
        );

      final apiManager = ApiManager(dio);
      final result = await apiManager.patch<String>(
        '/items/1',
        data: {'status': 'active'},
        fromJson: (json) => (json! as Map<String, dynamic>)['status'] as String,
      );

      expect(capturedMethod, equals('PATCH'));
      expect(result, equals('active'));
    });

    test('delete<T> passes path and returns response', () async {
      String? capturedMethod;

      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = _MockAdapter(
          (options) {
            capturedMethod = options.method;
            return ResponseBody.fromString(
              jsonEncode({'code': '1', 'message': 'Deleted', 'data': null}),
              200,
              headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
            );
          },
        );

      final apiManager = ApiManager(dio);
      final response = await apiManager.delete('/items/1');

      expect(capturedMethod, equals('DELETE'));
      expect(response, isA<Response<dynamic>>());
    });

    test('dio getter returns the underlying Dio instance', () {
      final dio = Dio();
      final apiManager = ApiManager(dio);
      expect(apiManager.dio, same(dio));
    });
  });
}

