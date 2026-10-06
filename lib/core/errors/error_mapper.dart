import 'package:dio/dio.dart';
import 'package:flutter_template/core/errors/app_exception.dart';
import 'package:flutter_template/core/network/api_response.dart';

AppException mapDioException(DioException error) {
  if (error.error is AppException) {
    return error.error as AppException;
  }

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return RequestTimeoutException(
        'Connection timeout. Please check your network connection and try again.',
        error.stackTrace,
      );
    case DioExceptionType.connectionError:
      return NetworkException(
        'Unable to connect to the server. Please verify your internet connection.',
        error.stackTrace,
      );
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;
      final responseCode =
          data is Map<String, dynamic> ? data['code']?.toString() : null;

      if (statusCode == 401 ||
          statusCode == 403 ||
          responseCode == ApiResponse.unauthenticatedCode) {
        final serverMessage = data is Map<String, dynamic>
            ? (data['message'] as String?)
            : null;
        return UnauthorizedException(
          serverMessage ?? 'Session expired. Please log in again.',
          error.stackTrace,
        );
      }

      final serverMessage = data is Map<String, dynamic>
          ? (data['message'] as String?)
          : null;

      return ServerException(
        statusCode: statusCode,
        code: responseCode,
        message: serverMessage ??
            'Server error occurred with status code $statusCode.',
        stackTrace: error.stackTrace,
      );
    case DioExceptionType.cancel:
      return const UnknownException('Request was cancelled.');
    case DioExceptionType.badCertificate:
      return NetworkException(
        'Security certificate validation failed.',
        error.stackTrace,
      );
    case DioExceptionType.unknown:
      return UnknownException(
        error.message ?? 'An unexpected network error occurred.',
        error.stackTrace,
      );
  }
}
