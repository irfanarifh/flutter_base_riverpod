import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/core/config/env.dart';
import 'package:flutter_template/core/config/flavor.dart';
import 'package:flutter_template/core/services/logger_service.dart';
import 'package:flutter_template/core/utils/splash_guard.dart';
import 'package:flutter_template/features/auth/controller/auth_controller.dart';
import 'package:flutter_template/shared/providers/auth_actions_provider.dart';
import 'package:flutter_template/shared/providers/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Upper bound for how long the native splash may stay visible.
const Duration _splashTimeout = Duration(seconds: 8);

Future<void> bootstrap({required Flavor flavor}) async {
  await runZonedGuarded<Future<void>>(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      // Wire up error reporting first so init failures are recorded too.
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        LoggerService.recordFlutterError(details);
      };
      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        LoggerService.recordError(error, stack);
        return true;
      };

      try {
        // Load environment variables for the selected flavor.
        await dotenv.load(fileName: flavor.envFileName);

        // Verify that the loaded .env FLAVOR matches the bootstrap flavor.
        Env.validateFlavor(flavor);

        // Pre-initialize SharedPreferences for synchronous injection.
        final prefs = await SharedPreferences.getInstance();

        runApp(
          ProviderScope(
            // In Riverpod 3, failing providers retry automatically by default.
            // Disable global retry to preserve deterministic error handling across UI states.
            // Trade-off: Transient network errors won't automatically self-heal without user action (e.g. pull-to-refresh).
            retry: (retryCount, error) => null,
            overrides: [
              sharedPrefsProvider.overrideWithValue(prefs),
              // Features must not import each other, so the logout action is
              // wired here, where every layer is allowed to be imported.
              logoutActionProvider.overrideWith(
                (ref) => () => ref.read(authControllerProvider.notifier).logout(),
              ),
            ],
            child: const App(),
          ),
        );

        // The app removes the splash once the session is restored; this is a
        // safety net for slow networks.
        unawaited(Future<void>.delayed(_splashTimeout, SplashGuard.remove));
      } catch (error, stack) {
        LoggerService.recordError(error, stack);
        runApp(
          ProviderScope(
            child: _BootstrapErrorApp(message: error.toString()),
          ),
        );
        SplashGuard.remove();
      }
    },
    (Object error, StackTrace stack) {
      LoggerService.recordError(error, stack);
    },
  );
}

/// Minimal fallback UI shown when initialization fails (for example a missing
/// `.env` file). It must not depend on Riverpod, theming or localization.
class _BootstrapErrorApp extends StatelessWidget {
  const _BootstrapErrorApp({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      color: Color(0xFF000000),
      fontSize: 14,
      decoration: TextDecoration.none,
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: const Color(0xFFFFFFFF),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              kDebugMode ? 'App failed to start.\n\n$message' : 'The app failed to start. Please reinstall or contact support.',
              textAlign: TextAlign.center,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}
