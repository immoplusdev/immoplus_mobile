// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_otp_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoginOtpBody _$LoginOtpBodyFromJson(Map<String, dynamic> json) {
  return _LoginOtpBody.fromJson(json);
}

/// @nodoc
mixin _$LoginOtpBody {
  String get phoneNumber => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;

  /// Serializes this LoginOtpBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginOtpBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginOtpBodyCopyWith<LoginOtpBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginOtpBodyCopyWith<$Res> {
  factory $LoginOtpBodyCopyWith(
          LoginOtpBody value, $Res Function(LoginOtpBody) then) =
      _$LoginOtpBodyCopyWithImpl<$Res, LoginOtpBody>;
  @useResult
  $Res call({String phoneNumber, String otp, String source});
}

/// @nodoc
class _$LoginOtpBodyCopyWithImpl<$Res, $Val extends LoginOtpBody>
    implements $LoginOtpBodyCopyWith<$Res> {
  _$LoginOtpBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginOtpBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? otp = null,
    Object? source = null,
  }) {
    return _then(_value.copyWith(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginOtpBodyImplCopyWith<$Res>
    implements $LoginOtpBodyCopyWith<$Res> {
  factory _$$LoginOtpBodyImplCopyWith(
          _$LoginOtpBodyImpl value, $Res Function(_$LoginOtpBodyImpl) then) =
      __$$LoginOtpBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phoneNumber, String otp, String source});
}

/// @nodoc
class __$$LoginOtpBodyImplCopyWithImpl<$Res>
    extends _$LoginOtpBodyCopyWithImpl<$Res, _$LoginOtpBodyImpl>
    implements _$$LoginOtpBodyImplCopyWith<$Res> {
  __$$LoginOtpBodyImplCopyWithImpl(
      _$LoginOtpBodyImpl _value, $Res Function(_$LoginOtpBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginOtpBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? otp = null,
    Object? source = null,
  }) {
    return _then(_$LoginOtpBodyImpl(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginOtpBodyImpl implements _LoginOtpBody {
  const _$LoginOtpBodyImpl(
      {required this.phoneNumber, required this.otp, required this.source});

  factory _$LoginOtpBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginOtpBodyImplFromJson(json);

  @override
  final String phoneNumber;
  @override
  final String otp;
  @override
  final String source;

  @override
  String toString() {
    return 'LoginOtpBody(phoneNumber: $phoneNumber, otp: $otp, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginOtpBodyImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.source, source) || other.source == source));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber, otp, source);

  /// Create a copy of LoginOtpBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginOtpBodyImplCopyWith<_$LoginOtpBodyImpl> get copyWith =>
      __$$LoginOtpBodyImplCopyWithImpl<_$LoginOtpBodyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginOtpBodyImplToJson(
      this,
    );
  }
}

abstract class _LoginOtpBody implements LoginOtpBody {
  const factory _LoginOtpBody(
      {required final String phoneNumber,
      required final String otp,
      required final String source}) = _$LoginOtpBodyImpl;

  factory _LoginOtpBody.fromJson(Map<String, dynamic> json) =
      _$LoginOtpBodyImpl.fromJson;

  @override
  String get phoneNumber;
  @override
  String get otp;
  @override
  String get source;

  /// Create a copy of LoginOtpBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginOtpBodyImplCopyWith<_$LoginOtpBodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
