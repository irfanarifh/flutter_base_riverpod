import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/errors/app_exception.dart';
import 'package:flutter_template/core/network/api_response.dart';
import 'package:flutter_template/core/network/dio_provider.dart';
import 'package:flutter_template/core/services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.storageService,
    required this.ref,
  });

  final StorageService storageService;
  final Ref ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storageService.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final code = data['code']?.toString();
      if (code == ApiResponse.unauthenticatedCode) {
        await storageService.deleteToken();
        ref.read(sessionExpiredProvider.notifier).increment();

        final message = (data['message'] as String?) ??
            'Session expired. Please log in again.';
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: UnauthorizedException(message),
            message: message,
          ),
        );
        return;
      }
    }
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final data = err.response?.data;
    final isUnauthenticatedPayload =
        data is Map<String, dynamic> &&
        data['code']?.toString() == ApiResponse.unauthenticatedCode;

    if (err.response?.statusCode == 401 || isUnauthenticatedPayload) {
      await storageService.deleteToken();
      ref.read(sessionExpiredProvider.notifier).increment();
    }
    handler.next(err);
  }
}
