import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/network/api_unwrap.dart';
import 'package:flutter_template/core/network/dio_provider.dart';

/// Riverpod provider exposing the [ApiManager] singleton.
final apiManagerProvider = Provider<ApiManager>((ref) {
  return ApiManager(ref.watch(dioProvider));
});

/// High-level REST client wrapping [Dio] with automatic JSON envelope parsing.
class ApiManager {
  const ApiManager(this._dio);

  final Dio _dio;

  /// Exposes the underlying [Dio] instance for advanced configuration or raw operations.
  Dio get dio => _dio;

  /// Performs an HTTP GET request, optionally parsing envelope data with [fromJson].
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    if (fromJson != null) {
      return response.unwrap(fromJson);
    }
    return response as T;
  }

  /// Performs an HTTP POST request with support for JSON or [FormData].
  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    if (fromJson != null) {
      return response.unwrap(fromJson);
    }
    return response as T;
  }

  /// Performs an HTTP PUT request.
  Future<T> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.put<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    if (fromJson != null) {
      return response.unwrap(fromJson);
    }
    return response as T;
  }

  /// Performs an HTTP PATCH request.
  Future<T> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.patch<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    if (fromJson != null) {
      return response.unwrap(fromJson);
    }
    return response as T;
  }

  /// Performs an HTTP DELETE request.
  Future<T> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.delete<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    if (fromJson != null) {
      return response.unwrap(fromJson);
    }
    return response as T;
  }
}

