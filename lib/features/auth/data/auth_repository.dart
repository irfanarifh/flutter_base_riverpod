import 'dart:convert';

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
    required this._authApi,
    required this._storageService,
  });

  final AuthApi _authApi;
  final StorageService _storageService;

  /// Authenticates user credentials, caches the access token, and returns the [User].
  ///
  /// If fetching the profile fails after the token was saved, the token is
  /// removed again so no half-finished session is left behind.
  Future<User> login(String email, String password) async {
    try {
      final token = await _authApi.login(
        LoginRequest(email: email, password: password),
      );
      await _storageService.saveToken(token.accessToken);
      try {
        final user = await _authApi.getMe(token.accessToken);
        await _cacheUser(user);
        return user;
      } catch (_) {
        await _storageService.deleteToken();
        rethrow;
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    } on AppException {
      rethrow;
    } catch (e, stack) {
      throw UnknownException(e.toString(), stack);
    }
  }

  /// Clears user credentials and cached profile.
  Future<void> logout() async {
    await _clearSession();
  }

  /// Restores the session from secure storage.
  ///
  /// - No token: returns `null`.
  /// - Token rejected by the server (unauthorized): clears the session and
  ///   returns `null`.
  /// - Any other failure (offline, timeout, server down): keeps the token and
  ///   returns the cached user, so the app stays usable offline.
  Future<User?> restoreSession() async {
    final token = await _storageService.readToken();
    if (token == null || token.isEmpty) {
      await _storageService.deleteUserJson();
      return null;
    }

    try {
      final user = await _authApi.getMe(token);
      await _cacheUser(user);
      return user;
    } on UnauthorizedException {
      await _clearSession();
      return null;
    } on DioException catch (e) {
      if (mapDioException(e) is UnauthorizedException) {
        await _clearSession();
        return null;
      }
      return _readCachedUser();
    } catch (_) {
      return _readCachedUser();
    }
  }

  Future<void> _clearSession() async {
    await _storageService.deleteToken();
    await _storageService.deleteUserJson();
  }

  Future<void> _cacheUser(User user) async {
    try {
      await _storageService.saveUserJson(jsonEncode(user.toJson()));
    } catch (_) {
      // Caching is best-effort and must never fail a login or restore.
    }
  }

  Future<User?> _readCachedUser() async {
    try {
      final raw = await _storageService.readUserJson();
      if (raw == null || raw.isEmpty) return null;
      return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
