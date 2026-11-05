import 'package:flutter_native_splash/flutter_native_splash.dart';

/// Releases the native splash screen exactly once.
///
/// `bootstrap` keeps the splash up with `FlutterNativeSplash.preserve`; the
/// app calls [remove] as soon as the session is restored, and `bootstrap`
/// calls it as a safety net so the splash can never stay forever.
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
