import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template/features/auth/controller/auth_controller.dart';

part 'login_controller.g.dart';

/// Scoped controller managing the transient submission state of the login form.
@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {
    // Initial idle state
  }

  /// Submits credentials to [AuthController] and guards against uncaught errors.
  Future<bool> submit(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authControllerProvider.notifier).login(email, password);
    });
    return !state.hasError;
  }
}
