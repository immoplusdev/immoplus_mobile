// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_password_cubit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResetPasswordCubitState _$ResetPasswordCubitStateFromJson(
    Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'initial':
      return RESET_PASSWORD_INITIAL.fromJson(json);
    case 'sendingEmailOtp':
      return RESET_PASSWORD_SENDING_EMAIL_OTP.fromJson(json);
    case 'emailOtpSent':
      return RESET_PASSWORD_EMAIL_OTP_SENT.fromJson(json);
    case 'verifyingEmail':
      return RESET_PASSWORD_VERIFYING_EMAIL.fromJson(json);
    case 'emailVerified':
      return RESET_PASSWORD_EMAIL_VERIFIED.fromJson(json);
    case 'resettingPassword':
      return RESET_PASSWORD_RESETTING_PASSWORD.fromJson(json);
    case 'passwordResetSuccess':
      return RESET_PASSWORD_SUCCESS.fromJson(json);
    case 'error':
      return RESET_PASSWORD_ERROR.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json,
          'runtimeType',
          'ResetPasswordCubitState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$ResetPasswordCubitState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sendingEmailOtp,
    required TResult Function(String? message) emailOtpSent,
    required TResult Function() verifyingEmail,
    required TResult Function() emailVerified,
    required TResult Function() resettingPassword,
    required TResult Function(String? message) passwordResetSuccess,
    required TResult Function(String? errorMessage) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sendingEmailOtp,
    TResult? Function(String? message)? emailOtpSent,
    TResult? Function()? verifyingEmail,
    TResult? Function()? emailVerified,
    TResult? Function()? resettingPassword,
    TResult? Function(String? message)? passwordResetSuccess,
    TResult? Function(String? errorMessage)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sendingEmailOtp,
    TResult Function(String? message)? emailOtpSent,
    TResult Function()? verifyingEmail,
    TResult Function()? emailVerified,
    TResult Function()? resettingPassword,
    TResult Function(String? message)? passwordResetSuccess,
    TResult Function(String? errorMessage)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RESET_PASSWORD_INITIAL value) initial,
    required TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)
        sendingEmailOtp,
    required TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value) emailOtpSent,
    required TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)
        verifyingEmail,
    required TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)
        emailVerified,
    required TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)
        resettingPassword,
    required TResult Function(RESET_PASSWORD_SUCCESS value)
        passwordResetSuccess,
    required TResult Function(RESET_PASSWORD_ERROR value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult? Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult? Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult? Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult? Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult? Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult? Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult? Function(RESET_PASSWORD_ERROR value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult Function(RESET_PASSWORD_ERROR value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ResetPasswordCubitState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordCubitStateCopyWith<$Res> {
  factory $ResetPasswordCubitStateCopyWith(ResetPasswordCubitState value,
          $Res Function(ResetPasswordCubitState) then) =
      _$ResetPasswordCubitStateCopyWithImpl<$Res, ResetPasswordCubitState>;
}

/// @nodoc
class _$ResetPasswordCubitStateCopyWithImpl<$Res,
        $Val extends ResetPasswordCubitState>
    implements $ResetPasswordCubitStateCopyWith<$Res> {
  _$ResetPasswordCubitStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$RESET_PASSWORD_INITIALImplCopyWith<$Res> {
  factory _$$RESET_PASSWORD_INITIALImplCopyWith(
          _$RESET_PASSWORD_INITIALImpl value,
          $Res Function(_$RESET_PASSWORD_INITIALImpl) then) =
      __$$RESET_PASSWORD_INITIALImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RESET_PASSWORD_INITIALImplCopyWithImpl<$Res>
    extends _$ResetPasswordCubitStateCopyWithImpl<$Res,
        _$RESET_PASSWORD_INITIALImpl>
    implements _$$RESET_PASSWORD_INITIALImplCopyWith<$Res> {
  __$$RESET_PASSWORD_INITIALImplCopyWithImpl(
      _$RESET_PASSWORD_INITIALImpl _value,
      $Res Function(_$RESET_PASSWORD_INITIALImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$RESET_PASSWORD_INITIALImpl implements RESET_PASSWORD_INITIAL {
  const _$RESET_PASSWORD_INITIALImpl({final String? $type})
      : $type = $type ?? 'initial';

  factory _$RESET_PASSWORD_INITIALImpl.fromJson(Map<String, dynamic> json) =>
      _$$RESET_PASSWORD_INITIALImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ResetPasswordCubitState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RESET_PASSWORD_INITIALImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sendingEmailOtp,
    required TResult Function(String? message) emailOtpSent,
    required TResult Function() verifyingEmail,
    required TResult Function() emailVerified,
    required TResult Function() resettingPassword,
    required TResult Function(String? message) passwordResetSuccess,
    required TResult Function(String? errorMessage) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sendingEmailOtp,
    TResult? Function(String? message)? emailOtpSent,
    TResult? Function()? verifyingEmail,
    TResult? Function()? emailVerified,
    TResult? Function()? resettingPassword,
    TResult? Function(String? message)? passwordResetSuccess,
    TResult? Function(String? errorMessage)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sendingEmailOtp,
    TResult Function(String? message)? emailOtpSent,
    TResult Function()? verifyingEmail,
    TResult Function()? emailVerified,
    TResult Function()? resettingPassword,
    TResult Function(String? message)? passwordResetSuccess,
    TResult Function(String? errorMessage)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RESET_PASSWORD_INITIAL value) initial,
    required TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)
        sendingEmailOtp,
    required TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value) emailOtpSent,
    required TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)
        verifyingEmail,
    required TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)
        emailVerified,
    required TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)
        resettingPassword,
    required TResult Function(RESET_PASSWORD_SUCCESS value)
        passwordResetSuccess,
    required TResult Function(RESET_PASSWORD_ERROR value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult? Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult? Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult? Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult? Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult? Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult? Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult? Function(RESET_PASSWORD_ERROR value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult Function(RESET_PASSWORD_ERROR value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RESET_PASSWORD_INITIALImplToJson(
      this,
    );
  }
}

abstract class RESET_PASSWORD_INITIAL implements ResetPasswordCubitState {
  const factory RESET_PASSWORD_INITIAL() = _$RESET_PASSWORD_INITIALImpl;

  factory RESET_PASSWORD_INITIAL.fromJson(Map<String, dynamic> json) =
      _$RESET_PASSWORD_INITIALImpl.fromJson;
}

/// @nodoc
abstract class _$$RESET_PASSWORD_SENDING_EMAIL_OTPImplCopyWith<$Res> {
  factory _$$RESET_PASSWORD_SENDING_EMAIL_OTPImplCopyWith(
          _$RESET_PASSWORD_SENDING_EMAIL_OTPImpl value,
          $Res Function(_$RESET_PASSWORD_SENDING_EMAIL_OTPImpl) then) =
      __$$RESET_PASSWORD_SENDING_EMAIL_OTPImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RESET_PASSWORD_SENDING_EMAIL_OTPImplCopyWithImpl<$Res>
    extends _$ResetPasswordCubitStateCopyWithImpl<$Res,
        _$RESET_PASSWORD_SENDING_EMAIL_OTPImpl>
    implements _$$RESET_PASSWORD_SENDING_EMAIL_OTPImplCopyWith<$Res> {
  __$$RESET_PASSWORD_SENDING_EMAIL_OTPImplCopyWithImpl(
      _$RESET_PASSWORD_SENDING_EMAIL_OTPImpl _value,
      $Res Function(_$RESET_PASSWORD_SENDING_EMAIL_OTPImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$RESET_PASSWORD_SENDING_EMAIL_OTPImpl
    implements RESET_PASSWORD_SENDING_EMAIL_OTP {
  const _$RESET_PASSWORD_SENDING_EMAIL_OTPImpl({final String? $type})
      : $type = $type ?? 'sendingEmailOtp';

  factory _$RESET_PASSWORD_SENDING_EMAIL_OTPImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RESET_PASSWORD_SENDING_EMAIL_OTPImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ResetPasswordCubitState.sendingEmailOtp()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RESET_PASSWORD_SENDING_EMAIL_OTPImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sendingEmailOtp,
    required TResult Function(String? message) emailOtpSent,
    required TResult Function() verifyingEmail,
    required TResult Function() emailVerified,
    required TResult Function() resettingPassword,
    required TResult Function(String? message) passwordResetSuccess,
    required TResult Function(String? errorMessage) error,
  }) {
    return sendingEmailOtp();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sendingEmailOtp,
    TResult? Function(String? message)? emailOtpSent,
    TResult? Function()? verifyingEmail,
    TResult? Function()? emailVerified,
    TResult? Function()? resettingPassword,
    TResult? Function(String? message)? passwordResetSuccess,
    TResult? Function(String? errorMessage)? error,
  }) {
    return sendingEmailOtp?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sendingEmailOtp,
    TResult Function(String? message)? emailOtpSent,
    TResult Function()? verifyingEmail,
    TResult Function()? emailVerified,
    TResult Function()? resettingPassword,
    TResult Function(String? message)? passwordResetSuccess,
    TResult Function(String? errorMessage)? error,
    required TResult orElse(),
  }) {
    if (sendingEmailOtp != null) {
      return sendingEmailOtp();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RESET_PASSWORD_INITIAL value) initial,
    required TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)
        sendingEmailOtp,
    required TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value) emailOtpSent,
    required TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)
        verifyingEmail,
    required TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)
        emailVerified,
    required TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)
        resettingPassword,
    required TResult Function(RESET_PASSWORD_SUCCESS value)
        passwordResetSuccess,
    required TResult Function(RESET_PASSWORD_ERROR value) error,
  }) {
    return sendingEmailOtp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult? Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult? Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult? Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult? Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult? Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult? Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult? Function(RESET_PASSWORD_ERROR value)? error,
  }) {
    return sendingEmailOtp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult Function(RESET_PASSWORD_ERROR value)? error,
    required TResult orElse(),
  }) {
    if (sendingEmailOtp != null) {
      return sendingEmailOtp(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RESET_PASSWORD_SENDING_EMAIL_OTPImplToJson(
      this,
    );
  }
}

abstract class RESET_PASSWORD_SENDING_EMAIL_OTP
    implements ResetPasswordCubitState {
  const factory RESET_PASSWORD_SENDING_EMAIL_OTP() =
      _$RESET_PASSWORD_SENDING_EMAIL_OTPImpl;

  factory RESET_PASSWORD_SENDING_EMAIL_OTP.fromJson(Map<String, dynamic> json) =
      _$RESET_PASSWORD_SENDING_EMAIL_OTPImpl.fromJson;
}

/// @nodoc
abstract class _$$RESET_PASSWORD_EMAIL_OTP_SENTImplCopyWith<$Res> {
  factory _$$RESET_PASSWORD_EMAIL_OTP_SENTImplCopyWith(
          _$RESET_PASSWORD_EMAIL_OTP_SENTImpl value,
          $Res Function(_$RESET_PASSWORD_EMAIL_OTP_SENTImpl) then) =
      __$$RESET_PASSWORD_EMAIL_OTP_SENTImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$RESET_PASSWORD_EMAIL_OTP_SENTImplCopyWithImpl<$Res>
    extends _$ResetPasswordCubitStateCopyWithImpl<$Res,
        _$RESET_PASSWORD_EMAIL_OTP_SENTImpl>
    implements _$$RESET_PASSWORD_EMAIL_OTP_SENTImplCopyWith<$Res> {
  __$$RESET_PASSWORD_EMAIL_OTP_SENTImplCopyWithImpl(
      _$RESET_PASSWORD_EMAIL_OTP_SENTImpl _value,
      $Res Function(_$RESET_PASSWORD_EMAIL_OTP_SENTImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$RESET_PASSWORD_EMAIL_OTP_SENTImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RESET_PASSWORD_EMAIL_OTP_SENTImpl
    implements RESET_PASSWORD_EMAIL_OTP_SENT {
  const _$RESET_PASSWORD_EMAIL_OTP_SENTImpl({this.message, final String? $type})
      : $type = $type ?? 'emailOtpSent';

  factory _$RESET_PASSWORD_EMAIL_OTP_SENTImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RESET_PASSWORD_EMAIL_OTP_SENTImplFromJson(json);

  @override
  final String? message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ResetPasswordCubitState.emailOtpSent(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RESET_PASSWORD_EMAIL_OTP_SENTImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RESET_PASSWORD_EMAIL_OTP_SENTImplCopyWith<
          _$RESET_PASSWORD_EMAIL_OTP_SENTImpl>
      get copyWith => __$$RESET_PASSWORD_EMAIL_OTP_SENTImplCopyWithImpl<
          _$RESET_PASSWORD_EMAIL_OTP_SENTImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sendingEmailOtp,
    required TResult Function(String? message) emailOtpSent,
    required TResult Function() verifyingEmail,
    required TResult Function() emailVerified,
    required TResult Function() resettingPassword,
    required TResult Function(String? message) passwordResetSuccess,
    required TResult Function(String? errorMessage) error,
  }) {
    return emailOtpSent(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sendingEmailOtp,
    TResult? Function(String? message)? emailOtpSent,
    TResult? Function()? verifyingEmail,
    TResult? Function()? emailVerified,
    TResult? Function()? resettingPassword,
    TResult? Function(String? message)? passwordResetSuccess,
    TResult? Function(String? errorMessage)? error,
  }) {
    return emailOtpSent?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sendingEmailOtp,
    TResult Function(String? message)? emailOtpSent,
    TResult Function()? verifyingEmail,
    TResult Function()? emailVerified,
    TResult Function()? resettingPassword,
    TResult Function(String? message)? passwordResetSuccess,
    TResult Function(String? errorMessage)? error,
    required TResult orElse(),
  }) {
    if (emailOtpSent != null) {
      return emailOtpSent(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RESET_PASSWORD_INITIAL value) initial,
    required TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)
        sendingEmailOtp,
    required TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value) emailOtpSent,
    required TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)
        verifyingEmail,
    required TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)
        emailVerified,
    required TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)
        resettingPassword,
    required TResult Function(RESET_PASSWORD_SUCCESS value)
        passwordResetSuccess,
    required TResult Function(RESET_PASSWORD_ERROR value) error,
  }) {
    return emailOtpSent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult? Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult? Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult? Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult? Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult? Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult? Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult? Function(RESET_PASSWORD_ERROR value)? error,
  }) {
    return emailOtpSent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult Function(RESET_PASSWORD_ERROR value)? error,
    required TResult orElse(),
  }) {
    if (emailOtpSent != null) {
      return emailOtpSent(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RESET_PASSWORD_EMAIL_OTP_SENTImplToJson(
      this,
    );
  }
}

abstract class RESET_PASSWORD_EMAIL_OTP_SENT
    implements ResetPasswordCubitState {
  const factory RESET_PASSWORD_EMAIL_OTP_SENT({final String? message}) =
      _$RESET_PASSWORD_EMAIL_OTP_SENTImpl;

  factory RESET_PASSWORD_EMAIL_OTP_SENT.fromJson(Map<String, dynamic> json) =
      _$RESET_PASSWORD_EMAIL_OTP_SENTImpl.fromJson;

  String? get message;

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RESET_PASSWORD_EMAIL_OTP_SENTImplCopyWith<
          _$RESET_PASSWORD_EMAIL_OTP_SENTImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RESET_PASSWORD_VERIFYING_EMAILImplCopyWith<$Res> {
  factory _$$RESET_PASSWORD_VERIFYING_EMAILImplCopyWith(
          _$RESET_PASSWORD_VERIFYING_EMAILImpl value,
          $Res Function(_$RESET_PASSWORD_VERIFYING_EMAILImpl) then) =
      __$$RESET_PASSWORD_VERIFYING_EMAILImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RESET_PASSWORD_VERIFYING_EMAILImplCopyWithImpl<$Res>
    extends _$ResetPasswordCubitStateCopyWithImpl<$Res,
        _$RESET_PASSWORD_VERIFYING_EMAILImpl>
    implements _$$RESET_PASSWORD_VERIFYING_EMAILImplCopyWith<$Res> {
  __$$RESET_PASSWORD_VERIFYING_EMAILImplCopyWithImpl(
      _$RESET_PASSWORD_VERIFYING_EMAILImpl _value,
      $Res Function(_$RESET_PASSWORD_VERIFYING_EMAILImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$RESET_PASSWORD_VERIFYING_EMAILImpl
    implements RESET_PASSWORD_VERIFYING_EMAIL {
  const _$RESET_PASSWORD_VERIFYING_EMAILImpl({final String? $type})
      : $type = $type ?? 'verifyingEmail';

  factory _$RESET_PASSWORD_VERIFYING_EMAILImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RESET_PASSWORD_VERIFYING_EMAILImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ResetPasswordCubitState.verifyingEmail()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RESET_PASSWORD_VERIFYING_EMAILImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sendingEmailOtp,
    required TResult Function(String? message) emailOtpSent,
    required TResult Function() verifyingEmail,
    required TResult Function() emailVerified,
    required TResult Function() resettingPassword,
    required TResult Function(String? message) passwordResetSuccess,
    required TResult Function(String? errorMessage) error,
  }) {
    return verifyingEmail();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sendingEmailOtp,
    TResult? Function(String? message)? emailOtpSent,
    TResult? Function()? verifyingEmail,
    TResult? Function()? emailVerified,
    TResult? Function()? resettingPassword,
    TResult? Function(String? message)? passwordResetSuccess,
    TResult? Function(String? errorMessage)? error,
  }) {
    return verifyingEmail?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sendingEmailOtp,
    TResult Function(String? message)? emailOtpSent,
    TResult Function()? verifyingEmail,
    TResult Function()? emailVerified,
    TResult Function()? resettingPassword,
    TResult Function(String? message)? passwordResetSuccess,
    TResult Function(String? errorMessage)? error,
    required TResult orElse(),
  }) {
    if (verifyingEmail != null) {
      return verifyingEmail();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RESET_PASSWORD_INITIAL value) initial,
    required TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)
        sendingEmailOtp,
    required TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value) emailOtpSent,
    required TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)
        verifyingEmail,
    required TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)
        emailVerified,
    required TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)
        resettingPassword,
    required TResult Function(RESET_PASSWORD_SUCCESS value)
        passwordResetSuccess,
    required TResult Function(RESET_PASSWORD_ERROR value) error,
  }) {
    return verifyingEmail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult? Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult? Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult? Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult? Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult? Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult? Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult? Function(RESET_PASSWORD_ERROR value)? error,
  }) {
    return verifyingEmail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult Function(RESET_PASSWORD_ERROR value)? error,
    required TResult orElse(),
  }) {
    if (verifyingEmail != null) {
      return verifyingEmail(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RESET_PASSWORD_VERIFYING_EMAILImplToJson(
      this,
    );
  }
}

abstract class RESET_PASSWORD_VERIFYING_EMAIL
    implements ResetPasswordCubitState {
  const factory RESET_PASSWORD_VERIFYING_EMAIL() =
      _$RESET_PASSWORD_VERIFYING_EMAILImpl;

  factory RESET_PASSWORD_VERIFYING_EMAIL.fromJson(Map<String, dynamic> json) =
      _$RESET_PASSWORD_VERIFYING_EMAILImpl.fromJson;
}

/// @nodoc
abstract class _$$RESET_PASSWORD_EMAIL_VERIFIEDImplCopyWith<$Res> {
  factory _$$RESET_PASSWORD_EMAIL_VERIFIEDImplCopyWith(
          _$RESET_PASSWORD_EMAIL_VERIFIEDImpl value,
          $Res Function(_$RESET_PASSWORD_EMAIL_VERIFIEDImpl) then) =
      __$$RESET_PASSWORD_EMAIL_VERIFIEDImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RESET_PASSWORD_EMAIL_VERIFIEDImplCopyWithImpl<$Res>
    extends _$ResetPasswordCubitStateCopyWithImpl<$Res,
        _$RESET_PASSWORD_EMAIL_VERIFIEDImpl>
    implements _$$RESET_PASSWORD_EMAIL_VERIFIEDImplCopyWith<$Res> {
  __$$RESET_PASSWORD_EMAIL_VERIFIEDImplCopyWithImpl(
      _$RESET_PASSWORD_EMAIL_VERIFIEDImpl _value,
      $Res Function(_$RESET_PASSWORD_EMAIL_VERIFIEDImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$RESET_PASSWORD_EMAIL_VERIFIEDImpl
    implements RESET_PASSWORD_EMAIL_VERIFIED {
  const _$RESET_PASSWORD_EMAIL_VERIFIEDImpl({final String? $type})
      : $type = $type ?? 'emailVerified';

  factory _$RESET_PASSWORD_EMAIL_VERIFIEDImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RESET_PASSWORD_EMAIL_VERIFIEDImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ResetPasswordCubitState.emailVerified()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RESET_PASSWORD_EMAIL_VERIFIEDImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sendingEmailOtp,
    required TResult Function(String? message) emailOtpSent,
    required TResult Function() verifyingEmail,
    required TResult Function() emailVerified,
    required TResult Function() resettingPassword,
    required TResult Function(String? message) passwordResetSuccess,
    required TResult Function(String? errorMessage) error,
  }) {
    return emailVerified();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sendingEmailOtp,
    TResult? Function(String? message)? emailOtpSent,
    TResult? Function()? verifyingEmail,
    TResult? Function()? emailVerified,
    TResult? Function()? resettingPassword,
    TResult? Function(String? message)? passwordResetSuccess,
    TResult? Function(String? errorMessage)? error,
  }) {
    return emailVerified?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sendingEmailOtp,
    TResult Function(String? message)? emailOtpSent,
    TResult Function()? verifyingEmail,
    TResult Function()? emailVerified,
    TResult Function()? resettingPassword,
    TResult Function(String? message)? passwordResetSuccess,
    TResult Function(String? errorMessage)? error,
    required TResult orElse(),
  }) {
    if (emailVerified != null) {
      return emailVerified();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RESET_PASSWORD_INITIAL value) initial,
    required TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)
        sendingEmailOtp,
    required TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value) emailOtpSent,
    required TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)
        verifyingEmail,
    required TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)
        emailVerified,
    required TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)
        resettingPassword,
    required TResult Function(RESET_PASSWORD_SUCCESS value)
        passwordResetSuccess,
    required TResult Function(RESET_PASSWORD_ERROR value) error,
  }) {
    return emailVerified(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult? Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult? Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult? Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult? Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult? Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult? Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult? Function(RESET_PASSWORD_ERROR value)? error,
  }) {
    return emailVerified?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult Function(RESET_PASSWORD_ERROR value)? error,
    required TResult orElse(),
  }) {
    if (emailVerified != null) {
      return emailVerified(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RESET_PASSWORD_EMAIL_VERIFIEDImplToJson(
      this,
    );
  }
}

abstract class RESET_PASSWORD_EMAIL_VERIFIED
    implements ResetPasswordCubitState {
  const factory RESET_PASSWORD_EMAIL_VERIFIED() =
      _$RESET_PASSWORD_EMAIL_VERIFIEDImpl;

  factory RESET_PASSWORD_EMAIL_VERIFIED.fromJson(Map<String, dynamic> json) =
      _$RESET_PASSWORD_EMAIL_VERIFIEDImpl.fromJson;
}

/// @nodoc
abstract class _$$RESET_PASSWORD_RESETTING_PASSWORDImplCopyWith<$Res> {
  factory _$$RESET_PASSWORD_RESETTING_PASSWORDImplCopyWith(
          _$RESET_PASSWORD_RESETTING_PASSWORDImpl value,
          $Res Function(_$RESET_PASSWORD_RESETTING_PASSWORDImpl) then) =
      __$$RESET_PASSWORD_RESETTING_PASSWORDImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RESET_PASSWORD_RESETTING_PASSWORDImplCopyWithImpl<$Res>
    extends _$ResetPasswordCubitStateCopyWithImpl<$Res,
        _$RESET_PASSWORD_RESETTING_PASSWORDImpl>
    implements _$$RESET_PASSWORD_RESETTING_PASSWORDImplCopyWith<$Res> {
  __$$RESET_PASSWORD_RESETTING_PASSWORDImplCopyWithImpl(
      _$RESET_PASSWORD_RESETTING_PASSWORDImpl _value,
      $Res Function(_$RESET_PASSWORD_RESETTING_PASSWORDImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$RESET_PASSWORD_RESETTING_PASSWORDImpl
    implements RESET_PASSWORD_RESETTING_PASSWORD {
  const _$RESET_PASSWORD_RESETTING_PASSWORDImpl({final String? $type})
      : $type = $type ?? 'resettingPassword';

  factory _$RESET_PASSWORD_RESETTING_PASSWORDImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RESET_PASSWORD_RESETTING_PASSWORDImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ResetPasswordCubitState.resettingPassword()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RESET_PASSWORD_RESETTING_PASSWORDImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sendingEmailOtp,
    required TResult Function(String? message) emailOtpSent,
    required TResult Function() verifyingEmail,
    required TResult Function() emailVerified,
    required TResult Function() resettingPassword,
    required TResult Function(String? message) passwordResetSuccess,
    required TResult Function(String? errorMessage) error,
  }) {
    return resettingPassword();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sendingEmailOtp,
    TResult? Function(String? message)? emailOtpSent,
    TResult? Function()? verifyingEmail,
    TResult? Function()? emailVerified,
    TResult? Function()? resettingPassword,
    TResult? Function(String? message)? passwordResetSuccess,
    TResult? Function(String? errorMessage)? error,
  }) {
    return resettingPassword?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sendingEmailOtp,
    TResult Function(String? message)? emailOtpSent,
    TResult Function()? verifyingEmail,
    TResult Function()? emailVerified,
    TResult Function()? resettingPassword,
    TResult Function(String? message)? passwordResetSuccess,
    TResult Function(String? errorMessage)? error,
    required TResult orElse(),
  }) {
    if (resettingPassword != null) {
      return resettingPassword();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RESET_PASSWORD_INITIAL value) initial,
    required TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)
        sendingEmailOtp,
    required TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value) emailOtpSent,
    required TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)
        verifyingEmail,
    required TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)
        emailVerified,
    required TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)
        resettingPassword,
    required TResult Function(RESET_PASSWORD_SUCCESS value)
        passwordResetSuccess,
    required TResult Function(RESET_PASSWORD_ERROR value) error,
  }) {
    return resettingPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult? Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult? Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult? Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult? Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult? Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult? Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult? Function(RESET_PASSWORD_ERROR value)? error,
  }) {
    return resettingPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult Function(RESET_PASSWORD_ERROR value)? error,
    required TResult orElse(),
  }) {
    if (resettingPassword != null) {
      return resettingPassword(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RESET_PASSWORD_RESETTING_PASSWORDImplToJson(
      this,
    );
  }
}

abstract class RESET_PASSWORD_RESETTING_PASSWORD
    implements ResetPasswordCubitState {
  const factory RESET_PASSWORD_RESETTING_PASSWORD() =
      _$RESET_PASSWORD_RESETTING_PASSWORDImpl;

  factory RESET_PASSWORD_RESETTING_PASSWORD.fromJson(
          Map<String, dynamic> json) =
      _$RESET_PASSWORD_RESETTING_PASSWORDImpl.fromJson;
}

/// @nodoc
abstract class _$$RESET_PASSWORD_SUCCESSImplCopyWith<$Res> {
  factory _$$RESET_PASSWORD_SUCCESSImplCopyWith(
          _$RESET_PASSWORD_SUCCESSImpl value,
          $Res Function(_$RESET_PASSWORD_SUCCESSImpl) then) =
      __$$RESET_PASSWORD_SUCCESSImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$RESET_PASSWORD_SUCCESSImplCopyWithImpl<$Res>
    extends _$ResetPasswordCubitStateCopyWithImpl<$Res,
        _$RESET_PASSWORD_SUCCESSImpl>
    implements _$$RESET_PASSWORD_SUCCESSImplCopyWith<$Res> {
  __$$RESET_PASSWORD_SUCCESSImplCopyWithImpl(
      _$RESET_PASSWORD_SUCCESSImpl _value,
      $Res Function(_$RESET_PASSWORD_SUCCESSImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$RESET_PASSWORD_SUCCESSImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RESET_PASSWORD_SUCCESSImpl implements RESET_PASSWORD_SUCCESS {
  const _$RESET_PASSWORD_SUCCESSImpl({this.message, final String? $type})
      : $type = $type ?? 'passwordResetSuccess';

  factory _$RESET_PASSWORD_SUCCESSImpl.fromJson(Map<String, dynamic> json) =>
      _$$RESET_PASSWORD_SUCCESSImplFromJson(json);

  @override
  final String? message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ResetPasswordCubitState.passwordResetSuccess(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RESET_PASSWORD_SUCCESSImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RESET_PASSWORD_SUCCESSImplCopyWith<_$RESET_PASSWORD_SUCCESSImpl>
      get copyWith => __$$RESET_PASSWORD_SUCCESSImplCopyWithImpl<
          _$RESET_PASSWORD_SUCCESSImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sendingEmailOtp,
    required TResult Function(String? message) emailOtpSent,
    required TResult Function() verifyingEmail,
    required TResult Function() emailVerified,
    required TResult Function() resettingPassword,
    required TResult Function(String? message) passwordResetSuccess,
    required TResult Function(String? errorMessage) error,
  }) {
    return passwordResetSuccess(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sendingEmailOtp,
    TResult? Function(String? message)? emailOtpSent,
    TResult? Function()? verifyingEmail,
    TResult? Function()? emailVerified,
    TResult? Function()? resettingPassword,
    TResult? Function(String? message)? passwordResetSuccess,
    TResult? Function(String? errorMessage)? error,
  }) {
    return passwordResetSuccess?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sendingEmailOtp,
    TResult Function(String? message)? emailOtpSent,
    TResult Function()? verifyingEmail,
    TResult Function()? emailVerified,
    TResult Function()? resettingPassword,
    TResult Function(String? message)? passwordResetSuccess,
    TResult Function(String? errorMessage)? error,
    required TResult orElse(),
  }) {
    if (passwordResetSuccess != null) {
      return passwordResetSuccess(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RESET_PASSWORD_INITIAL value) initial,
    required TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)
        sendingEmailOtp,
    required TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value) emailOtpSent,
    required TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)
        verifyingEmail,
    required TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)
        emailVerified,
    required TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)
        resettingPassword,
    required TResult Function(RESET_PASSWORD_SUCCESS value)
        passwordResetSuccess,
    required TResult Function(RESET_PASSWORD_ERROR value) error,
  }) {
    return passwordResetSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult? Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult? Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult? Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult? Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult? Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult? Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult? Function(RESET_PASSWORD_ERROR value)? error,
  }) {
    return passwordResetSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult Function(RESET_PASSWORD_ERROR value)? error,
    required TResult orElse(),
  }) {
    if (passwordResetSuccess != null) {
      return passwordResetSuccess(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RESET_PASSWORD_SUCCESSImplToJson(
      this,
    );
  }
}

abstract class RESET_PASSWORD_SUCCESS implements ResetPasswordCubitState {
  const factory RESET_PASSWORD_SUCCESS({final String? message}) =
      _$RESET_PASSWORD_SUCCESSImpl;

  factory RESET_PASSWORD_SUCCESS.fromJson(Map<String, dynamic> json) =
      _$RESET_PASSWORD_SUCCESSImpl.fromJson;

  String? get message;

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RESET_PASSWORD_SUCCESSImplCopyWith<_$RESET_PASSWORD_SUCCESSImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RESET_PASSWORD_ERRORImplCopyWith<$Res> {
  factory _$$RESET_PASSWORD_ERRORImplCopyWith(_$RESET_PASSWORD_ERRORImpl value,
          $Res Function(_$RESET_PASSWORD_ERRORImpl) then) =
      __$$RESET_PASSWORD_ERRORImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? errorMessage});
}

/// @nodoc
class __$$RESET_PASSWORD_ERRORImplCopyWithImpl<$Res>
    extends _$ResetPasswordCubitStateCopyWithImpl<$Res,
        _$RESET_PASSWORD_ERRORImpl>
    implements _$$RESET_PASSWORD_ERRORImplCopyWith<$Res> {
  __$$RESET_PASSWORD_ERRORImplCopyWithImpl(_$RESET_PASSWORD_ERRORImpl _value,
      $Res Function(_$RESET_PASSWORD_ERRORImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorMessage = freezed,
  }) {
    return _then(_$RESET_PASSWORD_ERRORImpl(
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RESET_PASSWORD_ERRORImpl implements RESET_PASSWORD_ERROR {
  const _$RESET_PASSWORD_ERRORImpl({this.errorMessage, final String? $type})
      : $type = $type ?? 'error';

  factory _$RESET_PASSWORD_ERRORImpl.fromJson(Map<String, dynamic> json) =>
      _$$RESET_PASSWORD_ERRORImplFromJson(json);

  @override
  final String? errorMessage;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ResetPasswordCubitState.error(errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RESET_PASSWORD_ERRORImpl &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, errorMessage);

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RESET_PASSWORD_ERRORImplCopyWith<_$RESET_PASSWORD_ERRORImpl>
      get copyWith =>
          __$$RESET_PASSWORD_ERRORImplCopyWithImpl<_$RESET_PASSWORD_ERRORImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sendingEmailOtp,
    required TResult Function(String? message) emailOtpSent,
    required TResult Function() verifyingEmail,
    required TResult Function() emailVerified,
    required TResult Function() resettingPassword,
    required TResult Function(String? message) passwordResetSuccess,
    required TResult Function(String? errorMessage) error,
  }) {
    return error(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sendingEmailOtp,
    TResult? Function(String? message)? emailOtpSent,
    TResult? Function()? verifyingEmail,
    TResult? Function()? emailVerified,
    TResult? Function()? resettingPassword,
    TResult? Function(String? message)? passwordResetSuccess,
    TResult? Function(String? errorMessage)? error,
  }) {
    return error?.call(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sendingEmailOtp,
    TResult Function(String? message)? emailOtpSent,
    TResult Function()? verifyingEmail,
    TResult Function()? emailVerified,
    TResult Function()? resettingPassword,
    TResult Function(String? message)? passwordResetSuccess,
    TResult Function(String? errorMessage)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(errorMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RESET_PASSWORD_INITIAL value) initial,
    required TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)
        sendingEmailOtp,
    required TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value) emailOtpSent,
    required TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)
        verifyingEmail,
    required TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)
        emailVerified,
    required TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)
        resettingPassword,
    required TResult Function(RESET_PASSWORD_SUCCESS value)
        passwordResetSuccess,
    required TResult Function(RESET_PASSWORD_ERROR value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult? Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult? Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult? Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult? Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult? Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult? Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult? Function(RESET_PASSWORD_ERROR value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RESET_PASSWORD_INITIAL value)? initial,
    TResult Function(RESET_PASSWORD_SENDING_EMAIL_OTP value)? sendingEmailOtp,
    TResult Function(RESET_PASSWORD_EMAIL_OTP_SENT value)? emailOtpSent,
    TResult Function(RESET_PASSWORD_VERIFYING_EMAIL value)? verifyingEmail,
    TResult Function(RESET_PASSWORD_EMAIL_VERIFIED value)? emailVerified,
    TResult Function(RESET_PASSWORD_RESETTING_PASSWORD value)?
        resettingPassword,
    TResult Function(RESET_PASSWORD_SUCCESS value)? passwordResetSuccess,
    TResult Function(RESET_PASSWORD_ERROR value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RESET_PASSWORD_ERRORImplToJson(
      this,
    );
  }
}

abstract class RESET_PASSWORD_ERROR implements ResetPasswordCubitState {
  const factory RESET_PASSWORD_ERROR({final String? errorMessage}) =
      _$RESET_PASSWORD_ERRORImpl;

  factory RESET_PASSWORD_ERROR.fromJson(Map<String, dynamic> json) =
      _$RESET_PASSWORD_ERRORImpl.fromJson;

  String? get errorMessage;

  /// Create a copy of ResetPasswordCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RESET_PASSWORD_ERRORImplCopyWith<_$RESET_PASSWORD_ERRORImpl>
      get copyWith => throw _privateConstructorUsedError;
}
