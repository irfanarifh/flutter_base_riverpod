// =============================================================================
// HOW TO REMOVE THIS FEATURE
// =============================================================================
// 1. Delete folder: `lib/features/example/`.
// 2. Remove table from `AppDatabase`:
//    - In `lib/core/database/app_database.dart`, remove `ExampleItems` from `@DriftDatabase(tables: [...])`.
//    - Delete `lib/core/database/tables/example_items_table.dart`.
// 3. Remove routes from `lib/app/router/app_router.dart`:
//    - Remove the branch/routes for `ExampleListScreen` and `ExampleDetailScreen`.
//    - In `lib/app/router/app_routes.dart`, delete `examplePath`, `exampleName`, `exampleDetailPath`, `exampleDetailName`.
// 4. Remove tab from `lib/app/router/shell/main_shell.dart`:
//    - Remove the Example NavigationDestination from the navigation bar.
// 5. Bump `schemaVersion`:
//    - In `lib/core/database/app_database.dart`, increment `schemaVersion` (e.g. from 1 to 2).
// 6. Re-run codegen:
//    - Run `dart run build_runner build -d`.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/database/app_database_provider.dart';
import 'package:flutter_template/core/errors/app_exception.dart';
import 'package:flutter_template/features/example/data/local/example_dao.dart';
import 'package:flutter_template/features/example/model/example_item.dart';
import 'package:flutter_template/features/example/model/example_mapper.dart';

/// Exposes the [ExampleDao] singleton wired to the core [AppDatabase].
final exampleDaoProvider = Provider<ExampleDao>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ExampleDao(database);
});

/// Exposes the [ExampleRepository] offline-first data repository.
final exampleRepositoryProvider = Provider<ExampleRepository>((ref) {
  final dao = ref.watch(exampleDaoProvider);
  return ExampleRepository(dao);
});

/// Offline-first repository coordinating CRUD operations for example items.
class ExampleRepository {
  const ExampleRepository(this._dao);

  final ExampleDao _dao;

  /// Emits a reactive stream of all domain [ExampleItem]s matching [search].
  Stream<List<ExampleItem>> watchItems({String? search}) {
    try {
      return _dao
          .watchAll(search: search)
          .map((rows) => rows.map(ExampleMapper.fromDrift).toList());
    } catch (e, stackTrace) {
      throw CacheException(
        'Failed to observe example items: $e',
        stackTrace,
      );
    }
  }

  /// Retrieves a single domain [ExampleItem] by its [id], or `null` if not found.
  Future<ExampleItem?> getItem(int id) async {
    try {
      final row = await _dao.getById(id);
      return row != null ? ExampleMapper.fromDrift(row) : null;
    } catch (e, stackTrace) {
      throw CacheException(
        'Failed to get example item #$id: $e',
        stackTrace,
      );
    }
  }

  /// Adds a new example item and returns the persisted domain entity.
  Future<ExampleItem> add({required String title, String? note}) async {
    try {
      final companion = ExampleMapper.toInsertCompanion(
        title: title,
        note: note,
      );
      final id = await _dao.insert(companion);
      final row = await _dao.getById(id);
      if (row == null) {
        throw const CacheException(
          'Item could not be retrieved after insertion.',
        );
      }
      return ExampleMapper.fromDrift(row);
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw CacheException(
        'Failed to add example item: $e',
        stackTrace,
      );
    }
  }

  /// Updates an existing example item by [id].
  Future<void> update({
    required int id,
    required String title,
    String? note,
  }) async {
    try {
      final companion = ExampleMapper.toUpdateCompanion(
        id: id,
        title: title,
        note: note,
      );
      final success = await _dao.update(companion);
      if (!success) {
        throw CacheException('Item #$id not found for update.');
      }
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw CacheException(
        'Failed to update example item #$id: $e',
        stackTrace,
      );
    }
  }

  /// Removes an existing example item by [id].
  Future<void> remove(int id) async {
    try {
      final count = await _dao.delete(id);
      if (count == 0) {
        throw CacheException('Item #$id not found for deletion.');
      }
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw CacheException(
        'Failed to remove example item #$id: $e',
        stackTrace,
      );
    }
  }
}
