// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_cubit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistrationCubitState _$RegistrationCubitStateFromJson(
    Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'initial':
      return REGISTRATION_INITIAL.fromJson(json);
    case 'loading':
      return REGISTRATION_LOADING.fromJson(json);
    case 'error':
      return REGISTRATION_ERROR.fromJson(json);
    case 'success':
      return REGISTRATION_SUCCESS.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json,
          'runtimeType',
          'RegistrationCubitState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$RegistrationCubitState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function(AccountCreationResponse accountCreationResponse)
        success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function(AccountCreationResponse accountCreationResponse)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function(AccountCreationResponse accountCreationResponse)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(REGISTRATION_INITIAL value) initial,
    required TResult Function(REGISTRATION_LOADING value) loading,
    required TResult Function(REGISTRATION_ERROR value) error,
    required TResult Function(REGISTRATION_SUCCESS value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(REGISTRATION_INITIAL value)? initial,
    TResult? Function(REGISTRATION_LOADING value)? loading,
    TResult? Function(REGISTRATION_ERROR value)? error,
    TResult? Function(REGISTRATION_SUCCESS value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(REGISTRATION_INITIAL value)? initial,
    TResult Function(REGISTRATION_LOADING value)? loading,
    TResult Function(REGISTRATION_ERROR value)? error,
    TResult Function(REGISTRATION_SUCCESS value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this RegistrationCubitState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationCubitStateCopyWith<$Res> {
  factory $RegistrationCubitStateCopyWith(RegistrationCubitState value,
          $Res Function(RegistrationCubitState) then) =
      _$RegistrationCubitStateCopyWithImpl<$Res, RegistrationCubitState>;
}

/// @nodoc
class _$RegistrationCubitStateCopyWithImpl<$Res,
        $Val extends RegistrationCubitState>
    implements $RegistrationCubitStateCopyWith<$Res> {
  _$RegistrationCubitStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegistrationCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$REGISTRATION_INITIALImplCopyWith<$Res> {
  factory _$$REGISTRATION_INITIALImplCopyWith(_$REGISTRATION_INITIALImpl value,
          $Res Function(_$REGISTRATION_INITIALImpl) then) =
      __$$REGISTRATION_INITIALImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$REGISTRATION_INITIALImplCopyWithImpl<$Res>
    extends _$RegistrationCubitStateCopyWithImpl<$Res,
        _$REGISTRATION_INITIALImpl>
    implements _$$REGISTRATION_INITIALImplCopyWith<$Res> {
  __$$REGISTRATION_INITIALImplCopyWithImpl(_$REGISTRATION_INITIALImpl _value,
      $Res Function(_$REGISTRATION_INITIALImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegistrationCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$REGISTRATION_INITIALImpl implements REGISTRATION_INITIAL {
  const _$REGISTRATION_INITIALImpl({final String? $type})
      : $type = $type ?? 'initial';

  factory _$REGISTRATION_INITIALImpl.fromJson(Map<String, dynamic> json) =>
      _$$REGISTRATION_INITIALImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RegistrationCubitState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$REGISTRATION_INITIALImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function(AccountCreationResponse accountCreationResponse)
        success,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function(AccountCreationResponse accountCreationResponse)? success,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function(AccountCreationResponse accountCreationResponse)? success,
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
    required TResult Function(REGISTRATION_INITIAL value) initial,
    required TResult Function(REGISTRATION_LOADING value) loading,
    required TResult Function(REGISTRATION_ERROR value) error,
    required TResult Function(REGISTRATION_SUCCESS value) success,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(REGISTRATION_INITIAL value)? initial,
    TResult? Function(REGISTRATION_LOADING value)? loading,
    TResult? Function(REGISTRATION_ERROR value)? error,
    TResult? Function(REGISTRATION_SUCCESS value)? success,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(REGISTRATION_INITIAL value)? initial,
    TResult Function(REGISTRATION_LOADING value)? loading,
    TResult Function(REGISTRATION_ERROR value)? error,
    TResult Function(REGISTRATION_SUCCESS value)? success,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$REGISTRATION_INITIALImplToJson(
      this,
    );
  }
}

abstract class REGISTRATION_INITIAL implements RegistrationCubitState {
  const factory REGISTRATION_INITIAL() = _$REGISTRATION_INITIALImpl;

  factory REGISTRATION_INITIAL.fromJson(Map<String, dynamic> json) =
      _$REGISTRATION_INITIALImpl.fromJson;
}

/// @nodoc
abstract class _$$REGISTRATION_LOADINGImplCopyWith<$Res> {
  factory _$$REGISTRATION_LOADINGImplCopyWith(_$REGISTRATION_LOADINGImpl value,
          $Res Function(_$REGISTRATION_LOADINGImpl) then) =
      __$$REGISTRATION_LOADINGImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$REGISTRATION_LOADINGImplCopyWithImpl<$Res>
    extends _$RegistrationCubitStateCopyWithImpl<$Res,
        _$REGISTRATION_LOADINGImpl>
    implements _$$REGISTRATION_LOADINGImplCopyWith<$Res> {
  __$$REGISTRATION_LOADINGImplCopyWithImpl(_$REGISTRATION_LOADINGImpl _value,
      $Res Function(_$REGISTRATION_LOADINGImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegistrationCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$REGISTRATION_LOADINGImpl implements REGISTRATION_LOADING {
  const _$REGISTRATION_LOADINGImpl({final String? $type})
      : $type = $type ?? 'loading';

  factory _$REGISTRATION_LOADINGImpl.fromJson(Map<String, dynamic> json) =>
      _$$REGISTRATION_LOADINGImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RegistrationCubitState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$REGISTRATION_LOADINGImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function(AccountCreationResponse accountCreationResponse)
        success,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function(AccountCreationResponse accountCreationResponse)? success,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function(AccountCreationResponse accountCreationResponse)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(REGISTRATION_INITIAL value) initial,
    required TResult Function(REGISTRATION_LOADING value) loading,
    required TResult Function(REGISTRATION_ERROR value) error,
    required TResult Function(REGISTRATION_SUCCESS value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(REGISTRATION_INITIAL value)? initial,
    TResult? Function(REGISTRATION_LOADING value)? loading,
    TResult? Function(REGISTRATION_ERROR value)? error,
    TResult? Function(REGISTRATION_SUCCESS value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(REGISTRATION_INITIAL value)? initial,
    TResult Function(REGISTRATION_LOADING value)? loading,
    TResult Function(REGISTRATION_ERROR value)? error,
    TResult Function(REGISTRATION_SUCCESS value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$REGISTRATION_LOADINGImplToJson(
      this,
    );
  }
}

abstract class REGISTRATION_LOADING implements RegistrationCubitState {
  const factory REGISTRATION_LOADING() = _$REGISTRATION_LOADINGImpl;

  factory REGISTRATION_LOADING.fromJson(Map<String, dynamic> json) =
      _$REGISTRATION_LOADINGImpl.fromJson;
}

/// @nodoc
abstract class _$$REGISTRATION_ERRORImplCopyWith<$Res> {
  factory _$$REGISTRATION_ERRORImplCopyWith(_$REGISTRATION_ERRORImpl value,
          $Res Function(_$REGISTRATION_ERRORImpl) then) =
      __$$REGISTRATION_ERRORImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$REGISTRATION_ERRORImplCopyWithImpl<$Res>
    extends _$RegistrationCubitStateCopyWithImpl<$Res, _$REGISTRATION_ERRORImpl>
    implements _$$REGISTRATION_ERRORImplCopyWith<$Res> {
  __$$REGISTRATION_ERRORImplCopyWithImpl(_$REGISTRATION_ERRORImpl _value,
      $Res Function(_$REGISTRATION_ERRORImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegistrationCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$REGISTRATION_ERRORImpl implements REGISTRATION_ERROR {
  const _$REGISTRATION_ERRORImpl({final String? $type})
      : $type = $type ?? 'error';

  factory _$REGISTRATION_ERRORImpl.fromJson(Map<String, dynamic> json) =>
      _$$REGISTRATION_ERRORImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RegistrationCubitState.error()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$REGISTRATION_ERRORImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function(AccountCreationResponse accountCreationResponse)
        success,
  }) {
    return error();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function(AccountCreationResponse accountCreationResponse)? success,
  }) {
    return error?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function(AccountCreationResponse accountCreationResponse)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(REGISTRATION_INITIAL value) initial,
    required TResult Function(REGISTRATION_LOADING value) loading,
    required TResult Function(REGISTRATION_ERROR value) error,
    required TResult Function(REGISTRATION_SUCCESS value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(REGISTRATION_INITIAL value)? initial,
    TResult? Function(REGISTRATION_LOADING value)? loading,
    TResult? Function(REGISTRATION_ERROR value)? error,
    TResult? Function(REGISTRATION_SUCCESS value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(REGISTRATION_INITIAL value)? initial,
    TResult Function(REGISTRATION_LOADING value)? loading,
    TResult Function(REGISTRATION_ERROR value)? error,
    TResult Function(REGISTRATION_SUCCESS value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$REGISTRATION_ERRORImplToJson(
      this,
    );
  }
}

abstract class REGISTRATION_ERROR implements RegistrationCubitState {
  const factory REGISTRATION_ERROR() = _$REGISTRATION_ERRORImpl;

  factory REGISTRATION_ERROR.fromJson(Map<String, dynamic> json) =
      _$REGISTRATION_ERRORImpl.fromJson;
}

/// @nodoc
abstract class _$$REGISTRATION_SUCCESSImplCopyWith<$Res> {
  factory _$$REGISTRATION_SUCCESSImplCopyWith(_$REGISTRATION_SUCCESSImpl value,
          $Res Function(_$REGISTRATION_SUCCESSImpl) then) =
      __$$REGISTRATION_SUCCESSImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AccountCreationResponse accountCreationResponse});

  $AccountCreationResponseCopyWith<$Res> get accountCreationResponse;
}

/// @nodoc
class __$$REGISTRATION_SUCCESSImplCopyWithImpl<$Res>
    extends _$RegistrationCubitStateCopyWithImpl<$Res,
        _$REGISTRATION_SUCCESSImpl>
    implements _$$REGISTRATION_SUCCESSImplCopyWith<$Res> {
  __$$REGISTRATION_SUCCESSImplCopyWithImpl(_$REGISTRATION_SUCCESSImpl _value,
      $Res Function(_$REGISTRATION_SUCCESSImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegistrationCubitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountCreationResponse = null,
  }) {
    return _then(_$REGISTRATION_SUCCESSImpl(
      accountCreationResponse: null == accountCreationResponse
          ? _value.accountCreationResponse
          : accountCreationResponse // ignore: cast_nullable_to_non_nullable
              as AccountCreationResponse,
    ));
  }

  /// Create a copy of RegistrationCubitState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountCreationResponseCopyWith<$Res> get accountCreationResponse {
    return $AccountCreationResponseCopyWith<$Res>(
        _value.accountCreationResponse, (value) {
      return _then(_value.copyWith(accountCreationResponse: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$REGISTRATION_SUCCESSImpl implements REGISTRATION_SUCCESS {
  const _$REGISTRATION_SUCCESSImpl(
      {required this.accountCreationResponse, final String? $type})
      : $type = $type ?? 'success';

  factory _$REGISTRATION_SUCCESSImpl.fromJson(Map<String, dynamic> json) =>
      _$$REGISTRATION_SUCCESSImplFromJson(json);

  @override
  final AccountCreationResponse accountCreationResponse;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RegistrationCubitState.success(accountCreationResponse: $accountCreationResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$REGISTRATION_SUCCESSImpl &&
            (identical(
                    other.accountCreationResponse, accountCreationResponse) ||
                other.accountCreationResponse == accountCreationResponse));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accountCreationResponse);

  /// Create a copy of RegistrationCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$REGISTRATION_SUCCESSImplCopyWith<_$REGISTRATION_SUCCESSImpl>
      get copyWith =>
          __$$REGISTRATION_SUCCESSImplCopyWithImpl<_$REGISTRATION_SUCCESSImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function(AccountCreationResponse accountCreationResponse)
        success,
  }) {
    return success(accountCreationResponse);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function(AccountCreationResponse accountCreationResponse)? success,
  }) {
    return success?.call(accountCreationResponse);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function(AccountCreationResponse accountCreationResponse)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(accountCreationResponse);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(REGISTRATION_INITIAL value) initial,
    required TResult Function(REGISTRATION_LOADING value) loading,
    required TResult Function(REGISTRATION_ERROR value) error,
    required TResult Function(REGISTRATION_SUCCESS value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(REGISTRATION_INITIAL value)? initial,
    TResult? Function(REGISTRATION_LOADING value)? loading,
    TResult? Function(REGISTRATION_ERROR value)? error,
    TResult? Function(REGISTRATION_SUCCESS value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(REGISTRATION_INITIAL value)? initial,
    TResult Function(REGISTRATION_LOADING value)? loading,
    TResult Function(REGISTRATION_ERROR value)? error,
    TResult Function(REGISTRATION_SUCCESS value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$REGISTRATION_SUCCESSImplToJson(
      this,
    );
  }
}

abstract class REGISTRATION_SUCCESS implements RegistrationCubitState {
  const factory REGISTRATION_SUCCESS(
          {required final AccountCreationResponse accountCreationResponse}) =
      _$REGISTRATION_SUCCESSImpl;

  factory REGISTRATION_SUCCESS.fromJson(Map<String, dynamic> json) =
      _$REGISTRATION_SUCCESSImpl.fromJson;

  AccountCreationResponse get accountCreationResponse;

  /// Create a copy of RegistrationCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$REGISTRATION_SUCCESSImplCopyWith<_$REGISTRATION_SUCCESSImpl>
      get copyWith => throw _privateConstructorUsedError;
}
