import 'package:dio/dio.dart';
import 'package:flutter_template/core/config/env.dart';
import 'package:flutter_template/core/services/logger_service.dart';

/// JSON keys whose values must never reach the logs (compared lowercase).
const Set<String> _sensitiveKeys = <String>{
  'password',
  'newpassword',
  'oldpassword',
  'confirmpassword',
  'token',
  'accesstoken',
  'access_token',
  'refreshtoken',
  'refresh_token',
  'authorization',
  'secret',
  'otp',
  'pin',
};

const String _redacted = '[REDACTED]';

/// Returns a copy of [data] with sensitive keys replaced by `[REDACTED]`.
Object? redactSensitive(Object? data) {
  if (data is Map) {
    return <String, Object?>{
      for (final entry in data.entries)
        entry.key.toString(): _sensitiveKeys.contains(entry.key.toString().toLowerCase()) ? _redacted : redactSensitive(entry.value),
    };
  }
  if (data is List) {
    return data.map(redactSensitive).toList();
  }
  if (data is FormData) {
    return '[FormData omitted]';
  }
  return data;
}

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);

  final LoggerService _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (Env.enableLogging) {
      final headers = Map<String, dynamic>.from(options.headers);
      if (headers.containsKey('Authorization')) {
        headers['Authorization'] = 'Bearer $_redacted';
      }
      _logger.info(
        '--> ${options.method} ${options.uri}\n'
        'Headers: $headers\n'
        'Data: ${redactSensitive(options.data)}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (Env.enableLogging) {
      _logger.info(
        '<-- ${response.statusCode} ${response.requestOptions.uri}\n'
        'Data: ${redactSensitive(response.data)}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (Env.enableLogging) {
      _logger.warning(
        '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}: '
        '${err.message}\n'
        'Data: ${redactSensitive(err.response?.data)}',
      );
    }
    handler.next(err);
  }
}
