// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'particulier_registration_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ParticulierRegistrationResponse _$ParticulierRegistrationResponseFromJson(
    Map<String, dynamic> json) {
  return _ParticulierRegistrationResponse.fromJson(json);
}

/// @nodoc
mixin _$ParticulierRegistrationResponse {
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this ParticulierRegistrationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParticulierRegistrationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParticulierRegistrationResponseCopyWith<ParticulierRegistrationResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticulierRegistrationResponseCopyWith<$Res> {
  factory $ParticulierRegistrationResponseCopyWith(
          ParticulierRegistrationResponse value,
          $Res Function(ParticulierRegistrationResponse) then) =
      _$ParticulierRegistrationResponseCopyWithImpl<$Res,
          ParticulierRegistrationResponse>;
  @useResult
  $Res call({@JsonKey(name: 'name') String? name});
}

/// @nodoc
class _$ParticulierRegistrationResponseCopyWithImpl<$Res,
        $Val extends ParticulierRegistrationResponse>
    implements $ParticulierRegistrationResponseCopyWith<$Res> {
  _$ParticulierRegistrationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParticulierRegistrationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParticulierRegistrationResponseImplCopyWith<$Res>
    implements $ParticulierRegistrationResponseCopyWith<$Res> {
  factory _$$ParticulierRegistrationResponseImplCopyWith(
          _$ParticulierRegistrationResponseImpl value,
          $Res Function(_$ParticulierRegistrationResponseImpl) then) =
      __$$ParticulierRegistrationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'name') String? name});
}

/// @nodoc
class __$$ParticulierRegistrationResponseImplCopyWithImpl<$Res>
    extends _$ParticulierRegistrationResponseCopyWithImpl<$Res,
        _$ParticulierRegistrationResponseImpl>
    implements _$$ParticulierRegistrationResponseImplCopyWith<$Res> {
  __$$ParticulierRegistrationResponseImplCopyWithImpl(
      _$ParticulierRegistrationResponseImpl _value,
      $Res Function(_$ParticulierRegistrationResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParticulierRegistrationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
  }) {
    return _then(_$ParticulierRegistrationResponseImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticulierRegistrationResponseImpl
    implements _ParticulierRegistrationResponse {
  _$ParticulierRegistrationResponseImpl({@JsonKey(name: 'name') this.name});

  factory _$ParticulierRegistrationResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ParticulierRegistrationResponseImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String? name;

  @override
  String toString() {
    return 'ParticulierRegistrationResponse(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticulierRegistrationResponseImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of ParticulierRegistrationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticulierRegistrationResponseImplCopyWith<
          _$ParticulierRegistrationResponseImpl>
      get copyWith => __$$ParticulierRegistrationResponseImplCopyWithImpl<
          _$ParticulierRegistrationResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticulierRegistrationResponseImplToJson(
      this,
    );
  }
}

abstract class _ParticulierRegistrationResponse
    implements ParticulierRegistrationResponse {
  factory _ParticulierRegistrationResponse(
          {@JsonKey(name: 'name') final String? name}) =
      _$ParticulierRegistrationResponseImpl;

  factory _ParticulierRegistrationResponse.fromJson(Map<String, dynamic> json) =
      _$ParticulierRegistrationResponseImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Create a copy of ParticulierRegistrationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParticulierRegistrationResponseImplCopyWith<
          _$ParticulierRegistrationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
