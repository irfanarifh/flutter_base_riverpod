import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template/core/network/dio_provider.dart';
import 'package:flutter_template/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_template/features/auth/model/user.dart';

part 'auth_controller.g.dart';

/// Global controller managing user session and authentication status.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<User?> build() async {
    // Listen for 401 unauthenticated signals from AuthInterceptor
    ref.listen(sessionExpiredProvider, (previous, next) {
      if (next > 0) {
        logout();
      }
    });

    return ref.watch(authRepositoryProvider).restoreSession();
  }

  /// Performs user sign-in and updates authentication state.
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(authRepositoryProvider).login(email, password);
    });
    if (state.hasError) {
      Error.throwWithStackTrace(state.error!, state.stackTrace!);
    }
  }

  /// Clears user credentials and resets authentication state to null.
  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).logout();
      return null;
    });
  }
}
