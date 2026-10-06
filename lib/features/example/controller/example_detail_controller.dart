import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template/features/example/data/example_repository.dart';
import 'package:flutter_template/features/example/model/example_item.dart';

part 'example_detail_controller.g.dart';

/// Family controller managing the asynchronous state of a single example item by its [id].
@riverpod
class ExampleDetailController extends _$ExampleDetailController {
  @override
  Future<ExampleItem?> build(int id) async {
    return ref.watch(exampleRepositoryProvider).getItem(id);
  }

  /// Triggers a manual re-fetch of the item from storage.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(exampleRepositoryProvider).getItem(id);
    });
  }
}
