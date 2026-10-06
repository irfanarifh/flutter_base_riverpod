import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/core/config/env.dart';
import 'package:flutter_template/core/config/flavor.dart';
import 'package:flutter_template/core/services/logger_service.dart';

class _FakeLoggerService extends LoggerService {
  String? lastWarning;

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    lastWarning = message;
  }
}

void main() {
  group('Flavor.fromAppFlavor', () {
    test('resolves valid flavor names correctly', () {
      expect(Flavor.fromAppFlavor('dev'), equals(Flavor.dev));
      expect(Flavor.fromAppFlavor('staging'), equals(Flavor.staging));
      expect(Flavor.fromAppFlavor('prod'), equals(Flavor.prod));
    });

    test('resolves case-insensitively and trims whitespace', () {
      expect(Flavor.fromAppFlavor(' DEV '), equals(Flavor.dev));
      expect(Flavor.fromAppFlavor('Staging'), equals(Flavor.staging));
      expect(Flavor.fromAppFlavor('PROD'), equals(Flavor.prod));
    });

    test('returns Flavor.dev when value is null in non-release mode', () {
      final flavor = Flavor.fromAppFlavor(null, isRelease: false);
      expect(flavor, equals(Flavor.dev));
    });

    test('throws StateError when value is null in release mode', () {
      expect(
        () => Flavor.fromAppFlavor(null, isRelease: true),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Release build without --flavor. Use: flutter build <target> --flavor prod'),
          ),
        ),
      );
    });

    test('throws StateError for unknown flavor names listing valid names', () {
      expect(
        () => Flavor.fromAppFlavor('qa'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            allOf([
              contains('Invalid flavor: "qa"'),
              contains('dev, staging, prod'),
            ]),
          ),
        ),
      );
    });
  });

  group('Flavor getters', () {
    test('envFileName maps to corresponding .env files', () {
      expect(Flavor.dev.envFileName, equals('.env.dev'));
      expect(Flavor.staging.envFileName, equals('.env.staging'));
      expect(Flavor.prod.envFileName, equals('.env.prod'));
    });

    test('isDev, isStaging, and isProd return correct flags', () {
      expect(Flavor.dev.isDev, isTrue);
      expect(Flavor.dev.isStaging, isFalse);
      expect(Flavor.dev.isProd, isFalse);

      expect(Flavor.staging.isDev, isFalse);
      expect(Flavor.staging.isStaging, isTrue);
      expect(Flavor.staging.isProd, isFalse);

      expect(Flavor.prod.isDev, isFalse);
      expect(Flavor.prod.isStaging, isFalse);
      expect(Flavor.prod.isProd, isTrue);
    });
  });

  group('Env.validateFlavor', () {
    test('does not throw when .env FLAVOR matches target flavor', () {
      dotenv.testLoad(fileInput: 'FLAVOR=dev\nBASE_URL=https://dev.example.com\n');
      expect(() => Env.validateFlavor(Flavor.dev), returnsNormally);
    });

    test('logs warning without throwing in non-release mode on mismatch', () {
      dotenv.testLoad(fileInput: 'FLAVOR=staging\nBASE_URL=https://staging.example.com\n');
      final fakeLogger = _FakeLoggerService();

      expect(
        () => Env.validateFlavor(
          Flavor.dev,
          isRelease: false,
          logger: fakeLogger,
        ),
        returnsNormally,
      );
      expect(fakeLogger.lastWarning, contains('Flavor mismatch detected'));
      expect(fakeLogger.lastWarning, contains('dev'));
      expect(fakeLogger.lastWarning, contains('staging'));
    });

    test('throws StateError in release mode on mismatch', () {
      dotenv.testLoad(fileInput: 'FLAVOR=dev\nBASE_URL=https://dev.example.com\n');

      expect(
        () => Env.validateFlavor(Flavor.prod, isRelease: true),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('Flavor mismatch detected'),
        )),
      );
    });
  });
}
