import 'package:drift/drift.dart' as drift;
import 'package:flutter_template/core/database/app_database.dart' as db;

/// Data Access Object for local SQLite operations on the [db.ExampleItems] table.
///
/// Implemented as a plain class without [DatabaseAccessor] inheritance to keep
/// table registration decoupled and modular without touching [AppDatabase].
class ExampleDao {
  const ExampleDao(this._db);

  final db.AppDatabase _db;

  /// Emits a reactive stream of all items, optionally filtered by [search].
  Stream<List<db.ExampleItem>> watchAll({String? search}) {
    final query = _db.select(_db.exampleItems);

    if (search != null && search.trim().isNotEmpty) {
      final pattern = '%${search.trim()}%';
      query.where((tbl) => tbl.title.like(pattern) | tbl.note.like(pattern));
    }

    query.orderBy([
      (tbl) => drift.OrderingTerm(
            expression: tbl.updatedAt,
            mode: drift.OrderingMode.desc,
          ),
    ]);

    return query.watch();
  }

  /// Fetches a single item by its unique [id], or returns `null` if not found.
  Future<db.ExampleItem?> getById(int id) {
    return (_db.select(_db.exampleItems)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// Inserts a new row into the table and returns the generated autoincrement ID.
  Future<int> insert(db.ExampleItemsCompanion companion) {
    return _db.into(_db.exampleItems).insert(companion);
  }

  /// Updates an existing row matching the companion's primary key.
  Future<bool> update(db.ExampleItemsCompanion companion) {
    return _db.update(_db.exampleItems).replace(companion);
  }

  /// Deletes a row matching the provided [id] and returns the count of deleted rows.
  Future<int> delete(int id) {
    return (_db.delete(_db.exampleItems)..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
