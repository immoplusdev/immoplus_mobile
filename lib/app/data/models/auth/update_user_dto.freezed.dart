// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateUserDto _$UpdateUserDtoFromJson(Map<String, dynamic> json) {
  return _UpdateUserDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateUserDto {
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this UpdateUserDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateUserDtoCopyWith<UpdateUserDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateUserDtoCopyWith<$Res> {
  factory $UpdateUserDtoCopyWith(
          UpdateUserDto value, $Res Function(UpdateUserDto) then) =
      _$UpdateUserDtoCopyWithImpl<$Res, UpdateUserDto>;
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      String? avatar,
      String email,
      String phoneNumber});
}

/// @nodoc
class _$UpdateUserDtoCopyWithImpl<$Res, $Val extends UpdateUserDto>
    implements $UpdateUserDtoCopyWith<$Res> {
  _$UpdateUserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? avatar = freezed,
    Object? email = null,
    Object? phoneNumber = null,
  }) {
    return _then(_value.copyWith(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateUserDtoImplCopyWith<$Res>
    implements $UpdateUserDtoCopyWith<$Res> {
  factory _$$UpdateUserDtoImplCopyWith(
          _$UpdateUserDtoImpl value, $Res Function(_$UpdateUserDtoImpl) then) =
      __$$UpdateUserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      String? avatar,
      String email,
      String phoneNumber});
}

/// @nodoc
class __$$UpdateUserDtoImplCopyWithImpl<$Res>
    extends _$UpdateUserDtoCopyWithImpl<$Res, _$UpdateUserDtoImpl>
    implements _$$UpdateUserDtoImplCopyWith<$Res> {
  __$$UpdateUserDtoImplCopyWithImpl(
      _$UpdateUserDtoImpl _value, $Res Function(_$UpdateUserDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? avatar = freezed,
    Object? email = null,
    Object? phoneNumber = null,
  }) {
    return _then(_$UpdateUserDtoImpl(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateUserDtoImpl implements _UpdateUserDto {
  const _$UpdateUserDtoImpl(
      {this.firstName = '',
      this.lastName = '',
      this.avatar,
      this.email = '',
      this.phoneNumber = ''});

  factory _$UpdateUserDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateUserDtoImplFromJson(json);

  @override
  @JsonKey()
  final String firstName;
  @override
  @JsonKey()
  final String lastName;
  @override
  final String? avatar;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String phoneNumber;

  @override
  String toString() {
    return 'UpdateUserDto(firstName: $firstName, lastName: $lastName, avatar: $avatar, email: $email, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserDtoImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, firstName, lastName, avatar, email, phoneNumber);

  /// Create a copy of UpdateUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserDtoImplCopyWith<_$UpdateUserDtoImpl> get copyWith =>
      __$$UpdateUserDtoImplCopyWithImpl<_$UpdateUserDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateUserDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdateUserDto implements UpdateUserDto {
  const factory _UpdateUserDto(
      {final String firstName,
      final String lastName,
      final String? avatar,
      final String email,
      final String phoneNumber}) = _$UpdateUserDtoImpl;

  factory _UpdateUserDto.fromJson(Map<String, dynamic> json) =
      _$UpdateUserDtoImpl.fromJson;

  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get avatar;
  @override
  String get email;
  @override
  String get phoneNumber;

  /// Create a copy of UpdateUserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateUserDtoImplCopyWith<_$UpdateUserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
