// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hub2_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Hub2Metadata _$Hub2MetadataFromJson(Map<String, dynamic> json) {
  return _Hub2Metadata.fromJson(json);
}

/// @nodoc
mixin _$Hub2Metadata {
  String get id => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this Hub2Metadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Hub2Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $Hub2MetadataCopyWith<Hub2Metadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Hub2MetadataCopyWith<$Res> {
  factory $Hub2MetadataCopyWith(
          Hub2Metadata value, $Res Function(Hub2Metadata) then) =
      _$Hub2MetadataCopyWithImpl<$Res, Hub2Metadata>;
  @useResult
  $Res call({String id, String token, String status});
}

/// @nodoc
class _$Hub2MetadataCopyWithImpl<$Res, $Val extends Hub2Metadata>
    implements $Hub2MetadataCopyWith<$Res> {
  _$Hub2MetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Hub2Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? token = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$Hub2MetadataImplCopyWith<$Res>
    implements $Hub2MetadataCopyWith<$Res> {
  factory _$$Hub2MetadataImplCopyWith(
          _$Hub2MetadataImpl value, $Res Function(_$Hub2MetadataImpl) then) =
      __$$Hub2MetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String token, String status});
}

/// @nodoc
class __$$Hub2MetadataImplCopyWithImpl<$Res>
    extends _$Hub2MetadataCopyWithImpl<$Res, _$Hub2MetadataImpl>
    implements _$$Hub2MetadataImplCopyWith<$Res> {
  __$$Hub2MetadataImplCopyWithImpl(
      _$Hub2MetadataImpl _value, $Res Function(_$Hub2MetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of Hub2Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? token = null,
    Object? status = null,
  }) {
    return _then(_$Hub2MetadataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$Hub2MetadataImpl implements _Hub2Metadata {
  _$Hub2MetadataImpl({this.id = '', this.token = '', this.status = ''});

  factory _$Hub2MetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$Hub2MetadataImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String token;
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'Hub2Metadata(id: $id, token: $token, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Hub2MetadataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, token, status);

  /// Create a copy of Hub2Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Hub2MetadataImplCopyWith<_$Hub2MetadataImpl> get copyWith =>
      __$$Hub2MetadataImplCopyWithImpl<_$Hub2MetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$Hub2MetadataImplToJson(
      this,
    );
  }
}

abstract class _Hub2Metadata implements Hub2Metadata {
  factory _Hub2Metadata(
      {final String id,
      final String token,
      final String status}) = _$Hub2MetadataImpl;

  factory _Hub2Metadata.fromJson(Map<String, dynamic> json) =
      _$Hub2MetadataImpl.fromJson;

  @override
  String get id;
  @override
  String get token;
  @override
  String get status;

  /// Create a copy of Hub2Metadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Hub2MetadataImplCopyWith<_$Hub2MetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
