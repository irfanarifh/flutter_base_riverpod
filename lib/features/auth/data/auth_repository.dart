import 'package:dio/dio.dart';
import 'package:flutter_template/core/errors/app_exception.dart';
import 'package:flutter_template/core/errors/error_mapper.dart';
import 'package:flutter_template/core/services/storage_service.dart';
import 'package:flutter_template/features/auth/data/auth_api.dart';
import 'package:flutter_template/features/auth/model/login_request.dart';
import 'package:flutter_template/features/auth/model/user.dart';

/// Repository coordinating authentication workflows and token caching.
class AuthRepository {
  const AuthRepository({
    required AuthApi authApi,
    required StorageService storageService,
  })  : _authApi = authApi,
        _storageService = storageService;

  final AuthApi _authApi;
  final StorageService _storageService;

  /// Authenticates user credentials, caches the access token, and returns the [User].
  Future<User> login(String email, String password) async {
    try {
      final token = await _authApi.login(
        LoginRequest(email: email, password: password),
      );
      await _storageService.saveToken(token.accessToken);
      return await _authApi.getMe(token.accessToken);
    } on DioException catch (e) {
      throw mapDioException(e);
    } on AppException {
      rethrow;
    } catch (e, stack) {
      throw UnknownException(e.toString(), stack);
    }
  }

  /// Clears user credentials and cached tokens.
  Future<void> logout() async {
    await _storageService.deleteToken();
  }

  /// Checks for an existing token in secure storage and restores session.
  Future<User?> restoreSession() async {
    try {
      final token = await _storageService.readToken();
      if (token == null || token.isEmpty) {
        return null;
      }
      return await _authApi.getMe(token);
    } catch (_) {
      await _storageService.deleteToken();
      return null;
    }
  }
}
