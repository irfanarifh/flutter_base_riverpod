// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_item.freezed.dart';
part 'example_item.g.dart';

/// Immutable domain model representing an example item.
@freezed
class ExampleItem with _$ExampleItem {
  const factory ExampleItem({
    required int id,
    required String title,
    String? note,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ExampleItem;

  factory ExampleItem.fromJson(Map<String, dynamic> json) =>
      _$ExampleItemFromJson(json);
}

/// Data Transfer Object for remote API serialization.
@freezed
class ExampleItemDto with _$ExampleItemDto {
  const factory ExampleItemDto({
    required int id,
    required String title,
    String? note,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ExampleItemDto;

  factory ExampleItemDto.fromJson(Map<String, dynamic> json) =>
      _$ExampleItemDtoFromJson(json);
}
