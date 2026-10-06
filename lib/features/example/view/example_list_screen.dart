import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_template/app/router/app_routes.dart';
import 'package:flutter_template/core/extensions/context_extension.dart';
import 'package:flutter_template/core/theme/app_radius.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/features/example/controller/example_form_controller.dart';
import 'package:flutter_template/features/example/controller/example_list_controller.dart';
import 'package:flutter_template/features/example/model/example_item.dart';
import 'package:flutter_template/features/example/view/widgets/example_form_sheet.dart';
import 'package:flutter_template/features/example/view/widgets/example_tile.dart';
import 'package:flutter_template/shared/widgets/async/async_value_widget.dart';
import 'package:flutter_template/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_template/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter_template/shared/widgets/feedback/app_snackbar.dart';
import 'package:flutter_template/shared/widgets/feedback/empty_view.dart';
import 'package:flutter_template/shared/widgets/inputs/search_field.dart';

/// Screen displaying the searchable, observable list of example items.
class ExampleListScreen extends ConsumerWidget {
  const ExampleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(exampleListControllerProvider);
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.example),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: SearchField(
              hintText: l10n.search,
              onSearch: (query) {
                ref
                    .read(exampleListControllerProvider.notifier)
                    .setSearch(query);
              },
            ),
          ),
          Expanded(
            child: AsyncValueWidget<List<ExampleItem>>(
              value: listAsync,
              isEmpty: (items) => items.isEmpty,
              empty: () => EmptyView(
                title: l10n.noItemsFound,
                message: l10n.emptyList,
                action: PrimaryButton(
                  isFullWidth: false,
                  label: l10n.addItem,
                  onPressed: () => ExampleFormSheet.show(context),
                ),
              ),
              onRetry: () => ref.invalidate(exampleListControllerProvider),
              data: (items) {
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(exampleListControllerProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(
                            right: AppSpacing.lg,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.error,
                            borderRadius: AppRadius.roundedMd,
                          ),
                          child: Icon(
                            Icons.delete,
                            color: colorScheme.onError,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          return ConfirmDialog.show(
                            context,
                            title: l10n.deleteItem,
                            message: l10n.deleteItemConfirm,
                            confirmLabel: l10n.delete,
                            cancelLabel: l10n.cancel,
                            isDestructive: true,
                          );
                        },
                        onDismissed: (direction) async {
                          final success = await ref
                              .read(exampleFormControllerProvider.notifier)
                              .deleteItem(item.id);

                          if (context.mounted && success) {
                            AppSnackbar.showSuccess(
                              context,
                              l10n.itemDeleted,
                            );
                          }
                        },
                        child: ExampleTile(
                          item: item,
                          onTap: () {
                            context.goNamed(
                              AppRoutes.exampleDetailName,
                              pathParameters: {'id': item.id.toString()},
                            );
                          },
                          onEdit: () {
                            ExampleFormSheet.show(context, item: item);
                          },
                          onDelete: () async {
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
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ExampleFormSheet.show(context),
        tooltip: l10n.addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
