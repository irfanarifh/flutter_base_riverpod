import 'package:dio/dio.dart';
import 'package:flutter_template/core/config/env.dart';
import 'package:flutter_template/core/services/logger_service.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);

  final LoggerService _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (Env.enableLogging) {
      final headers = Map<String, dynamic>.from(options.headers);
      if (headers.containsKey('Authorization')) {
        headers['Authorization'] = 'Bearer [REDACTED]';
      }
      _logger.info('--> ${options.method} ${options.uri}\nHeaders: $headers\nData: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (Env.enableLogging) {
      _logger.info('<-- ${response.statusCode} ${response.requestOptions.uri}\nData: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (Env.enableLogging) {
      _logger.warning('<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}: ${err.message}');
    }
    handler.next(err);
  }
}
