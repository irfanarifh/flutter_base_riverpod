import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/core/database/app_database.dart';
import 'package:flutter_template/features/example/data/local/example_dao.dart';
import 'package:flutter_template/features/example/model/example_mapper.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ExampleDao dao;

  setUp(() {
    db = createTestDatabase();
    dao = ExampleDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ExampleDao', () {
    test('insert adds a new item and getById retrieves it', () async {
      final companion = ExampleMapper.toInsertCompanion(
        title: 'Shopping List',
        note: 'Buy fruits and milk',
      );

      final id = await dao.insert(companion);
      expect(id, equals(1));

      final item = await dao.getById(id);
      expect(item, isNotNull);
      expect(item!.id, equals(id));
      expect(item.title, equals('Shopping List'));
      expect(item.note, equals('Buy fruits and milk'));
      expect(item.createdAt, isNotNull);
      expect(item.updatedAt, isNotNull);
    });

    test('watchAll emits empty list initially and updates upon insertion', () async {
      final initial = await dao.watchAll().first;
      expect(initial, isEmpty);

      final expectation = expectLater(
        dao.watchAll(),
        emitsThrough(
          predicate<List<dynamic>>(
            (items) => items.length == 1 && items.first.title == 'Item 1',
          ),
        ),
      );

      await dao.insert(ExampleMapper.toInsertCompanion(title: 'Item 1'));
      await expectation;
    });

    test('update modifies existing item fields', () async {
      final id = await dao.insert(
        ExampleMapper.toInsertCompanion(
          title: 'Initial Title',
          note: 'Initial Note',
        ),
      );

      final updateCompanion = ExampleMapper.toUpdateCompanion(
        id: id,
        title: 'Updated Title',
        note: 'Updated Note',
      );

      final success = await dao.update(updateCompanion);
      expect(success, isTrue);

      final item = await dao.getById(id);
      expect(item, isNotNull);
      expect(item!.title, equals('Updated Title'));
      expect(item.note, equals('Updated Note'));
    });

    test('delete removes item by id', () async {
      final id = await dao.insert(
        ExampleMapper.toInsertCompanion(title: 'Item to delete'),
      );

      final count = await dao.delete(id);
      expect(count, equals(1));

      final item = await dao.getById(id);
      expect(item, isNull);
    });
  });
}
