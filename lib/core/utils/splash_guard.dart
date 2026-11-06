import 'package:flutter_native_splash/flutter_native_splash.dart';

/// Releases the native splash screen safely and at most once.
abstract final class SplashGuard {
  static bool _removed = false;

  static void remove() {
    if (_removed) return;
    _removed = true;
    try {
      FlutterNativeSplash.remove();
    } catch (_) {
      // Not preserved (e.g. in widget/integration tests): nothing to remove.
    }
  }
}
