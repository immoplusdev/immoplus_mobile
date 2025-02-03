// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_cubit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoginCubitState _$LoginCubitStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'default':
      return _LoginCubitState.fromJson(json);
    case 'initial':
      return LOGIN_INITIAL.fromJson(json);
    case 'loading':
      return LOGIN_LOADING.fromJson(json);
    case 'success':
      return LOGIN_SUCCESS.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'LoginCubitState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$LoginCubitState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function() $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function()? $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function()? $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LoginCubitState value) $default, {
    required TResult Function(LOGIN_INITIAL value) initial,
    required TResult Function(LOGIN_LOADING value) loading,
    required TResult Function(LOGIN_SUCCESS value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LoginCubitState value)? $default, {
    TResult? Function(LOGIN_INITIAL value)? initial,
    TResult? Function(LOGIN_LOADING value)? loading,
    TResult? Function(LOGIN_SUCCESS value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LoginCubitState value)? $default, {
    TResult Function(LOGIN_INITIAL value)? initial,
    TResult Function(LOGIN_LOADING value)? loading,
    TResult Function(LOGIN_SUCCESS value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this LoginCubitState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginCubitStateCopyWith<$Res> {
  factory $LoginCubitStateCopyWith(
          LoginCubitState value, $Res Function(LoginCubitState) then) =
      _$LoginCubitStateCopyWithImpl<$Res, LoginCubitState>;
}

/// @nodoc
class _$LoginCubitStateCopyWithImpl<$Res, $Val extends LoginCubitState>
    implements $LoginCubitStateCopyWith<$Res> {
  _$LoginCubitStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoginCubitStateImplCopyWith<$Res> {
  factory _$$LoginCubitStateImplCopyWith(_$LoginCubitStateImpl value,
          $Res Function(_$LoginCubitStateImpl) then) =
      __$$LoginCubitStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoginCubitStateImplCopyWithImpl<$Res>
    extends _$LoginCubitStateCopyWithImpl<$Res, _$LoginCubitStateImpl>
    implements _$$LoginCubitStateImplCopyWith<$Res> {
  __$$LoginCubitStateImplCopyWithImpl(
      _$LoginCubitStateImpl _value, $Res Function(_$LoginCubitStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$LoginCubitStateImpl implements _LoginCubitState {
  _$LoginCubitStateImpl({final String? $type}) : $type = $type ?? 'default';

  factory _$LoginCubitStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginCubitStateImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'LoginCubitState()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoginCubitStateImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function() $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
  }) {
    return $default();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function()? $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
  }) {
    return $default?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function()? $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LoginCubitState value) $default, {
    required TResult Function(LOGIN_INITIAL value) initial,
    required TResult Function(LOGIN_LOADING value) loading,
    required TResult Function(LOGIN_SUCCESS value) success,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LoginCubitState value)? $default, {
    TResult? Function(LOGIN_INITIAL value)? initial,
    TResult? Function(LOGIN_LOADING value)? loading,
    TResult? Function(LOGIN_SUCCESS value)? success,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LoginCubitState value)? $default, {
    TResult Function(LOGIN_INITIAL value)? initial,
    TResult Function(LOGIN_LOADING value)? loading,
    TResult Function(LOGIN_SUCCESS value)? success,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginCubitStateImplToJson(
      this,
    );
  }
}

abstract class _LoginCubitState implements LoginCubitState {
  factory _LoginCubitState() = _$LoginCubitStateImpl;

  factory _LoginCubitState.fromJson(Map<String, dynamic> json) =
      _$LoginCubitStateImpl.fromJson;
}

/// @nodoc
abstract class _$$LOGIN_INITIALImplCopyWith<$Res> {
  factory _$$LOGIN_INITIALImplCopyWith(
          _$LOGIN_INITIALImpl value, $Res Function(_$LOGIN_INITIALImpl) then) =
      __$$LOGIN_INITIALImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LOGIN_INITIALImplCopyWithImpl<$Res>
    extends _$LoginCubitStateCopyWithImpl<$Res, _$LOGIN_INITIALImpl>
    implements _$$LOGIN_INITIALImplCopyWith<$Res> {
  __$$LOGIN_INITIALImplCopyWithImpl(
      _$LOGIN_INITIALImpl _value, $Res Function(_$LOGIN_INITIALImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$LOGIN_INITIALImpl implements LOGIN_INITIAL {
  const _$LOGIN_INITIALImpl({final String? $type}) : $type = $type ?? 'initial';

  factory _$LOGIN_INITIALImpl.fromJson(Map<String, dynamic> json) =>
      _$$LOGIN_INITIALImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'LoginCubitState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LOGIN_INITIALImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function() $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function()? $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function()? $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LoginCubitState value) $default, {
    required TResult Function(LOGIN_INITIAL value) initial,
    required TResult Function(LOGIN_LOADING value) loading,
    required TResult Function(LOGIN_SUCCESS value) success,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LoginCubitState value)? $default, {
    TResult? Function(LOGIN_INITIAL value)? initial,
    TResult? Function(LOGIN_LOADING value)? loading,
    TResult? Function(LOGIN_SUCCESS value)? success,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LoginCubitState value)? $default, {
    TResult Function(LOGIN_INITIAL value)? initial,
    TResult Function(LOGIN_LOADING value)? loading,
    TResult Function(LOGIN_SUCCESS value)? success,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LOGIN_INITIALImplToJson(
      this,
    );
  }
}

abstract class LOGIN_INITIAL implements LoginCubitState {
  const factory LOGIN_INITIAL() = _$LOGIN_INITIALImpl;

  factory LOGIN_INITIAL.fromJson(Map<String, dynamic> json) =
      _$LOGIN_INITIALImpl.fromJson;
}

/// @nodoc
abstract class _$$LOGIN_LOADINGImplCopyWith<$Res> {
  factory _$$LOGIN_LOADINGImplCopyWith(
          _$LOGIN_LOADINGImpl value, $Res Function(_$LOGIN_LOADINGImpl) then) =
      __$$LOGIN_LOADINGImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LOGIN_LOADINGImplCopyWithImpl<$Res>
    extends _$LoginCubitStateCopyWithImpl<$Res, _$LOGIN_LOADINGImpl>
    implements _$$LOGIN_LOADINGImplCopyWith<$Res> {
  __$$LOGIN_LOADINGImplCopyWithImpl(
      _$LOGIN_LOADINGImpl _value, $Res Function(_$LOGIN_LOADINGImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$LOGIN_LOADINGImpl implements LOGIN_LOADING {
  const _$LOGIN_LOADINGImpl({final String? $type}) : $type = $type ?? 'loading';

  factory _$LOGIN_LOADINGImpl.fromJson(Map<String, dynamic> json) =>
      _$$LOGIN_LOADINGImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'LoginCubitState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LOGIN_LOADINGImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function() $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function()? $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function()? $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LoginCubitState value) $default, {
    required TResult Function(LOGIN_INITIAL value) initial,
    required TResult Function(LOGIN_LOADING value) loading,
    required TResult Function(LOGIN_SUCCESS value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LoginCubitState value)? $default, {
    TResult? Function(LOGIN_INITIAL value)? initial,
    TResult? Function(LOGIN_LOADING value)? loading,
    TResult? Function(LOGIN_SUCCESS value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LoginCubitState value)? $default, {
    TResult Function(LOGIN_INITIAL value)? initial,
    TResult Function(LOGIN_LOADING value)? loading,
    TResult Function(LOGIN_SUCCESS value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LOGIN_LOADINGImplToJson(
      this,
    );
  }
}

abstract class LOGIN_LOADING implements LoginCubitState {
  const factory LOGIN_LOADING() = _$LOGIN_LOADINGImpl;

  factory LOGIN_LOADING.fromJson(Map<String, dynamic> json) =
      _$LOGIN_LOADINGImpl.fromJson;
}

/// @nodoc
abstract class _$$LOGIN_SUCCESSImplCopyWith<$Res> {
  factory _$$LOGIN_SUCCESSImplCopyWith(
          _$LOGIN_SUCCESSImpl value, $Res Function(_$LOGIN_SUCCESSImpl) then) =
      __$$LOGIN_SUCCESSImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LOGIN_SUCCESSImplCopyWithImpl<$Res>
    extends _$LoginCubitStateCopyWithImpl<$Res, _$LOGIN_SUCCESSImpl>
    implements _$$LOGIN_SUCCESSImplCopyWith<$Res> {
  __$$LOGIN_SUCCESSImplCopyWithImpl(
      _$LOGIN_SUCCESSImpl _value, $Res Function(_$LOGIN_SUCCESSImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$LOGIN_SUCCESSImpl implements LOGIN_SUCCESS {
  const _$LOGIN_SUCCESSImpl({final String? $type}) : $type = $type ?? 'success';

  factory _$LOGIN_SUCCESSImpl.fromJson(Map<String, dynamic> json) =>
      _$$LOGIN_SUCCESSImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'LoginCubitState.success()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LOGIN_SUCCESSImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function() $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
  }) {
    return success();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function()? $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
  }) {
    return success?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function()? $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LoginCubitState value) $default, {
    required TResult Function(LOGIN_INITIAL value) initial,
    required TResult Function(LOGIN_LOADING value) loading,
    required TResult Function(LOGIN_SUCCESS value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LoginCubitState value)? $default, {
    TResult? Function(LOGIN_INITIAL value)? initial,
    TResult? Function(LOGIN_LOADING value)? loading,
    TResult? Function(LOGIN_SUCCESS value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LoginCubitState value)? $default, {
    TResult Function(LOGIN_INITIAL value)? initial,
    TResult Function(LOGIN_LOADING value)? loading,
    TResult Function(LOGIN_SUCCESS value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LOGIN_SUCCESSImplToJson(
      this,
    );
  }
}

abstract class LOGIN_SUCCESS implements LoginCubitState {
  const factory LOGIN_SUCCESS() = _$LOGIN_SUCCESSImpl;

  factory LOGIN_SUCCESS.fromJson(Map<String, dynamic> json) =
      _$LOGIN_SUCCESSImpl.fromJson;
}
