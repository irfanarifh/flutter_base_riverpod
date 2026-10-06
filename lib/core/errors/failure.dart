import 'package:flutter_template/core/errors/app_exception.dart';

class Failure {
  const Failure({
    required this.message,
    this.statusCode,
    this.exception,
    this.stackTrace,
  });

  factory Failure.fromException(Object exception, [StackTrace? stackTrace]) {
    if (exception is AppException) {
      return Failure(
        message: exception.message,
        statusCode: exception is ServerException ? exception.statusCode : null,
        exception: exception,
        stackTrace: stackTrace ?? exception.stackTrace,
      );
    }
    return Failure(
      message: exception.toString(),
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  final String message;
  final int? statusCode;
  final Object? exception;
  final StackTrace? stackTrace;

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}
