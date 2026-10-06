import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_template/core/extensions/context_extension.dart';
import 'package:flutter_template/core/theme/app_radius.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/utils/formatters.dart';
import 'package:flutter_template/features/example/controller/example_detail_controller.dart';
import 'package:flutter_template/features/example/controller/example_form_controller.dart';
import 'package:flutter_template/features/example/model/example_item.dart';
import 'package:flutter_template/features/example/view/widgets/example_form_sheet.dart';
import 'package:flutter_template/shared/widgets/async/async_value_widget.dart';
import 'package:flutter_template/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter_template/shared/widgets/feedback/app_snackbar.dart';
import 'package:flutter_template/shared/widgets/feedback/empty_view.dart';
import 'package:flutter_template/shared/widgets/feedback/error_view.dart';

/// Screen presenting the detailed information and actions for a single [ExampleItem].
class ExampleDetailScreen extends ConsumerWidget {
  const ExampleDetailScreen({
    super.key,
    required this.id,
  });

  /// The raw string ID passed via route parameters.
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numericId = int.tryParse(id);
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final theme = context.theme;

    if (numericId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.itemDetails)),
        body: const Center(
          child: ErrorView(message: 'Invalid item identifier.'),
        ),
      );
    }

    final detailAsync = ref.watch(exampleDetailControllerProvider(numericId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.itemDetails),
        actions: [
          detailAsync.maybeWhen(
            data: (item) {
              if (item == null) return const SizedBox.shrink();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: l10n.edit,
                    onPressed: () async {
                      await ExampleFormSheet.show(context, item: item);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: colorScheme.error,
                    ),
                    tooltip: l10n.delete,
                    onPressed: () async {
                      final confirmed = await ConfirmDialog.show(
                        context,
                        title: l10n.deleteItem,
                        message: l10n.deleteItemConfirm,
                        confirmLabel: l10n.delete,
                        cancelLabel: l10n.cancel,
                        isDestructive: true,
                      );

                      if (confirmed && context.mounted) {
                        final success = await ref
                            .read(exampleFormControllerProvider.notifier)
                            .deleteItem(item.id);

                        if (context.mounted && success) {
                          AppSnackbar.showSuccess(
                            context,
                            l10n.itemDeleted,
                          );
                          context.pop();
                        }
                      }
                    },
                  ),
                ],
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: AsyncValueWidget<ExampleItem?>(
        value: detailAsync,
        isEmpty: (item) => item == null,
        empty: () => EmptyView(
          title: l10n.noItemsFound,
          message: 'The requested item does not exist or has been removed.',
        ),
        onRetry: () {
          ref.read(exampleDetailControllerProvider(numericId).notifier).refresh();
        },
        data: (item) {
          final current = item!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.roundedLg,
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withAlpha(80),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: AppRadius.roundedSm,
                              ),
                              child: Text(
                                '#${current.id}',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          current.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (current.note != null &&
                            current.note!.trim().isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          const Divider(),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            l10n.note,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.outline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            current.note!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerLow,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.roundedMd,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        _MetadataRow(
                          label: 'Created',
                          value: AppFormatters.formatDateTime(current.createdAt),
                        ),
                        const Divider(height: AppSpacing.md),
                        _MetadataRow(
                          label: 'Updated',
                          value: AppFormatters.formatDateTime(current.updatedAt),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
