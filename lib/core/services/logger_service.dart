import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/config/env.dart';

class LoggerService {
  const LoggerService();

  static void recordFlutterError(FlutterErrorDetails details) {
    if (!kReleaseMode || Env.enableLogging) {
      developer.log(
        details.exceptionAsString(),
        name: 'FlutterError',
        error: details.exception,
        stackTrace: details.stack,
      );
    }
  }

  static void recordError(Object error, StackTrace? stack) {
    if (!kReleaseMode || Env.enableLogging) {
      developer.log(
        error.toString(),
        name: 'AppError',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void info(String message) {
    _log('INFO', message);
  }

  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _log('WARNING', message, error, stackTrace);
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log('ERROR', message, error, stackTrace);
  }

  void _log(String level, String message, [Object? error, StackTrace? stackTrace]) {
    if (!kReleaseMode || Env.enableLogging) {
      developer.log(
        message,
        name: level,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

final loggerServiceProvider = Provider<LoggerService>((ref) {
  return const LoggerService();
});
