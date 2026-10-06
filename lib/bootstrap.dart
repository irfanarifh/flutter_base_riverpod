import 'dart:async';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/core/config/env.dart';
import 'package:flutter_template/core/config/flavor.dart';
import 'package:flutter_template/core/services/logger_service.dart';
import 'package:flutter_template/shared/providers/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> bootstrap({required Flavor flavor}) async {
  await runZonedGuarded<Future<void>>(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      // Load environment variables for selected flavor
      await dotenv.load(fileName: flavor.envFileName);

      // Verify that the loaded .env FLAVOR matches the bootstrap flavor
      Env.validateFlavor(flavor);

      // Pre-initialize SharedPreferences for synchronous injection
      final prefs = await SharedPreferences.getInstance();

      // Wire up Flutter framework error reporting
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        LoggerService.recordFlutterError(details);
      };

      // Wire up asynchronous platform errors
      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        LoggerService.recordError(error, stack);
        return true;
      };

      runApp(
        ProviderScope(
          overrides: [
            sharedPrefsProvider.overrideWithValue(prefs),
          ],
          child: const App(),
        ),
      );

      // Remove native splash screen once framework initialization completes
      FlutterNativeSplash.remove();
    },
    (Object error, StackTrace stack) {
      LoggerService.recordError(error, stack);
    },
  );
}
