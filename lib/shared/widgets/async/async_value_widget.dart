import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/errors/app_exception.dart';
import 'package:flutter_template/shared/widgets/feedback/empty_view.dart';
import 'package:flutter_template/shared/widgets/feedback/error_view.dart';
import 'package:flutter_template/shared/widgets/feedback/loading_indicator.dart';

/// Reusable generic widget wrapping Riverpod [AsyncValue] states with standard
/// loading, error (with retry), and optional empty-state handling.
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.onRetry,
    this.isEmpty,
    this.empty,
    this.skipLoadingOnRefresh = true,
  });

  /// The Riverpod async value to bind.
  final AsyncValue<T> value;

  /// Builder invoked when data is successfully available.
  final Widget Function(T data) data;

  /// Custom loading builder; defaults to [LoadingIndicator].
  final Widget Function()? loading;

  /// Custom error builder; defaults to [ErrorView].
  final Widget Function(Object error, StackTrace? stackTrace)? error;

  /// Optional retry callback provided to the default [ErrorView].
  final VoidCallback? onRetry;

  /// Predicate to determine if the data represents an empty collection.
  final bool Function(T data)? isEmpty;

  /// Custom empty state builder; defaults to [EmptyView].
  final Widget Function()? empty;

  /// Whether to retain previous data while refreshing in background.
  final bool skipLoadingOnRefresh;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      loading: () => loading != null ? loading!() : const LoadingIndicator(),
      error: (err, stack) {
        if (error != null) {
          return error!(err, stack);
        }
        return ErrorView(
          exception: err is AppException ? err : null,
          message: err is! AppException ? err.toString() : null,
          onRetry: onRetry,
        );
      },
      data: (result) {
        if (isEmpty != null && isEmpty!(result)) {
          return empty != null
              ? empty!()
              : const EmptyView(title: 'No items found');
        }
        return data(result);
      },
    );
  }
}
