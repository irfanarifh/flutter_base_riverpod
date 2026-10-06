import 'package:dio/dio.dart';
import 'package:flutter_template/core/errors/error_mapper.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = mapDioException(err);
    handler.next(
      err.copyWith(
        error: appException,
        message: appException.message,
      ),
    );
  }
}
