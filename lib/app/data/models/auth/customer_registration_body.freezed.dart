// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_registration_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CustomerRegistrationBody _$CustomerRegistrationBodyFromJson(
    Map<String, dynamic> json) {
  return _CustomerRegistrationBody.fromJson(json);
}

/// @nodoc
mixin _$CustomerRegistrationBody {
  String? get avatar => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;

  /// Serializes this CustomerRegistrationBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerRegistrationBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerRegistrationBodyCopyWith<CustomerRegistrationBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerRegistrationBodyCopyWith<$Res> {
  factory $CustomerRegistrationBodyCopyWith(CustomerRegistrationBody value,
          $Res Function(CustomerRegistrationBody) then) =
      _$CustomerRegistrationBodyCopyWithImpl<$Res, CustomerRegistrationBody>;
  @useResult
  $Res call(
      {String? avatar,
      String? firstName,
      String? lastName,
      String? email,
      String? phoneNumber,
      String? password});
}

/// @nodoc
class _$CustomerRegistrationBodyCopyWithImpl<$Res,
        $Val extends CustomerRegistrationBody>
    implements $CustomerRegistrationBodyCopyWith<$Res> {
  _$CustomerRegistrationBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerRegistrationBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avatar = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? password = freezed,
  }) {
    return _then(_value.copyWith(
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomerRegistrationBodyImplCopyWith<$Res>
    implements $CustomerRegistrationBodyCopyWith<$Res> {
  factory _$$CustomerRegistrationBodyImplCopyWith(
          _$CustomerRegistrationBodyImpl value,
          $Res Function(_$CustomerRegistrationBodyImpl) then) =
      __$$CustomerRegistrationBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? avatar,
      String? firstName,
      String? lastName,
      String? email,
      String? phoneNumber,
      String? password});
}

/// @nodoc
class __$$CustomerRegistrationBodyImplCopyWithImpl<$Res>
    extends _$CustomerRegistrationBodyCopyWithImpl<$Res,
        _$CustomerRegistrationBodyImpl>
    implements _$$CustomerRegistrationBodyImplCopyWith<$Res> {
  __$$CustomerRegistrationBodyImplCopyWithImpl(
      _$CustomerRegistrationBodyImpl _value,
      $Res Function(_$CustomerRegistrationBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of CustomerRegistrationBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avatar = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? password = freezed,
  }) {
    return _then(_$CustomerRegistrationBodyImpl(
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerRegistrationBodyImpl implements _CustomerRegistrationBody {
  _$CustomerRegistrationBodyImpl(
      {this.avatar,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.password});

  factory _$CustomerRegistrationBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerRegistrationBodyImplFromJson(json);

  @override
  final String? avatar;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? email;
  @override
  final String? phoneNumber;
  @override
  final String? password;

  @override
  String toString() {
    return 'CustomerRegistrationBody(avatar: $avatar, firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerRegistrationBodyImpl &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, avatar, firstName, lastName, email, phoneNumber, password);

  /// Create a copy of CustomerRegistrationBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerRegistrationBodyImplCopyWith<_$CustomerRegistrationBodyImpl>
      get copyWith => __$$CustomerRegistrationBodyImplCopyWithImpl<
          _$CustomerRegistrationBodyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerRegistrationBodyImplToJson(
      this,
    );
  }
}

abstract class _CustomerRegistrationBody implements CustomerRegistrationBody {
  factory _CustomerRegistrationBody(
      {final String? avatar,
      final String? firstName,
      final String? lastName,
      final String? email,
      final String? phoneNumber,
      final String? password}) = _$CustomerRegistrationBodyImpl;

  factory _CustomerRegistrationBody.fromJson(Map<String, dynamic> json) =
      _$CustomerRegistrationBodyImpl.fromJson;

  @override
  String? get avatar;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get email;
  @override
  String? get phoneNumber;
  @override
  String? get password;

  /// Create a copy of CustomerRegistrationBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerRegistrationBodyImplCopyWith<_$CustomerRegistrationBodyImpl>
      get copyWith => throw _privateConstructorUsedError;
}
