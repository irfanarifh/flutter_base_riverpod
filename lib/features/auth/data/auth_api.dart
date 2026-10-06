import 'package:dio/dio.dart';
import 'package:flutter_template/core/errors/app_exception.dart';
import 'package:flutter_template/core/extensions/string_extension.dart';
import 'package:flutter_template/features/auth/model/auth_token.dart';
import 'package:flutter_template/features/auth/model/login_request.dart';
import 'package:flutter_template/features/auth/model/user.dart';

/// Data source interface for authentication endpoints.
abstract class AuthApi {
  Future<AuthToken> login(LoginRequest request);
  Future<User> getMe(String token);
}

/// REPLACEABLE: Mock authentication API implementation for local development.
///
/// Accepts any email with valid format and password with length >= 6.
class MockAuthApi implements AuthApi {
  @override
  Future<AuthToken> login(LoginRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!request.email.isValidEmail || request.password.length < 6) {
      throw const UnauthorizedException('Invalid email or password.');
    }

    return AuthToken(
      accessToken: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_token',
    );
  }

  @override
  Future<User> getMe(String token) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const User(
      id: 'mock_user_1',
      email: 'demo@example.com',
      name: 'Demo User',
    );
  }
}

/// Real HTTP authentication API consuming backend endpoints.
class RealAuthApi implements AuthApi {
  const RealAuthApi(this._dio);

  final Dio _dio;

  @override
  Future<AuthToken> login(LoginRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: request.toJson(),
    );
    final data = response.data?['data'] ?? response.data;
    return AuthToken.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<User> getMe(String token) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/auth/me',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    final data = response.data?['data'] ?? response.data;
    return User.fromJson(data as Map<String, dynamic>);
  }
}
