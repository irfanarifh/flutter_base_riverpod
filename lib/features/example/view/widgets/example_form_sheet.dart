import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/extensions/context_extension.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/utils/validators.dart';
import 'package:flutter_template/features/example/controller/example_form_controller.dart';
import 'package:flutter_template/features/example/model/example_item.dart';
import 'package:flutter_template/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_template/shared/widgets/dialogs/bottom_sheet_wrapper.dart';
import 'package:flutter_template/shared/widgets/feedback/app_snackbar.dart';
import 'package:flutter_template/shared/widgets/inputs/app_text_field.dart';

/// Modal bottom sheet form for adding or editing an [ExampleItem].
class ExampleFormSheet extends ConsumerStatefulWidget {
  const ExampleFormSheet({
    super.key,
    this.item,
  });

  /// Existing item if editing, or `null` if creating a new item.
  final ExampleItem? item;

  /// Shows the form bottom sheet and returns `true` if an item was saved.
  static Future<bool?> show(BuildContext context, {ExampleItem? item}) {
    final l10n = context.l10n;
    return BottomSheetWrapper.show<bool>(
      context,
      title: item == null ? l10n.addItem : l10n.editItem,
      child: ExampleFormSheet(item: item),
    );
  }

  @override
  ConsumerState<ExampleFormSheet> createState() => _ExampleFormSheetState();
}

class _ExampleFormSheetState extends ConsumerState<ExampleFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _noteController = TextEditingController(text: widget.item?.note ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final note = _noteController.text.trim().isEmpty
        ? null
        : _noteController.text.trim();

    final notifier = ref.read(exampleFormControllerProvider.notifier);
    final isEdit = widget.item != null;

    final success = isEdit
        ? await notifier.updateItem(
            id: widget.item!.id,
            title: title,
            note: note,
          )
        : await notifier.addItem(
            title: title,
            note: note,
          );

    if (mounted && success) {
      final l10n = context.l10n;
      AppSnackbar.showSuccess(
        context,
        isEdit ? l10n.itemUpdated : l10n.itemAdded,
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(exampleFormControllerProvider);
    final l10n = context.l10n;

    ref.listen(exampleFormControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        AppSnackbar.showError(
          context,
          next.error.toString(),
        );
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _titleController,
            label: l10n.title,
            hintText: 'e.g. Shopping List',
            validator: (value) => AppValidators.required(value, l10n.fieldRequired),
            textInputAction: TextInputAction.next,
            autofocus: true,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _noteController,
            label: l10n.note,
            hintText: 'e.g. Milk, eggs, bread...',
            maxLines: 4,
            minLines: 2,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: widget.item == null ? l10n.add : l10n.save,
            isLoading: formState.isLoading,
            onPressed: formState.isLoading ? null : _submit,
          ),
          // Additional padding for keyboard inset
          SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
        ],
      ),
    );
  }
}
