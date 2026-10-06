import 'package:flutter_template/core/errors/app_exception.dart';

/// A discriminated union representing either a successful [data] payload
/// or a typed [exception] failure.
sealed class Result<T> {
  const Result();

  /// Creates a successful result holding [data].
  const factory Result.success(T data) = Success<T>;

  /// Creates a failed result holding an [exception] and optional [stackTrace].
  const factory Result.failure(AppException exception, [StackTrace? stackTrace]) =
      FailureResult<T>;

  /// Returns `true` if this instance is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns `true` if this instance is a [FailureResult].
  bool get isFailure => this is FailureResult<T>;

  /// Unwraps the underlying value if [isSuccess], otherwise returns `null`.
  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        FailureResult() => null,
      };

  /// Unwraps the error exception if [isFailure], otherwise returns `null`.
  AppException? get errorOrNull => switch (this) {
        Success() => null,
        FailureResult(:final exception) => exception,
      };

  /// Pattern-matches over success and failure branches.
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException exception, StackTrace? stackTrace) failure,
  }) {
    return switch (this) {
      Success(:final data) => success(data),
      FailureResult(:final exception, :final stackTrace) =>
        failure(exception, stackTrace),
    };
  }
}

/// A successful [Result] containing [data].
final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

/// A failed [Result] containing the [exception] and optional [stackTrace].
final class FailureResult<T> extends Result<T> {
  const FailureResult(this.exception, [this.stackTrace]);

  final AppException exception;
  final StackTrace? stackTrace;
}
