import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/errors/app_exception.dart';
import 'package:flutter_template/core/errors/failure.dart';
import 'package:flutter_template/core/extensions/context_extension.dart';

extension AsyncValueExtension<T> on AsyncValue<T> {
  bool get isLoadingState => this is AsyncLoading<T>;

  String? get errorMessage {
    return whenOrNull(
      error: (error, _) {
        if (error is AppException) return error.message;
        if (error is Failure) return error.message;
        return error.toString();
      },
    );
  }

  void showSnackBarOnError(BuildContext context) {
    final message = errorMessage;
    if (message != null && message.isNotEmpty) {
      context.showSnack(message, isError: true);
    }
  }
}
