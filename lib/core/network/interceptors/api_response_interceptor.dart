import 'package:dio/dio.dart';
import 'package:flutter_template/core/errors/error_mapper.dart';
import 'package:flutter_template/core/network/api_response.dart';

/// Turns HTTP 2xx responses that carry a failing `{code, message, data}`
/// envelope into a [DioException].
///
/// Dio treats every 2xx status as success, but this backend reports business
/// failures (wrong password, validation errors, ...) with HTTP 200 and a
/// `code` other than [ApiResponse.successCode]. Without this interceptor those
/// responses would be parsed as if they succeeded.
///
/// Responses that have no `code` key (third-party APIs, plain JSON) pass
/// through untouched. The unauthenticated code (`-99`) is handled earlier by
/// `AuthInterceptor`, so register this interceptor after it.
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
