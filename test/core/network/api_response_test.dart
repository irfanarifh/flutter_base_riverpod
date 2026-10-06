import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/core/network/api_response.dart';

void main() {
  group('ApiResponse', () {
    test('parses success response (code == "1")', () {
      final json = {
        'code': '1',
        'message': 'Success load data',
        'data': {'id': 123, 'name': 'Test Item'},
      };

      final response = ApiResponse.fromJson(
        json,
        (data) => (data as Map<String, dynamic>)['name'] as String,
      );

      expect(response.code, '1');
      expect(response.message, 'Success load data');
      expect(response.data, 'Test Item');
      expect(response.isSuccess, isTrue);
      expect(response.isError, isFalse);
      expect(response.isUnauthenticated, isFalse);
    });

    test('parses numeric code correctly into string', () {
      final json = {
        'code': 1,
        'message': 'OK',
        'data': 'payload',
      };

      final response = ApiResponse.fromJson(
        json,
        (data) => data as String,
      );

      expect(response.code, '1');
      expect(response.isSuccess, isTrue);
    });

    test('parses error response (code == "-1") with null data', () {
      final json = {
        'code': '-1',
        'message': 'Invalid credentials',
        'data': null,
      };

      final response = ApiResponse.fromJson(
        json,
        (data) => data.toString(),
      );

      expect(response.code, '-1');
      expect(response.message, 'Invalid credentials');
      expect(response.data, isNull);
      expect(response.isSuccess, isFalse);
      expect(response.isError, isTrue);
      expect(response.isUnauthenticated, isFalse);
    });

    test('parses unauthenticated response (code == "-99")', () {
      final json = {
        'code': '-99',
        'message': 'Token expired',
        'data': null,
      };

      final response = ApiResponse.fromJson(
        json,
        (data) => data.toString(),
      );

      expect(response.code, '-99');
      expect(response.message, 'Token expired');
      expect(response.data, isNull);
      expect(response.isSuccess, isFalse);
      expect(response.isError, isFalse);
      expect(response.isUnauthenticated, isTrue);
    });

    test('serializes to json correctly', () {
      const response = ApiResponse<String>(
        code: '1',
        message: 'Saved',
        data: 'custom_data',
      );

      final json = response.toJson((data) => data);

      expect(json['code'], '1');
      expect(json['message'], 'Saved');
      expect(json['data'], 'custom_data');
    });
  });
}
