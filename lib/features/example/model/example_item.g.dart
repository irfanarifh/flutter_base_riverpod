// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExampleItem _$ExampleItemFromJson(Map<String, dynamic> json) => _ExampleItem(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  note: json['note'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ExampleItemToJson(_ExampleItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_ExampleItemDto _$ExampleItemDtoFromJson(Map<String, dynamic> json) =>
    _ExampleItemDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ExampleItemDtoToJson(_ExampleItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'note': instance.note,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
