import 'package:dio/dio.dart';
import 'package:flutter_template/core/errors/error_mapper.dart';
import 'package:flutter_template/core/network/api_response.dart';

/// Converts HTTP 2xx responses carrying business error envelopes into [DioException].
class ApiResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final body = response.data;
    if (body is Map<String, dynamic> && body.containsKey('code')) {
      final code = body['code']?.toString();
      if (code != ApiResponse.successCode) {
        final error = DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
        final exception = mapDioException(error);
        handler.reject(
          error.copyWith(error: exception, message: exception.message),
          true,
        );
        return;
      }
    }
    handler.next(response);
  }
}
