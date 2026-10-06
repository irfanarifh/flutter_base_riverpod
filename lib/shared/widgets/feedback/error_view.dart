import 'package:flutter/material.dart';
import 'package:flutter_template/core/errors/app_exception.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/shared/widgets/buttons/primary_button.dart';

/// Full-page or embedded error state representation with retry action.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    this.exception,
    this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.icon,
  });

  final AppException? exception;
  final String? message;
  final VoidCallback? onRetry;
  final String retryLabel;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final resolvedMessage = message ??
        exception?.message ??
        'An unexpected error occurred. Please try again.';

    final errorIcon = icon ??
        Icon(
          Icons.error_outline_rounded,
          size: 56,
          color: colorScheme.error,
        );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            errorIcon,
            const SizedBox(height: AppSpacing.md),
            Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              resolvedMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: retryLabel,
                onPressed: onRetry,
                isFullWidth: false,
                icon: const Icon(Icons.refresh, size: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
