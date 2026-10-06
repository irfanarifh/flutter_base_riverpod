sealed class AppException implements Exception {
  const AppException(this.message, [this.stackTrace]);

  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Network connection error. Please check your internet connection.',
    super.stackTrace,
  ]);
}

final class RequestTimeoutException extends AppException {
  const RequestTimeoutException([
    super.message = 'Connection timed out. Please try again.',
    super.stackTrace,
  ]);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Unauthorized. Please log in again.',
    super.stackTrace,
  ]);
}

final class ServerException extends AppException {
  const ServerException({
    this.statusCode,
    this.code,
    String message = 'A server error occurred. Please try again later.',
    StackTrace? stackTrace,
  }) : super(message, stackTrace);

  final int? statusCode;
  final String? code;

  @override
  String toString() => 'ServerException (${code ?? statusCode}): $message';
}

final class CacheException extends AppException {
  const CacheException([
    super.message = 'Failed to access local cache or database.',
    super.stackTrace,
  ]);
}

final class UnknownException extends AppException {
  const UnknownException([
    super.message = 'An unexpected error occurred.',
    super.stackTrace,
  ]);
}
