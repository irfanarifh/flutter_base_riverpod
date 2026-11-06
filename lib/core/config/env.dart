import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_template/core/config/flavor.dart';
import 'package:flutter_template/core/services/logger_service.dart';

abstract final class Env {
  static Flavor get flavor {
    final rawFlavor = dotenv.get('FLAVOR', fallback: 'dev').toLowerCase();
    return Flavor.values.firstWhere(
      (element) => element.name == rawFlavor,
      orElse: () => Flavor.dev,
    );
  }

  static String get appName => dotenv.get('APP_NAME', fallback: 'Flutter App');

  static String get baseUrl {
    final url = dotenv.maybeGet('BASE_URL');
    if (url == null || url.trim().isEmpty) {
      throw StateError(
        'Missing required environment variable: BASE_URL. '
        'Ensure BASE_URL is declared in the loaded .env file.',
      );
    }
    return url.trim();
  }

  /// Safe to call before dotenv is loaded (returns `false`).
  static bool get enableLogging {
    if (!dotenv.isInitialized) return false;
    return dotenv.get('ENABLE_LOGGING', fallback: 'false').toLowerCase() == 'true';
  }

  /// Whether auth uses `MockAuthApi` instead of real backend (defaults to `false`).
  static bool get useMockApi => dotenv.get('USE_MOCK_API', fallback: 'false').toLowerCase() == 'true';

  static Duration get connectTimeout {
    final rawMs = int.tryParse(dotenv.get('CONNECT_TIMEOUT_MS', fallback: '15000'));
    return Duration(milliseconds: rawMs ?? 15000);
  }

  /// Validates loaded `FLAVOR` against bootstrap flavor, throwing in release mode on mismatch.
  static void validateFlavor(
    Flavor flavor, {
    bool isRelease = kReleaseMode,
    LoggerService logger = const LoggerService(),
  }) {
    final rawFlavor = dotenv.maybeGet('FLAVOR')?.trim().toLowerCase();
    if (rawFlavor != flavor.name) {
      final message = 'Flavor mismatch detected: application is running with flavor "${flavor.name}", '
          'but loaded environment (${flavor.envFileName}) specifies FLAVOR="$rawFlavor".';
      if (isRelease) {
        throw StateError(message);
      } else {
        logger.warning(message);
      }
    }
  }
}
