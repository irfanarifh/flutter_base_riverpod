import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template/features/example/data/example_repository.dart';
import 'package:flutter_template/features/example/model/example_item.dart';

part 'example_list_controller.g.dart';

/// Scoped provider holding the active search filter string for the example list.
@riverpod
class ExampleSearchQuery extends _$ExampleSearchQuery {
  @override
  String build() => '';

  /// Updates the active search query.
  void setQuery(String query) {
    state = query.trim();
  }

  /// Clears the active search query.
  void clear() {
    state = '';
  }
}

/// Reactive stream controller observing example items filtered by search query.
@riverpod
class ExampleListController extends _$ExampleListController {
  @override
  Stream<List<ExampleItem>> build() {
    final query = ref.watch(exampleSearchQueryProvider);
    return ref.watch(exampleRepositoryProvider).watchItems(search: query);
  }

  /// Updates the search filter query for the list.
  void setSearch(String query) {
    ref.read(exampleSearchQueryProvider.notifier).setQuery(query);
  }
}
