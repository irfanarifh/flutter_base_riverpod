import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template/features/example/controller/example_detail_controller.dart';
import 'package:flutter_template/features/example/data/example_repository.dart';

part 'example_form_controller.g.dart';

/// Scoped controller managing transient form submission state for add, edit, and delete operations.
@riverpod
class ExampleFormController extends _$ExampleFormController {
  @override
  FutureOr<void> build() {
    // Initial idle state
  }

  /// Inserts a new example item. Returns `true` if operation succeeded.
  Future<bool> addItem({
    required String title,
    String? note,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(exampleRepositoryProvider).add(
            title: title,
            note: note,
          );
    });
    return !state.hasError;
  }

  /// Updates an existing example item by [id]. Returns `true` if operation succeeded.
  Future<bool> updateItem({
    required int id,
    required String title,
    String? note,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(exampleRepositoryProvider).update(
            id: id,
            title: title,
            note: note,
          );
      ref.invalidate(exampleDetailControllerProvider(id));
    });
    return !state.hasError;
  }

  /// Deletes an existing example item by [id]. Returns `true` if operation succeeded.
  Future<bool> deleteItem(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(exampleRepositoryProvider).remove(id);
      ref.invalidate(exampleDetailControllerProvider(id));
    });
    return !state.hasError;
  }
}
