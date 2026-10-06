// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExampleItemImpl _$$ExampleItemImplFromJson(Map<String, dynamic> json) =>
    _$ExampleItemImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ExampleItemImplToJson(_$ExampleItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$ExampleItemDtoImpl _$$ExampleItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$ExampleItemDtoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ExampleItemDtoImplToJson(
        _$ExampleItemDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'note': instance.note,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
