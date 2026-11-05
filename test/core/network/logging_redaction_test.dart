import 'package:dio/dio.dart';
import 'package:flutter_template/core/network/interceptors/logging_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('redactSensitive', () {
    test('masks password in a request body', () {
      expect(
        redactSensitive({'email': 'a@b.com', 'password': 'secret123'}),
        {'email': 'a@b.com', 'password': '[REDACTED]'},
      );
    });

    test('masks tokens nested inside the response envelope', () {
      final result = redactSensitive({
        'code': '1',
        'data': {
          'accessToken': 'abc',
          'refresh_token': 'def',
          'user': {'name': 'Ana'},
        },
      });

      expect(result, {
        'code': '1',
        'data': {
          'accessToken': '[REDACTED]',
          'refresh_token': '[REDACTED]',
          'user': {'name': 'Ana'},
        },
      });
    });

    test('walks lists', () {
      expect(
        redactSensitive([
          {'token': 'x'},
          {'id': 1},
        ]),
        [
          {'token': '[REDACTED]'},
          {'id': 1},
        ],
      );
    });

    test('matches keys case-insensitively', () {
      expect(redactSensitive({'Password': 'x'}), {'Password': '[REDACTED]'});
    });

    test('does not print FormData', () {
      expect(redactSensitive(FormData()), '[FormData omitted]');
    });

    test('returns non-collection values unchanged', () {
      expect(redactSensitive('text'), 'text');
      expect(redactSensitive(42), 42);
      expect(redactSensitive(null), isNull);
    });
  });
}
