// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestState _$RequestStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'default':
      return _RequestState.fromJson(json);
    case 'initial':
      return REQUEST_INITIAL.fromJson(json);
    case 'loading':
      return REQUEST_LOADING.fromJson(json);
    case 'success':
      return REQUEST_SUCCESS.fromJson(json);
    case 'error':
      return REQUEST_ERROR.fromJson(json);
    case 'residence':
      return REQUEST_RESIDENCE_DATA.fromJson(json);
    case 'bienImmobilier':
      return REQUEST_BIEN_IMMOBILIER_DATA.fromJson(json);
    case 'residences':
      return REQUEST_RESIDENCES_DATA.fromJson(json);
    case 'villes':
      return REQUEST_VILLES_DATA.fromJson(json);
    case 'communes':
      return REQUEST_COMMUNES_DATA.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'RequestState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$RequestState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function() $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function(String error) error,
    required TResult Function(ResidenceModel data) residence,
    required TResult Function(BienImmobilierModel data) bienImmobilier,
    required TResult Function(List<ResidenceModel> data) residences,
    required TResult Function(List<VilleModel> data) villes,
    required TResult Function(List<CommuneModel> data) communes,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function()? $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function(String error)? error,
    TResult? Function(ResidenceModel data)? residence,
    TResult? Function(BienImmobilierModel data)? bienImmobilier,
    TResult? Function(List<ResidenceModel> data)? residences,
    TResult? Function(List<VilleModel> data)? villes,
    TResult? Function(List<CommuneModel> data)? communes,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function()? $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function(String error)? error,
    TResult Function(ResidenceModel data)? residence,
    TResult Function(BienImmobilierModel data)? bienImmobilier,
    TResult Function(List<ResidenceModel> data)? residences,
    TResult Function(List<VilleModel> data)? villes,
    TResult Function(List<CommuneModel> data)? communes,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RequestState value) $default, {
    required TResult Function(REQUEST_INITIAL value) initial,
    required TResult Function(REQUEST_LOADING value) loading,
    required TResult Function(REQUEST_SUCCESS value) success,
    required TResult Function(REQUEST_ERROR value) error,
    required TResult Function(REQUEST_RESIDENCE_DATA value) residence,
    required TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)
        bienImmobilier,
    required TResult Function(REQUEST_RESIDENCES_DATA value) residences,
    required TResult Function(REQUEST_VILLES_DATA value) villes,
    required TResult Function(REQUEST_COMMUNES_DATA value) communes,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RequestState value)? $default, {
    TResult? Function(REQUEST_INITIAL value)? initial,
    TResult? Function(REQUEST_LOADING value)? loading,
    TResult? Function(REQUEST_SUCCESS value)? success,
    TResult? Function(REQUEST_ERROR value)? error,
    TResult? Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult? Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult? Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult? Function(REQUEST_VILLES_DATA value)? villes,
    TResult? Function(REQUEST_COMMUNES_DATA value)? communes,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RequestState value)? $default, {
    TResult Function(REQUEST_INITIAL value)? initial,
    TResult Function(REQUEST_LOADING value)? loading,
    TResult Function(REQUEST_SUCCESS value)? success,
    TResult Function(REQUEST_ERROR value)? error,
    TResult Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult Function(REQUEST_VILLES_DATA value)? villes,
    TResult Function(REQUEST_COMMUNES_DATA value)? communes,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this RequestState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestStateCopyWith<$Res> {
  factory $RequestStateCopyWith(
          RequestState value, $Res Function(RequestState) then) =
      _$RequestStateCopyWithImpl<$Res, RequestState>;
}

/// @nodoc
class _$RequestStateCopyWithImpl<$Res, $Val extends RequestState>
    implements $RequestStateCopyWith<$Res> {
  _$RequestStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$RequestStateImplCopyWith<$Res> {
  factory _$$RequestStateImplCopyWith(
          _$RequestStateImpl value, $Res Function(_$RequestStateImpl) then) =
      __$$RequestStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RequestStateImplCopyWithImpl<$Res>
    extends _$RequestStateCopyWithImpl<$Res, _$RequestStateImpl>
    implements _$$RequestStateImplCopyWith<$Res> {
  __$$RequestStateImplCopyWithImpl(
      _$RequestStateImpl _value, $Res Function(_$RequestStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$RequestStateImpl implements _RequestState {
  _$RequestStateImpl({final String? $type}) : $type = $type ?? 'default';

  factory _$RequestStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestStateImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RequestState()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RequestStateImpl);
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
    required TResult Function(String error) error,
    required TResult Function(ResidenceModel data) residence,
    required TResult Function(BienImmobilierModel data) bienImmobilier,
    required TResult Function(List<ResidenceModel> data) residences,
    required TResult Function(List<VilleModel> data) villes,
    required TResult Function(List<CommuneModel> data) communes,
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
    TResult? Function(String error)? error,
    TResult? Function(ResidenceModel data)? residence,
    TResult? Function(BienImmobilierModel data)? bienImmobilier,
    TResult? Function(List<ResidenceModel> data)? residences,
    TResult? Function(List<VilleModel> data)? villes,
    TResult? Function(List<CommuneModel> data)? communes,
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
    TResult Function(String error)? error,
    TResult Function(ResidenceModel data)? residence,
    TResult Function(BienImmobilierModel data)? bienImmobilier,
    TResult Function(List<ResidenceModel> data)? residences,
    TResult Function(List<VilleModel> data)? villes,
    TResult Function(List<CommuneModel> data)? communes,
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
    TResult Function(_RequestState value) $default, {
    required TResult Function(REQUEST_INITIAL value) initial,
    required TResult Function(REQUEST_LOADING value) loading,
    required TResult Function(REQUEST_SUCCESS value) success,
    required TResult Function(REQUEST_ERROR value) error,
    required TResult Function(REQUEST_RESIDENCE_DATA value) residence,
    required TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)
        bienImmobilier,
    required TResult Function(REQUEST_RESIDENCES_DATA value) residences,
    required TResult Function(REQUEST_VILLES_DATA value) villes,
    required TResult Function(REQUEST_COMMUNES_DATA value) communes,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RequestState value)? $default, {
    TResult? Function(REQUEST_INITIAL value)? initial,
    TResult? Function(REQUEST_LOADING value)? loading,
    TResult? Function(REQUEST_SUCCESS value)? success,
    TResult? Function(REQUEST_ERROR value)? error,
    TResult? Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult? Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult? Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult? Function(REQUEST_VILLES_DATA value)? villes,
    TResult? Function(REQUEST_COMMUNES_DATA value)? communes,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RequestState value)? $default, {
    TResult Function(REQUEST_INITIAL value)? initial,
    TResult Function(REQUEST_LOADING value)? loading,
    TResult Function(REQUEST_SUCCESS value)? success,
    TResult Function(REQUEST_ERROR value)? error,
    TResult Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult Function(REQUEST_VILLES_DATA value)? villes,
    TResult Function(REQUEST_COMMUNES_DATA value)? communes,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestStateImplToJson(
      this,
    );
  }
}

abstract class _RequestState implements RequestState {
  factory _RequestState() = _$RequestStateImpl;

  factory _RequestState.fromJson(Map<String, dynamic> json) =
      _$RequestStateImpl.fromJson;
}

/// @nodoc
abstract class _$$REQUEST_INITIALImplCopyWith<$Res> {
  factory _$$REQUEST_INITIALImplCopyWith(_$REQUEST_INITIALImpl value,
          $Res Function(_$REQUEST_INITIALImpl) then) =
      __$$REQUEST_INITIALImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$REQUEST_INITIALImplCopyWithImpl<$Res>
    extends _$RequestStateCopyWithImpl<$Res, _$REQUEST_INITIALImpl>
    implements _$$REQUEST_INITIALImplCopyWith<$Res> {
  __$$REQUEST_INITIALImplCopyWithImpl(
      _$REQUEST_INITIALImpl _value, $Res Function(_$REQUEST_INITIALImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$REQUEST_INITIALImpl implements REQUEST_INITIAL {
  const _$REQUEST_INITIALImpl({final String? $type})
      : $type = $type ?? 'initial';

  factory _$REQUEST_INITIALImpl.fromJson(Map<String, dynamic> json) =>
      _$$REQUEST_INITIALImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RequestState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$REQUEST_INITIALImpl);
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
    required TResult Function(String error) error,
    required TResult Function(ResidenceModel data) residence,
    required TResult Function(BienImmobilierModel data) bienImmobilier,
    required TResult Function(List<ResidenceModel> data) residences,
    required TResult Function(List<VilleModel> data) villes,
    required TResult Function(List<CommuneModel> data) communes,
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
    TResult? Function(String error)? error,
    TResult? Function(ResidenceModel data)? residence,
    TResult? Function(BienImmobilierModel data)? bienImmobilier,
    TResult? Function(List<ResidenceModel> data)? residences,
    TResult? Function(List<VilleModel> data)? villes,
    TResult? Function(List<CommuneModel> data)? communes,
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
    TResult Function(String error)? error,
    TResult Function(ResidenceModel data)? residence,
    TResult Function(BienImmobilierModel data)? bienImmobilier,
    TResult Function(List<ResidenceModel> data)? residences,
    TResult Function(List<VilleModel> data)? villes,
    TResult Function(List<CommuneModel> data)? communes,
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
    TResult Function(_RequestState value) $default, {
    required TResult Function(REQUEST_INITIAL value) initial,
    required TResult Function(REQUEST_LOADING value) loading,
    required TResult Function(REQUEST_SUCCESS value) success,
    required TResult Function(REQUEST_ERROR value) error,
    required TResult Function(REQUEST_RESIDENCE_DATA value) residence,
    required TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)
        bienImmobilier,
    required TResult Function(REQUEST_RESIDENCES_DATA value) residences,
    required TResult Function(REQUEST_VILLES_DATA value) villes,
    required TResult Function(REQUEST_COMMUNES_DATA value) communes,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RequestState value)? $default, {
    TResult? Function(REQUEST_INITIAL value)? initial,
    TResult? Function(REQUEST_LOADING value)? loading,
    TResult? Function(REQUEST_SUCCESS value)? success,
    TResult? Function(REQUEST_ERROR value)? error,
    TResult? Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult? Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult? Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult? Function(REQUEST_VILLES_DATA value)? villes,
    TResult? Function(REQUEST_COMMUNES_DATA value)? communes,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RequestState value)? $default, {
    TResult Function(REQUEST_INITIAL value)? initial,
    TResult Function(REQUEST_LOADING value)? loading,
    TResult Function(REQUEST_SUCCESS value)? success,
    TResult Function(REQUEST_ERROR value)? error,
    TResult Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult Function(REQUEST_VILLES_DATA value)? villes,
    TResult Function(REQUEST_COMMUNES_DATA value)? communes,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$REQUEST_INITIALImplToJson(
      this,
    );
  }
}

abstract class REQUEST_INITIAL implements RequestState {
  const factory REQUEST_INITIAL() = _$REQUEST_INITIALImpl;

  factory REQUEST_INITIAL.fromJson(Map<String, dynamic> json) =
      _$REQUEST_INITIALImpl.fromJson;
}

/// @nodoc
abstract class _$$REQUEST_LOADINGImplCopyWith<$Res> {
  factory _$$REQUEST_LOADINGImplCopyWith(_$REQUEST_LOADINGImpl value,
          $Res Function(_$REQUEST_LOADINGImpl) then) =
      __$$REQUEST_LOADINGImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$REQUEST_LOADINGImplCopyWithImpl<$Res>
    extends _$RequestStateCopyWithImpl<$Res, _$REQUEST_LOADINGImpl>
    implements _$$REQUEST_LOADINGImplCopyWith<$Res> {
  __$$REQUEST_LOADINGImplCopyWithImpl(
      _$REQUEST_LOADINGImpl _value, $Res Function(_$REQUEST_LOADINGImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$REQUEST_LOADINGImpl implements REQUEST_LOADING {
  const _$REQUEST_LOADINGImpl({final String? $type})
      : $type = $type ?? 'loading';

  factory _$REQUEST_LOADINGImpl.fromJson(Map<String, dynamic> json) =>
      _$$REQUEST_LOADINGImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RequestState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$REQUEST_LOADINGImpl);
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
    required TResult Function(String error) error,
    required TResult Function(ResidenceModel data) residence,
    required TResult Function(BienImmobilierModel data) bienImmobilier,
    required TResult Function(List<ResidenceModel> data) residences,
    required TResult Function(List<VilleModel> data) villes,
    required TResult Function(List<CommuneModel> data) communes,
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
    TResult? Function(String error)? error,
    TResult? Function(ResidenceModel data)? residence,
    TResult? Function(BienImmobilierModel data)? bienImmobilier,
    TResult? Function(List<ResidenceModel> data)? residences,
    TResult? Function(List<VilleModel> data)? villes,
    TResult? Function(List<CommuneModel> data)? communes,
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
    TResult Function(String error)? error,
    TResult Function(ResidenceModel data)? residence,
    TResult Function(BienImmobilierModel data)? bienImmobilier,
    TResult Function(List<ResidenceModel> data)? residences,
    TResult Function(List<VilleModel> data)? villes,
    TResult Function(List<CommuneModel> data)? communes,
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
    TResult Function(_RequestState value) $default, {
    required TResult Function(REQUEST_INITIAL value) initial,
    required TResult Function(REQUEST_LOADING value) loading,
    required TResult Function(REQUEST_SUCCESS value) success,
    required TResult Function(REQUEST_ERROR value) error,
    required TResult Function(REQUEST_RESIDENCE_DATA value) residence,
    required TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)
        bienImmobilier,
    required TResult Function(REQUEST_RESIDENCES_DATA value) residences,
    required TResult Function(REQUEST_VILLES_DATA value) villes,
    required TResult Function(REQUEST_COMMUNES_DATA value) communes,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RequestState value)? $default, {
    TResult? Function(REQUEST_INITIAL value)? initial,
    TResult? Function(REQUEST_LOADING value)? loading,
    TResult? Function(REQUEST_SUCCESS value)? success,
    TResult? Function(REQUEST_ERROR value)? error,
    TResult? Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult? Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult? Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult? Function(REQUEST_VILLES_DATA value)? villes,
    TResult? Function(REQUEST_COMMUNES_DATA value)? communes,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RequestState value)? $default, {
    TResult Function(REQUEST_INITIAL value)? initial,
    TResult Function(REQUEST_LOADING value)? loading,
    TResult Function(REQUEST_SUCCESS value)? success,
    TResult Function(REQUEST_ERROR value)? error,
    TResult Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult Function(REQUEST_VILLES_DATA value)? villes,
    TResult Function(REQUEST_COMMUNES_DATA value)? communes,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$REQUEST_LOADINGImplToJson(
      this,
    );
  }
}

abstract class REQUEST_LOADING implements RequestState {
  const factory REQUEST_LOADING() = _$REQUEST_LOADINGImpl;

  factory REQUEST_LOADING.fromJson(Map<String, dynamic> json) =
      _$REQUEST_LOADINGImpl.fromJson;
}

/// @nodoc
abstract class _$$REQUEST_SUCCESSImplCopyWith<$Res> {
  factory _$$REQUEST_SUCCESSImplCopyWith(_$REQUEST_SUCCESSImpl value,
          $Res Function(_$REQUEST_SUCCESSImpl) then) =
      __$$REQUEST_SUCCESSImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$REQUEST_SUCCESSImplCopyWithImpl<$Res>
    extends _$RequestStateCopyWithImpl<$Res, _$REQUEST_SUCCESSImpl>
    implements _$$REQUEST_SUCCESSImplCopyWith<$Res> {
  __$$REQUEST_SUCCESSImplCopyWithImpl(
      _$REQUEST_SUCCESSImpl _value, $Res Function(_$REQUEST_SUCCESSImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$REQUEST_SUCCESSImpl implements REQUEST_SUCCESS {
  const _$REQUEST_SUCCESSImpl({final String? $type})
      : $type = $type ?? 'success';

  factory _$REQUEST_SUCCESSImpl.fromJson(Map<String, dynamic> json) =>
      _$$REQUEST_SUCCESSImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RequestState.success()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$REQUEST_SUCCESSImpl);
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
    required TResult Function(String error) error,
    required TResult Function(ResidenceModel data) residence,
    required TResult Function(BienImmobilierModel data) bienImmobilier,
    required TResult Function(List<ResidenceModel> data) residences,
    required TResult Function(List<VilleModel> data) villes,
    required TResult Function(List<CommuneModel> data) communes,
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
    TResult? Function(String error)? error,
    TResult? Function(ResidenceModel data)? residence,
    TResult? Function(BienImmobilierModel data)? bienImmobilier,
    TResult? Function(List<ResidenceModel> data)? residences,
    TResult? Function(List<VilleModel> data)? villes,
    TResult? Function(List<CommuneModel> data)? communes,
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
    TResult Function(String error)? error,
    TResult Function(ResidenceModel data)? residence,
    TResult Function(BienImmobilierModel data)? bienImmobilier,
    TResult Function(List<ResidenceModel> data)? residences,
    TResult Function(List<VilleModel> data)? villes,
    TResult Function(List<CommuneModel> data)? communes,
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
    TResult Function(_RequestState value) $default, {
    required TResult Function(REQUEST_INITIAL value) initial,
    required TResult Function(REQUEST_LOADING value) loading,
    required TResult Function(REQUEST_SUCCESS value) success,
    required TResult Function(REQUEST_ERROR value) error,
    required TResult Function(REQUEST_RESIDENCE_DATA value) residence,
    required TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)
        bienImmobilier,
    required TResult Function(REQUEST_RESIDENCES_DATA value) residences,
    required TResult Function(REQUEST_VILLES_DATA value) villes,
    required TResult Function(REQUEST_COMMUNES_DATA value) communes,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RequestState value)? $default, {
    TResult? Function(REQUEST_INITIAL value)? initial,
    TResult? Function(REQUEST_LOADING value)? loading,
    TResult? Function(REQUEST_SUCCESS value)? success,
    TResult? Function(REQUEST_ERROR value)? error,
    TResult? Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult? Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult? Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult? Function(REQUEST_VILLES_DATA value)? villes,
    TResult? Function(REQUEST_COMMUNES_DATA value)? communes,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RequestState value)? $default, {
    TResult Function(REQUEST_INITIAL value)? initial,
    TResult Function(REQUEST_LOADING value)? loading,
    TResult Function(REQUEST_SUCCESS value)? success,
    TResult Function(REQUEST_ERROR value)? error,
    TResult Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult Function(REQUEST_VILLES_DATA value)? villes,
    TResult Function(REQUEST_COMMUNES_DATA value)? communes,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$REQUEST_SUCCESSImplToJson(
      this,
    );
  }
}

abstract class REQUEST_SUCCESS implements RequestState {
  const factory REQUEST_SUCCESS() = _$REQUEST_SUCCESSImpl;

  factory REQUEST_SUCCESS.fromJson(Map<String, dynamic> json) =
      _$REQUEST_SUCCESSImpl.fromJson;
}

/// @nodoc
abstract class _$$REQUEST_ERRORImplCopyWith<$Res> {
  factory _$$REQUEST_ERRORImplCopyWith(
          _$REQUEST_ERRORImpl value, $Res Function(_$REQUEST_ERRORImpl) then) =
      __$$REQUEST_ERRORImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$REQUEST_ERRORImplCopyWithImpl<$Res>
    extends _$RequestStateCopyWithImpl<$Res, _$REQUEST_ERRORImpl>
    implements _$$REQUEST_ERRORImplCopyWith<$Res> {
  __$$REQUEST_ERRORImplCopyWithImpl(
      _$REQUEST_ERRORImpl _value, $Res Function(_$REQUEST_ERRORImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$REQUEST_ERRORImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$REQUEST_ERRORImpl implements REQUEST_ERROR {
  const _$REQUEST_ERRORImpl({required this.error, final String? $type})
      : $type = $type ?? 'error';

  factory _$REQUEST_ERRORImpl.fromJson(Map<String, dynamic> json) =>
      _$$REQUEST_ERRORImplFromJson(json);

  @override
  final String error;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RequestState.error(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$REQUEST_ERRORImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$REQUEST_ERRORImplCopyWith<_$REQUEST_ERRORImpl> get copyWith =>
      __$$REQUEST_ERRORImplCopyWithImpl<_$REQUEST_ERRORImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function() $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function(String error) error,
    required TResult Function(ResidenceModel data) residence,
    required TResult Function(BienImmobilierModel data) bienImmobilier,
    required TResult Function(List<ResidenceModel> data) residences,
    required TResult Function(List<VilleModel> data) villes,
    required TResult Function(List<CommuneModel> data) communes,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function()? $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function(String error)? error,
    TResult? Function(ResidenceModel data)? residence,
    TResult? Function(BienImmobilierModel data)? bienImmobilier,
    TResult? Function(List<ResidenceModel> data)? residences,
    TResult? Function(List<VilleModel> data)? villes,
    TResult? Function(List<CommuneModel> data)? communes,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function()? $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function(String error)? error,
    TResult Function(ResidenceModel data)? residence,
    TResult Function(BienImmobilierModel data)? bienImmobilier,
    TResult Function(List<ResidenceModel> data)? residences,
    TResult Function(List<VilleModel> data)? villes,
    TResult Function(List<CommuneModel> data)? communes,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RequestState value) $default, {
    required TResult Function(REQUEST_INITIAL value) initial,
    required TResult Function(REQUEST_LOADING value) loading,
    required TResult Function(REQUEST_SUCCESS value) success,
    required TResult Function(REQUEST_ERROR value) error,
    required TResult Function(REQUEST_RESIDENCE_DATA value) residence,
    required TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)
        bienImmobilier,
    required TResult Function(REQUEST_RESIDENCES_DATA value) residences,
    required TResult Function(REQUEST_VILLES_DATA value) villes,
    required TResult Function(REQUEST_COMMUNES_DATA value) communes,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RequestState value)? $default, {
    TResult? Function(REQUEST_INITIAL value)? initial,
    TResult? Function(REQUEST_LOADING value)? loading,
    TResult? Function(REQUEST_SUCCESS value)? success,
    TResult? Function(REQUEST_ERROR value)? error,
    TResult? Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult? Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult? Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult? Function(REQUEST_VILLES_DATA value)? villes,
    TResult? Function(REQUEST_COMMUNES_DATA value)? communes,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RequestState value)? $default, {
    TResult Function(REQUEST_INITIAL value)? initial,
    TResult Function(REQUEST_LOADING value)? loading,
    TResult Function(REQUEST_SUCCESS value)? success,
    TResult Function(REQUEST_ERROR value)? error,
    TResult Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult Function(REQUEST_VILLES_DATA value)? villes,
    TResult Function(REQUEST_COMMUNES_DATA value)? communes,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$REQUEST_ERRORImplToJson(
      this,
    );
  }
}

abstract class REQUEST_ERROR implements RequestState {
  const factory REQUEST_ERROR({required final String error}) =
      _$REQUEST_ERRORImpl;

  factory REQUEST_ERROR.fromJson(Map<String, dynamic> json) =
      _$REQUEST_ERRORImpl.fromJson;

  String get error;

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$REQUEST_ERRORImplCopyWith<_$REQUEST_ERRORImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$REQUEST_RESIDENCE_DATAImplCopyWith<$Res> {
  factory _$$REQUEST_RESIDENCE_DATAImplCopyWith(
          _$REQUEST_RESIDENCE_DATAImpl value,
          $Res Function(_$REQUEST_RESIDENCE_DATAImpl) then) =
      __$$REQUEST_RESIDENCE_DATAImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ResidenceModel data});

  $ResidenceModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$REQUEST_RESIDENCE_DATAImplCopyWithImpl<$Res>
    extends _$RequestStateCopyWithImpl<$Res, _$REQUEST_RESIDENCE_DATAImpl>
    implements _$$REQUEST_RESIDENCE_DATAImplCopyWith<$Res> {
  __$$REQUEST_RESIDENCE_DATAImplCopyWithImpl(
      _$REQUEST_RESIDENCE_DATAImpl _value,
      $Res Function(_$REQUEST_RESIDENCE_DATAImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$REQUEST_RESIDENCE_DATAImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ResidenceModel,
    ));
  }

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResidenceModelCopyWith<$Res> get data {
    return $ResidenceModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$REQUEST_RESIDENCE_DATAImpl implements REQUEST_RESIDENCE_DATA {
  const _$REQUEST_RESIDENCE_DATAImpl({required this.data, final String? $type})
      : $type = $type ?? 'residence';

  factory _$REQUEST_RESIDENCE_DATAImpl.fromJson(Map<String, dynamic> json) =>
      _$$REQUEST_RESIDENCE_DATAImplFromJson(json);

  @override
  final ResidenceModel data;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RequestState.residence(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$REQUEST_RESIDENCE_DATAImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$REQUEST_RESIDENCE_DATAImplCopyWith<_$REQUEST_RESIDENCE_DATAImpl>
      get copyWith => __$$REQUEST_RESIDENCE_DATAImplCopyWithImpl<
          _$REQUEST_RESIDENCE_DATAImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function() $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function(String error) error,
    required TResult Function(ResidenceModel data) residence,
    required TResult Function(BienImmobilierModel data) bienImmobilier,
    required TResult Function(List<ResidenceModel> data) residences,
    required TResult Function(List<VilleModel> data) villes,
    required TResult Function(List<CommuneModel> data) communes,
  }) {
    return residence(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function()? $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function(String error)? error,
    TResult? Function(ResidenceModel data)? residence,
    TResult? Function(BienImmobilierModel data)? bienImmobilier,
    TResult? Function(List<ResidenceModel> data)? residences,
    TResult? Function(List<VilleModel> data)? villes,
    TResult? Function(List<CommuneModel> data)? communes,
  }) {
    return residence?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function()? $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function(String error)? error,
    TResult Function(ResidenceModel data)? residence,
    TResult Function(BienImmobilierModel data)? bienImmobilier,
    TResult Function(List<ResidenceModel> data)? residences,
    TResult Function(List<VilleModel> data)? villes,
    TResult Function(List<CommuneModel> data)? communes,
    required TResult orElse(),
  }) {
    if (residence != null) {
      return residence(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RequestState value) $default, {
    required TResult Function(REQUEST_INITIAL value) initial,
    required TResult Function(REQUEST_LOADING value) loading,
    required TResult Function(REQUEST_SUCCESS value) success,
    required TResult Function(REQUEST_ERROR value) error,
    required TResult Function(REQUEST_RESIDENCE_DATA value) residence,
    required TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)
        bienImmobilier,
    required TResult Function(REQUEST_RESIDENCES_DATA value) residences,
    required TResult Function(REQUEST_VILLES_DATA value) villes,
    required TResult Function(REQUEST_COMMUNES_DATA value) communes,
  }) {
    return residence(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RequestState value)? $default, {
    TResult? Function(REQUEST_INITIAL value)? initial,
    TResult? Function(REQUEST_LOADING value)? loading,
    TResult? Function(REQUEST_SUCCESS value)? success,
    TResult? Function(REQUEST_ERROR value)? error,
    TResult? Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult? Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult? Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult? Function(REQUEST_VILLES_DATA value)? villes,
    TResult? Function(REQUEST_COMMUNES_DATA value)? communes,
  }) {
    return residence?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RequestState value)? $default, {
    TResult Function(REQUEST_INITIAL value)? initial,
    TResult Function(REQUEST_LOADING value)? loading,
    TResult Function(REQUEST_SUCCESS value)? success,
    TResult Function(REQUEST_ERROR value)? error,
    TResult Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult Function(REQUEST_VILLES_DATA value)? villes,
    TResult Function(REQUEST_COMMUNES_DATA value)? communes,
    required TResult orElse(),
  }) {
    if (residence != null) {
      return residence(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$REQUEST_RESIDENCE_DATAImplToJson(
      this,
    );
  }
}

abstract class REQUEST_RESIDENCE_DATA implements RequestState {
  const factory REQUEST_RESIDENCE_DATA({required final ResidenceModel data}) =
      _$REQUEST_RESIDENCE_DATAImpl;

  factory REQUEST_RESIDENCE_DATA.fromJson(Map<String, dynamic> json) =
      _$REQUEST_RESIDENCE_DATAImpl.fromJson;

  ResidenceModel get data;

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$REQUEST_RESIDENCE_DATAImplCopyWith<_$REQUEST_RESIDENCE_DATAImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$REQUEST_BIEN_IMMOBILIER_DATAImplCopyWith<$Res> {
  factory _$$REQUEST_BIEN_IMMOBILIER_DATAImplCopyWith(
          _$REQUEST_BIEN_IMMOBILIER_DATAImpl value,
          $Res Function(_$REQUEST_BIEN_IMMOBILIER_DATAImpl) then) =
      __$$REQUEST_BIEN_IMMOBILIER_DATAImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BienImmobilierModel data});

  $BienImmobilierModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$REQUEST_BIEN_IMMOBILIER_DATAImplCopyWithImpl<$Res>
    extends _$RequestStateCopyWithImpl<$Res, _$REQUEST_BIEN_IMMOBILIER_DATAImpl>
    implements _$$REQUEST_BIEN_IMMOBILIER_DATAImplCopyWith<$Res> {
  __$$REQUEST_BIEN_IMMOBILIER_DATAImplCopyWithImpl(
      _$REQUEST_BIEN_IMMOBILIER_DATAImpl _value,
      $Res Function(_$REQUEST_BIEN_IMMOBILIER_DATAImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$REQUEST_BIEN_IMMOBILIER_DATAImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as BienImmobilierModel,
    ));
  }

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BienImmobilierModelCopyWith<$Res> get data {
    return $BienImmobilierModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$REQUEST_BIEN_IMMOBILIER_DATAImpl
    implements REQUEST_BIEN_IMMOBILIER_DATA {
  const _$REQUEST_BIEN_IMMOBILIER_DATAImpl(
      {required this.data, final String? $type})
      : $type = $type ?? 'bienImmobilier';

  factory _$REQUEST_BIEN_IMMOBILIER_DATAImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$REQUEST_BIEN_IMMOBILIER_DATAImplFromJson(json);

  @override
  final BienImmobilierModel data;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RequestState.bienImmobilier(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$REQUEST_BIEN_IMMOBILIER_DATAImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$REQUEST_BIEN_IMMOBILIER_DATAImplCopyWith<
          _$REQUEST_BIEN_IMMOBILIER_DATAImpl>
      get copyWith => __$$REQUEST_BIEN_IMMOBILIER_DATAImplCopyWithImpl<
          _$REQUEST_BIEN_IMMOBILIER_DATAImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function() $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function(String error) error,
    required TResult Function(ResidenceModel data) residence,
    required TResult Function(BienImmobilierModel data) bienImmobilier,
    required TResult Function(List<ResidenceModel> data) residences,
    required TResult Function(List<VilleModel> data) villes,
    required TResult Function(List<CommuneModel> data) communes,
  }) {
    return bienImmobilier(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function()? $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function(String error)? error,
    TResult? Function(ResidenceModel data)? residence,
    TResult? Function(BienImmobilierModel data)? bienImmobilier,
    TResult? Function(List<ResidenceModel> data)? residences,
    TResult? Function(List<VilleModel> data)? villes,
    TResult? Function(List<CommuneModel> data)? communes,
  }) {
    return bienImmobilier?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function()? $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function(String error)? error,
    TResult Function(ResidenceModel data)? residence,
    TResult Function(BienImmobilierModel data)? bienImmobilier,
    TResult Function(List<ResidenceModel> data)? residences,
    TResult Function(List<VilleModel> data)? villes,
    TResult Function(List<CommuneModel> data)? communes,
    required TResult orElse(),
  }) {
    if (bienImmobilier != null) {
      return bienImmobilier(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RequestState value) $default, {
    required TResult Function(REQUEST_INITIAL value) initial,
    required TResult Function(REQUEST_LOADING value) loading,
    required TResult Function(REQUEST_SUCCESS value) success,
    required TResult Function(REQUEST_ERROR value) error,
    required TResult Function(REQUEST_RESIDENCE_DATA value) residence,
    required TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)
        bienImmobilier,
    required TResult Function(REQUEST_RESIDENCES_DATA value) residences,
    required TResult Function(REQUEST_VILLES_DATA value) villes,
    required TResult Function(REQUEST_COMMUNES_DATA value) communes,
  }) {
    return bienImmobilier(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RequestState value)? $default, {
    TResult? Function(REQUEST_INITIAL value)? initial,
    TResult? Function(REQUEST_LOADING value)? loading,
    TResult? Function(REQUEST_SUCCESS value)? success,
    TResult? Function(REQUEST_ERROR value)? error,
    TResult? Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult? Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult? Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult? Function(REQUEST_VILLES_DATA value)? villes,
    TResult? Function(REQUEST_COMMUNES_DATA value)? communes,
  }) {
    return bienImmobilier?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RequestState value)? $default, {
    TResult Function(REQUEST_INITIAL value)? initial,
    TResult Function(REQUEST_LOADING value)? loading,
    TResult Function(REQUEST_SUCCESS value)? success,
    TResult Function(REQUEST_ERROR value)? error,
    TResult Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult Function(REQUEST_VILLES_DATA value)? villes,
    TResult Function(REQUEST_COMMUNES_DATA value)? communes,
    required TResult orElse(),
  }) {
    if (bienImmobilier != null) {
      return bienImmobilier(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$REQUEST_BIEN_IMMOBILIER_DATAImplToJson(
      this,
    );
  }
}

abstract class REQUEST_BIEN_IMMOBILIER_DATA implements RequestState {
  const factory REQUEST_BIEN_IMMOBILIER_DATA(
          {required final BienImmobilierModel data}) =
      _$REQUEST_BIEN_IMMOBILIER_DATAImpl;

  factory REQUEST_BIEN_IMMOBILIER_DATA.fromJson(Map<String, dynamic> json) =
      _$REQUEST_BIEN_IMMOBILIER_DATAImpl.fromJson;

  BienImmobilierModel get data;

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$REQUEST_BIEN_IMMOBILIER_DATAImplCopyWith<
          _$REQUEST_BIEN_IMMOBILIER_DATAImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$REQUEST_RESIDENCES_DATAImplCopyWith<$Res> {
  factory _$$REQUEST_RESIDENCES_DATAImplCopyWith(
          _$REQUEST_RESIDENCES_DATAImpl value,
          $Res Function(_$REQUEST_RESIDENCES_DATAImpl) then) =
      __$$REQUEST_RESIDENCES_DATAImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<ResidenceModel> data});
}

/// @nodoc
class __$$REQUEST_RESIDENCES_DATAImplCopyWithImpl<$Res>
    extends _$RequestStateCopyWithImpl<$Res, _$REQUEST_RESIDENCES_DATAImpl>
    implements _$$REQUEST_RESIDENCES_DATAImplCopyWith<$Res> {
  __$$REQUEST_RESIDENCES_DATAImplCopyWithImpl(
      _$REQUEST_RESIDENCES_DATAImpl _value,
      $Res Function(_$REQUEST_RESIDENCES_DATAImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$REQUEST_RESIDENCES_DATAImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ResidenceModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$REQUEST_RESIDENCES_DATAImpl implements REQUEST_RESIDENCES_DATA {
  const _$REQUEST_RESIDENCES_DATAImpl(
      {required final List<ResidenceModel> data, final String? $type})
      : _data = data,
        $type = $type ?? 'residences';

  factory _$REQUEST_RESIDENCES_DATAImpl.fromJson(Map<String, dynamic> json) =>
      _$$REQUEST_RESIDENCES_DATAImplFromJson(json);

  final List<ResidenceModel> _data;
  @override
  List<ResidenceModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RequestState.residences(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$REQUEST_RESIDENCES_DATAImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$REQUEST_RESIDENCES_DATAImplCopyWith<_$REQUEST_RESIDENCES_DATAImpl>
      get copyWith => __$$REQUEST_RESIDENCES_DATAImplCopyWithImpl<
          _$REQUEST_RESIDENCES_DATAImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function() $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function(String error) error,
    required TResult Function(ResidenceModel data) residence,
    required TResult Function(BienImmobilierModel data) bienImmobilier,
    required TResult Function(List<ResidenceModel> data) residences,
    required TResult Function(List<VilleModel> data) villes,
    required TResult Function(List<CommuneModel> data) communes,
  }) {
    return residences(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function()? $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function(String error)? error,
    TResult? Function(ResidenceModel data)? residence,
    TResult? Function(BienImmobilierModel data)? bienImmobilier,
    TResult? Function(List<ResidenceModel> data)? residences,
    TResult? Function(List<VilleModel> data)? villes,
    TResult? Function(List<CommuneModel> data)? communes,
  }) {
    return residences?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function()? $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function(String error)? error,
    TResult Function(ResidenceModel data)? residence,
    TResult Function(BienImmobilierModel data)? bienImmobilier,
    TResult Function(List<ResidenceModel> data)? residences,
    TResult Function(List<VilleModel> data)? villes,
    TResult Function(List<CommuneModel> data)? communes,
    required TResult orElse(),
  }) {
    if (residences != null) {
      return residences(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RequestState value) $default, {
    required TResult Function(REQUEST_INITIAL value) initial,
    required TResult Function(REQUEST_LOADING value) loading,
    required TResult Function(REQUEST_SUCCESS value) success,
    required TResult Function(REQUEST_ERROR value) error,
    required TResult Function(REQUEST_RESIDENCE_DATA value) residence,
    required TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)
        bienImmobilier,
    required TResult Function(REQUEST_RESIDENCES_DATA value) residences,
    required TResult Function(REQUEST_VILLES_DATA value) villes,
    required TResult Function(REQUEST_COMMUNES_DATA value) communes,
  }) {
    return residences(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RequestState value)? $default, {
    TResult? Function(REQUEST_INITIAL value)? initial,
    TResult? Function(REQUEST_LOADING value)? loading,
    TResult? Function(REQUEST_SUCCESS value)? success,
    TResult? Function(REQUEST_ERROR value)? error,
    TResult? Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult? Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult? Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult? Function(REQUEST_VILLES_DATA value)? villes,
    TResult? Function(REQUEST_COMMUNES_DATA value)? communes,
  }) {
    return residences?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RequestState value)? $default, {
    TResult Function(REQUEST_INITIAL value)? initial,
    TResult Function(REQUEST_LOADING value)? loading,
    TResult Function(REQUEST_SUCCESS value)? success,
    TResult Function(REQUEST_ERROR value)? error,
    TResult Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult Function(REQUEST_VILLES_DATA value)? villes,
    TResult Function(REQUEST_COMMUNES_DATA value)? communes,
    required TResult orElse(),
  }) {
    if (residences != null) {
      return residences(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$REQUEST_RESIDENCES_DATAImplToJson(
      this,
    );
  }
}

abstract class REQUEST_RESIDENCES_DATA implements RequestState {
  const factory REQUEST_RESIDENCES_DATA(
          {required final List<ResidenceModel> data}) =
      _$REQUEST_RESIDENCES_DATAImpl;

  factory REQUEST_RESIDENCES_DATA.fromJson(Map<String, dynamic> json) =
      _$REQUEST_RESIDENCES_DATAImpl.fromJson;

  List<ResidenceModel> get data;

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$REQUEST_RESIDENCES_DATAImplCopyWith<_$REQUEST_RESIDENCES_DATAImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$REQUEST_VILLES_DATAImplCopyWith<$Res> {
  factory _$$REQUEST_VILLES_DATAImplCopyWith(_$REQUEST_VILLES_DATAImpl value,
          $Res Function(_$REQUEST_VILLES_DATAImpl) then) =
      __$$REQUEST_VILLES_DATAImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<VilleModel> data});
}

/// @nodoc
class __$$REQUEST_VILLES_DATAImplCopyWithImpl<$Res>
    extends _$RequestStateCopyWithImpl<$Res, _$REQUEST_VILLES_DATAImpl>
    implements _$$REQUEST_VILLES_DATAImplCopyWith<$Res> {
  __$$REQUEST_VILLES_DATAImplCopyWithImpl(_$REQUEST_VILLES_DATAImpl _value,
      $Res Function(_$REQUEST_VILLES_DATAImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$REQUEST_VILLES_DATAImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<VilleModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$REQUEST_VILLES_DATAImpl implements REQUEST_VILLES_DATA {
  const _$REQUEST_VILLES_DATAImpl(
      {required final List<VilleModel> data, final String? $type})
      : _data = data,
        $type = $type ?? 'villes';

  factory _$REQUEST_VILLES_DATAImpl.fromJson(Map<String, dynamic> json) =>
      _$$REQUEST_VILLES_DATAImplFromJson(json);

  final List<VilleModel> _data;
  @override
  List<VilleModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RequestState.villes(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$REQUEST_VILLES_DATAImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$REQUEST_VILLES_DATAImplCopyWith<_$REQUEST_VILLES_DATAImpl> get copyWith =>
      __$$REQUEST_VILLES_DATAImplCopyWithImpl<_$REQUEST_VILLES_DATAImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function() $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function(String error) error,
    required TResult Function(ResidenceModel data) residence,
    required TResult Function(BienImmobilierModel data) bienImmobilier,
    required TResult Function(List<ResidenceModel> data) residences,
    required TResult Function(List<VilleModel> data) villes,
    required TResult Function(List<CommuneModel> data) communes,
  }) {
    return villes(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function()? $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function(String error)? error,
    TResult? Function(ResidenceModel data)? residence,
    TResult? Function(BienImmobilierModel data)? bienImmobilier,
    TResult? Function(List<ResidenceModel> data)? residences,
    TResult? Function(List<VilleModel> data)? villes,
    TResult? Function(List<CommuneModel> data)? communes,
  }) {
    return villes?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function()? $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function(String error)? error,
    TResult Function(ResidenceModel data)? residence,
    TResult Function(BienImmobilierModel data)? bienImmobilier,
    TResult Function(List<ResidenceModel> data)? residences,
    TResult Function(List<VilleModel> data)? villes,
    TResult Function(List<CommuneModel> data)? communes,
    required TResult orElse(),
  }) {
    if (villes != null) {
      return villes(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RequestState value) $default, {
    required TResult Function(REQUEST_INITIAL value) initial,
    required TResult Function(REQUEST_LOADING value) loading,
    required TResult Function(REQUEST_SUCCESS value) success,
    required TResult Function(REQUEST_ERROR value) error,
    required TResult Function(REQUEST_RESIDENCE_DATA value) residence,
    required TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)
        bienImmobilier,
    required TResult Function(REQUEST_RESIDENCES_DATA value) residences,
    required TResult Function(REQUEST_VILLES_DATA value) villes,
    required TResult Function(REQUEST_COMMUNES_DATA value) communes,
  }) {
    return villes(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RequestState value)? $default, {
    TResult? Function(REQUEST_INITIAL value)? initial,
    TResult? Function(REQUEST_LOADING value)? loading,
    TResult? Function(REQUEST_SUCCESS value)? success,
    TResult? Function(REQUEST_ERROR value)? error,
    TResult? Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult? Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult? Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult? Function(REQUEST_VILLES_DATA value)? villes,
    TResult? Function(REQUEST_COMMUNES_DATA value)? communes,
  }) {
    return villes?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RequestState value)? $default, {
    TResult Function(REQUEST_INITIAL value)? initial,
    TResult Function(REQUEST_LOADING value)? loading,
    TResult Function(REQUEST_SUCCESS value)? success,
    TResult Function(REQUEST_ERROR value)? error,
    TResult Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult Function(REQUEST_VILLES_DATA value)? villes,
    TResult Function(REQUEST_COMMUNES_DATA value)? communes,
    required TResult orElse(),
  }) {
    if (villes != null) {
      return villes(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$REQUEST_VILLES_DATAImplToJson(
      this,
    );
  }
}

abstract class REQUEST_VILLES_DATA implements RequestState {
  const factory REQUEST_VILLES_DATA({required final List<VilleModel> data}) =
      _$REQUEST_VILLES_DATAImpl;

  factory REQUEST_VILLES_DATA.fromJson(Map<String, dynamic> json) =
      _$REQUEST_VILLES_DATAImpl.fromJson;

  List<VilleModel> get data;

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$REQUEST_VILLES_DATAImplCopyWith<_$REQUEST_VILLES_DATAImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$REQUEST_COMMUNES_DATAImplCopyWith<$Res> {
  factory _$$REQUEST_COMMUNES_DATAImplCopyWith(
          _$REQUEST_COMMUNES_DATAImpl value,
          $Res Function(_$REQUEST_COMMUNES_DATAImpl) then) =
      __$$REQUEST_COMMUNES_DATAImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<CommuneModel> data});
}

/// @nodoc
class __$$REQUEST_COMMUNES_DATAImplCopyWithImpl<$Res>
    extends _$RequestStateCopyWithImpl<$Res, _$REQUEST_COMMUNES_DATAImpl>
    implements _$$REQUEST_COMMUNES_DATAImplCopyWith<$Res> {
  __$$REQUEST_COMMUNES_DATAImplCopyWithImpl(_$REQUEST_COMMUNES_DATAImpl _value,
      $Res Function(_$REQUEST_COMMUNES_DATAImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$REQUEST_COMMUNES_DATAImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<CommuneModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$REQUEST_COMMUNES_DATAImpl implements REQUEST_COMMUNES_DATA {
  const _$REQUEST_COMMUNES_DATAImpl(
      {required final List<CommuneModel> data, final String? $type})
      : _data = data,
        $type = $type ?? 'communes';

  factory _$REQUEST_COMMUNES_DATAImpl.fromJson(Map<String, dynamic> json) =>
      _$$REQUEST_COMMUNES_DATAImplFromJson(json);

  final List<CommuneModel> _data;
  @override
  List<CommuneModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RequestState.communes(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$REQUEST_COMMUNES_DATAImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$REQUEST_COMMUNES_DATAImplCopyWith<_$REQUEST_COMMUNES_DATAImpl>
      get copyWith => __$$REQUEST_COMMUNES_DATAImplCopyWithImpl<
          _$REQUEST_COMMUNES_DATAImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function() $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function(String error) error,
    required TResult Function(ResidenceModel data) residence,
    required TResult Function(BienImmobilierModel data) bienImmobilier,
    required TResult Function(List<ResidenceModel> data) residences,
    required TResult Function(List<VilleModel> data) villes,
    required TResult Function(List<CommuneModel> data) communes,
  }) {
    return communes(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function()? $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function(String error)? error,
    TResult? Function(ResidenceModel data)? residence,
    TResult? Function(BienImmobilierModel data)? bienImmobilier,
    TResult? Function(List<ResidenceModel> data)? residences,
    TResult? Function(List<VilleModel> data)? villes,
    TResult? Function(List<CommuneModel> data)? communes,
  }) {
    return communes?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function()? $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function(String error)? error,
    TResult Function(ResidenceModel data)? residence,
    TResult Function(BienImmobilierModel data)? bienImmobilier,
    TResult Function(List<ResidenceModel> data)? residences,
    TResult Function(List<VilleModel> data)? villes,
    TResult Function(List<CommuneModel> data)? communes,
    required TResult orElse(),
  }) {
    if (communes != null) {
      return communes(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RequestState value) $default, {
    required TResult Function(REQUEST_INITIAL value) initial,
    required TResult Function(REQUEST_LOADING value) loading,
    required TResult Function(REQUEST_SUCCESS value) success,
    required TResult Function(REQUEST_ERROR value) error,
    required TResult Function(REQUEST_RESIDENCE_DATA value) residence,
    required TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)
        bienImmobilier,
    required TResult Function(REQUEST_RESIDENCES_DATA value) residences,
    required TResult Function(REQUEST_VILLES_DATA value) villes,
    required TResult Function(REQUEST_COMMUNES_DATA value) communes,
  }) {
    return communes(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RequestState value)? $default, {
    TResult? Function(REQUEST_INITIAL value)? initial,
    TResult? Function(REQUEST_LOADING value)? loading,
    TResult? Function(REQUEST_SUCCESS value)? success,
    TResult? Function(REQUEST_ERROR value)? error,
    TResult? Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult? Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult? Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult? Function(REQUEST_VILLES_DATA value)? villes,
    TResult? Function(REQUEST_COMMUNES_DATA value)? communes,
  }) {
    return communes?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RequestState value)? $default, {
    TResult Function(REQUEST_INITIAL value)? initial,
    TResult Function(REQUEST_LOADING value)? loading,
    TResult Function(REQUEST_SUCCESS value)? success,
    TResult Function(REQUEST_ERROR value)? error,
    TResult Function(REQUEST_RESIDENCE_DATA value)? residence,
    TResult Function(REQUEST_BIEN_IMMOBILIER_DATA value)? bienImmobilier,
    TResult Function(REQUEST_RESIDENCES_DATA value)? residences,
    TResult Function(REQUEST_VILLES_DATA value)? villes,
    TResult Function(REQUEST_COMMUNES_DATA value)? communes,
    required TResult orElse(),
  }) {
    if (communes != null) {
      return communes(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$REQUEST_COMMUNES_DATAImplToJson(
      this,
    );
  }
}

abstract class REQUEST_COMMUNES_DATA implements RequestState {
  const factory REQUEST_COMMUNES_DATA(
      {required final List<CommuneModel> data}) = _$REQUEST_COMMUNES_DATAImpl;

  factory REQUEST_COMMUNES_DATA.fromJson(Map<String, dynamic> json) =
      _$REQUEST_COMMUNES_DATAImpl.fromJson;

  List<CommuneModel> get data;

  /// Create a copy of RequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$REQUEST_COMMUNES_DATAImplCopyWith<_$REQUEST_COMMUNES_DATAImpl>
      get copyWith => throw _privateConstructorUsedError;
}
