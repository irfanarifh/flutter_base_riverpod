import 'package:dio/dio.dart';
import 'package:flutter_template/core/errors/app_exception.dart';
import 'package:flutter_template/core/network/api_response.dart';

/// Helpers to read the `{code, message, data}` envelope from a Dio [Response].
///
/// Failing codes are normally rejected earlier by `ApiResponseInterceptor`;
/// the checks here keep the helpers safe when used with a bare [Dio] client.
extension ApiResponseUnwrap on Response<dynamic> {
  /// Returns the envelope `data`, parsed with [fromJson].
  ///
  /// Throws [ServerException] when the code is not successful and
  /// [UnknownException] when the body is not an envelope or has no data.
  T unwrap<T>(T Function(Object? json) fromJson) {
    final parsed = _parse<T>(fromJson);
    final value = parsed.data;
    if (value == null) {
      throw const UnknownException('The server response contains no data.');
    }
    return value;
  }

  /// Validates the envelope code and ignores `data` (for delete/update calls).
  void ensureSuccess() {
    _parse<Object?>((json) => json);
  }

  ApiResponse<T> _parse<T>(T Function(Object? json) fromJson) {
    final body = data;
    if (body is! Map<String, dynamic>) {
      throw const UnknownException('Unexpected response format.');
    }
    final parsed = ApiResponse<T>.fromJson(body, fromJson);
    if (!parsed.isSuccess) {
      throw ServerException(
        statusCode: statusCode,
        code: parsed.code,
        message: parsed.message ?? 'Request failed (code ${parsed.code}).',
      );
    }
    return parsed;
  }
}
