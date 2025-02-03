// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_password_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdatePasswordDto _$UpdatePasswordDtoFromJson(Map<String, dynamic> json) {
  return _UpdatePasswordDto.fromJson(json);
}

/// @nodoc
mixin _$UpdatePasswordDto {
  String get oldPassword => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;

  /// Serializes this UpdatePasswordDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdatePasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdatePasswordDtoCopyWith<UpdatePasswordDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdatePasswordDtoCopyWith<$Res> {
  factory $UpdatePasswordDtoCopyWith(
          UpdatePasswordDto value, $Res Function(UpdatePasswordDto) then) =
      _$UpdatePasswordDtoCopyWithImpl<$Res, UpdatePasswordDto>;
  @useResult
  $Res call({String oldPassword, String newPassword});
}

/// @nodoc
class _$UpdatePasswordDtoCopyWithImpl<$Res, $Val extends UpdatePasswordDto>
    implements $UpdatePasswordDtoCopyWith<$Res> {
  _$UpdatePasswordDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdatePasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldPassword = null,
    Object? newPassword = null,
  }) {
    return _then(_value.copyWith(
      oldPassword: null == oldPassword
          ? _value.oldPassword
          : oldPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdatePasswordDtoImplCopyWith<$Res>
    implements $UpdatePasswordDtoCopyWith<$Res> {
  factory _$$UpdatePasswordDtoImplCopyWith(_$UpdatePasswordDtoImpl value,
          $Res Function(_$UpdatePasswordDtoImpl) then) =
      __$$UpdatePasswordDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String oldPassword, String newPassword});
}

/// @nodoc
class __$$UpdatePasswordDtoImplCopyWithImpl<$Res>
    extends _$UpdatePasswordDtoCopyWithImpl<$Res, _$UpdatePasswordDtoImpl>
    implements _$$UpdatePasswordDtoImplCopyWith<$Res> {
  __$$UpdatePasswordDtoImplCopyWithImpl(_$UpdatePasswordDtoImpl _value,
      $Res Function(_$UpdatePasswordDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdatePasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldPassword = null,
    Object? newPassword = null,
  }) {
    return _then(_$UpdatePasswordDtoImpl(
      oldPassword: null == oldPassword
          ? _value.oldPassword
          : oldPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdatePasswordDtoImpl implements _UpdatePasswordDto {
  _$UpdatePasswordDtoImpl(
      {required this.oldPassword, required this.newPassword});

  factory _$UpdatePasswordDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatePasswordDtoImplFromJson(json);

  @override
  final String oldPassword;
  @override
  final String newPassword;

  @override
  String toString() {
    return 'UpdatePasswordDto(oldPassword: $oldPassword, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdatePasswordDtoImpl &&
            (identical(other.oldPassword, oldPassword) ||
                other.oldPassword == oldPassword) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, oldPassword, newPassword);

  /// Create a copy of UpdatePasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdatePasswordDtoImplCopyWith<_$UpdatePasswordDtoImpl> get copyWith =>
      __$$UpdatePasswordDtoImplCopyWithImpl<_$UpdatePasswordDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatePasswordDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdatePasswordDto implements UpdatePasswordDto {
  factory _UpdatePasswordDto(
      {required final String oldPassword,
      required final String newPassword}) = _$UpdatePasswordDtoImpl;

  factory _UpdatePasswordDto.fromJson(Map<String, dynamic> json) =
      _$UpdatePasswordDtoImpl.fromJson;

  @override
  String get oldPassword;
  @override
  String get newPassword;

  /// Create a copy of UpdatePasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdatePasswordDtoImplCopyWith<_$UpdatePasswordDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
