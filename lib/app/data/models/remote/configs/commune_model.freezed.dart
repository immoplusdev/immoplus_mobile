// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'commune_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommuneModel _$CommuneModelFromJson(Map<String, dynamic> json) {
  return _CommuneModel.fromJson(json);
}

/// @nodoc
mixin _$CommuneModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String get villeId => throw _privateConstructorUsedError;

  /// Serializes this CommuneModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommuneModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommuneModelCopyWith<CommuneModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommuneModelCopyWith<$Res> {
  factory $CommuneModelCopyWith(
          CommuneModel value, $Res Function(CommuneModel) then) =
      _$CommuneModelCopyWithImpl<$Res, CommuneModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      String? createdBy,
      String villeId});
}

/// @nodoc
class _$CommuneModelCopyWithImpl<$Res, $Val extends CommuneModel>
    implements $CommuneModelCopyWith<$Res> {
  _$CommuneModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommuneModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? createdBy = freezed,
    Object? villeId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      villeId: null == villeId
          ? _value.villeId
          : villeId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommuneModelImplCopyWith<$Res>
    implements $CommuneModelCopyWith<$Res> {
  factory _$$CommuneModelImplCopyWith(
          _$CommuneModelImpl value, $Res Function(_$CommuneModelImpl) then) =
      __$$CommuneModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      String? createdBy,
      String villeId});
}

/// @nodoc
class __$$CommuneModelImplCopyWithImpl<$Res>
    extends _$CommuneModelCopyWithImpl<$Res, _$CommuneModelImpl>
    implements _$$CommuneModelImplCopyWith<$Res> {
  __$$CommuneModelImplCopyWithImpl(
      _$CommuneModelImpl _value, $Res Function(_$CommuneModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommuneModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? createdBy = freezed,
    Object? villeId = null,
  }) {
    return _then(_$CommuneModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      villeId: null == villeId
          ? _value.villeId
          : villeId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommuneModelImpl implements _CommuneModel {
  const _$CommuneModelImpl(
      {this.id = '',
      this.name = '',
      this.createdAt = null,
      this.updatedAt = null,
      this.deletedAt = null,
      this.createdBy = null,
      this.villeId = ''});

  factory _$CommuneModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommuneModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final DateTime? createdAt;
  @override
  @JsonKey()
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final DateTime? deletedAt;
  @override
  @JsonKey()
  final String? createdBy;
  @override
  @JsonKey()
  final String villeId;

  @override
  String toString() {
    return 'CommuneModel(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, createdBy: $createdBy, villeId: $villeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommuneModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.villeId, villeId) || other.villeId == villeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, createdAt, updatedAt,
      deletedAt, createdBy, villeId);

  /// Create a copy of CommuneModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommuneModelImplCopyWith<_$CommuneModelImpl> get copyWith =>
      __$$CommuneModelImplCopyWithImpl<_$CommuneModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommuneModelImplToJson(
      this,
    );
  }
}

abstract class _CommuneModel implements CommuneModel {
  const factory _CommuneModel(
      {final String id,
      final String name,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final DateTime? deletedAt,
      final String? createdBy,
      final String villeId}) = _$CommuneModelImpl;

  factory _CommuneModel.fromJson(Map<String, dynamic> json) =
      _$CommuneModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get deletedAt;
  @override
  String? get createdBy;
  @override
  String get villeId;

  /// Create a copy of CommuneModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommuneModelImplCopyWith<_$CommuneModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
