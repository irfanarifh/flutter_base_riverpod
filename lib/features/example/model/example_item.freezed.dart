// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExampleItem _$ExampleItemFromJson(Map<String, dynamic> json) {
  return _ExampleItem.fromJson(json);
}

/// @nodoc
mixin _$ExampleItem {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ExampleItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExampleItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExampleItemCopyWith<ExampleItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExampleItemCopyWith<$Res> {
  factory $ExampleItemCopyWith(
          ExampleItem value, $Res Function(ExampleItem) then) =
      _$ExampleItemCopyWithImpl<$Res, ExampleItem>;
  @useResult
  $Res call(
      {int id,
      String title,
      String? note,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ExampleItemCopyWithImpl<$Res, $Val extends ExampleItem>
    implements $ExampleItemCopyWith<$Res> {
  _$ExampleItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExampleItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? note = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExampleItemImplCopyWith<$Res>
    implements $ExampleItemCopyWith<$Res> {
  factory _$$ExampleItemImplCopyWith(
          _$ExampleItemImpl value, $Res Function(_$ExampleItemImpl) then) =
      __$$ExampleItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? note,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ExampleItemImplCopyWithImpl<$Res>
    extends _$ExampleItemCopyWithImpl<$Res, _$ExampleItemImpl>
    implements _$$ExampleItemImplCopyWith<$Res> {
  __$$ExampleItemImplCopyWithImpl(
      _$ExampleItemImpl _value, $Res Function(_$ExampleItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExampleItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? note = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ExampleItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExampleItemImpl implements _ExampleItem {
  const _$ExampleItemImpl(
      {required this.id,
      required this.title,
      this.note,
      required this.createdAt,
      required this.updatedAt});

  factory _$ExampleItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExampleItemImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? note;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ExampleItem(id: $id, title: $title, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExampleItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, note, createdAt, updatedAt);

  /// Create a copy of ExampleItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExampleItemImplCopyWith<_$ExampleItemImpl> get copyWith =>
      __$$ExampleItemImplCopyWithImpl<_$ExampleItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExampleItemImplToJson(
      this,
    );
  }
}

abstract class _ExampleItem implements ExampleItem {
  const factory _ExampleItem(
      {required final int id,
      required final String title,
      final String? note,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ExampleItemImpl;

  factory _ExampleItem.fromJson(Map<String, dynamic> json) =
      _$ExampleItemImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get note;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ExampleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExampleItemImplCopyWith<_$ExampleItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExampleItemDto _$ExampleItemDtoFromJson(Map<String, dynamic> json) {
  return _ExampleItemDto.fromJson(json);
}

/// @nodoc
mixin _$ExampleItemDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ExampleItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExampleItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExampleItemDtoCopyWith<ExampleItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExampleItemDtoCopyWith<$Res> {
  factory $ExampleItemDtoCopyWith(
          ExampleItemDto value, $Res Function(ExampleItemDto) then) =
      _$ExampleItemDtoCopyWithImpl<$Res, ExampleItemDto>;
  @useResult
  $Res call(
      {int id,
      String title,
      String? note,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$ExampleItemDtoCopyWithImpl<$Res, $Val extends ExampleItemDto>
    implements $ExampleItemDtoCopyWith<$Res> {
  _$ExampleItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExampleItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? note = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExampleItemDtoImplCopyWith<$Res>
    implements $ExampleItemDtoCopyWith<$Res> {
  factory _$$ExampleItemDtoImplCopyWith(_$ExampleItemDtoImpl value,
          $Res Function(_$ExampleItemDtoImpl) then) =
      __$$ExampleItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? note,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$ExampleItemDtoImplCopyWithImpl<$Res>
    extends _$ExampleItemDtoCopyWithImpl<$Res, _$ExampleItemDtoImpl>
    implements _$$ExampleItemDtoImplCopyWith<$Res> {
  __$$ExampleItemDtoImplCopyWithImpl(
      _$ExampleItemDtoImpl _value, $Res Function(_$ExampleItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExampleItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? note = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ExampleItemDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExampleItemDtoImpl implements _ExampleItemDto {
  const _$ExampleItemDtoImpl(
      {required this.id,
      required this.title,
      this.note,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$ExampleItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExampleItemDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? note;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ExampleItemDto(id: $id, title: $title, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExampleItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, note, createdAt, updatedAt);

  /// Create a copy of ExampleItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExampleItemDtoImplCopyWith<_$ExampleItemDtoImpl> get copyWith =>
      __$$ExampleItemDtoImplCopyWithImpl<_$ExampleItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExampleItemDtoImplToJson(
      this,
    );
  }
}

abstract class _ExampleItemDto implements ExampleItemDto {
  const factory _ExampleItemDto(
          {required final int id,
          required final String title,
          final String? note,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$ExampleItemDtoImpl;

  factory _ExampleItemDto.fromJson(Map<String, dynamic> json) =
      _$ExampleItemDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get note;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of ExampleItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExampleItemDtoImplCopyWith<_$ExampleItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
