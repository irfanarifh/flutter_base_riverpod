import 'package:flutter_template/features/auth/controller/auth_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    final result = await AsyncValue.guard(() async {
      await ref.read(authControllerProvider.notifier).login(email, password);
    });
    if (!ref.mounted) return false;
    state = result;
    return !state.hasError;
  }
}
