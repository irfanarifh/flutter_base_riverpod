import 'package:drift/drift.dart' as drift;
import 'package:flutter_template/core/database/app_database.dart' as db;
import 'package:flutter_template/features/example/model/example_item.dart';

/// Mapper translating between Drift database entities, domain models, and network DTOs.
abstract final class ExampleMapper {
  /// Converts a Drift database row to a domain [ExampleItem].
  static ExampleItem fromDrift(db.ExampleItem row) {
    return ExampleItem(
      id: row.id,
      title: row.title,
      note: row.note,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  /// Converts a domain [ExampleItem] to a Drift [db.ExampleItemsCompanion].
  static db.ExampleItemsCompanion toDriftCompanion(
    ExampleItem item, {
    bool nullToAbsent = false,
  }) {
    return db.ExampleItemsCompanion(
      id: drift.Value(item.id),
      title: drift.Value(item.title),
      note: item.note == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(item.note),
      createdAt: drift.Value(item.createdAt),
      updatedAt: drift.Value(item.updatedAt),
    );
  }

  /// Creates a Drift [db.ExampleItemsCompanion] for inserting a new item.
  static db.ExampleItemsCompanion toInsertCompanion({
    required String title,
    String? note,
  }) {
    final now = DateTime.now();
    return db.ExampleItemsCompanion.insert(
      title: title,
      note: drift.Value(note),
      createdAt: drift.Value(now),
      updatedAt: drift.Value(now),
    );
  }

  /// Creates a Drift [db.ExampleItemsCompanion] for updating an existing item.
  static db.ExampleItemsCompanion toUpdateCompanion({
    required int id,
    required String title,
    String? note,
  }) {
    return db.ExampleItemsCompanion(
      id: drift.Value(id),
      title: drift.Value(title),
      note: drift.Value(note),
      updatedAt: drift.Value(DateTime.now()),
    );
  }

  /// Converts a remote [ExampleItemDto] to a domain [ExampleItem].
  static ExampleItem fromDto(ExampleItemDto dto) {
    return ExampleItem(
      id: dto.id,
      title: dto.title,
      note: dto.note,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  /// Converts a domain [ExampleItem] to a remote [ExampleItemDto].
  static ExampleItemDto toDto(ExampleItem item) {
    return ExampleItemDto(
      id: item.id,
      title: item.title,
      note: item.note,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }
}

/// Convenience extensions for Drift entity mapping.
extension DriftExampleItemExtension on db.ExampleItem {
  ExampleItem toDomain() => ExampleMapper.fromDrift(this);
}

/// Convenience extensions for Domain model mapping.
extension DomainExampleItemExtension on ExampleItem {
  db.ExampleItemsCompanion toDriftCompanion({bool nullToAbsent = false}) =>
      ExampleMapper.toDriftCompanion(this, nullToAbsent: nullToAbsent);

  ExampleItemDto toDto() => ExampleMapper.toDto(this);
}

/// Convenience extensions for DTO model mapping.
extension DtoExampleItemExtension on ExampleItemDto {
  ExampleItem toDomain() => ExampleMapper.fromDto(this);
}
