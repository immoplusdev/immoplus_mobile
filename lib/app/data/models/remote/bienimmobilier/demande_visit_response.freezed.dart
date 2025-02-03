// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'demande_visit_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DemandeVisitResponse _$DemandeVisitResponseFromJson(Map<String, dynamic> json) {
  return _DemandeVisitResponse.fromJson(json);
}

/// @nodoc
mixin _$DemandeVisitResponse {
  DemandeVisiteModel get data => throw _privateConstructorUsedError;

  /// Serializes this DemandeVisitResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DemandeVisitResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DemandeVisitResponseCopyWith<DemandeVisitResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DemandeVisitResponseCopyWith<$Res> {
  factory $DemandeVisitResponseCopyWith(DemandeVisitResponse value,
          $Res Function(DemandeVisitResponse) then) =
      _$DemandeVisitResponseCopyWithImpl<$Res, DemandeVisitResponse>;
  @useResult
  $Res call({DemandeVisiteModel data});

  $DemandeVisiteModelCopyWith<$Res> get data;
}

/// @nodoc
class _$DemandeVisitResponseCopyWithImpl<$Res,
        $Val extends DemandeVisitResponse>
    implements $DemandeVisitResponseCopyWith<$Res> {
  _$DemandeVisitResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DemandeVisitResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as DemandeVisiteModel,
    ) as $Val);
  }

  /// Create a copy of DemandeVisitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DemandeVisiteModelCopyWith<$Res> get data {
    return $DemandeVisiteModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DemandeVisitResponseImplCopyWith<$Res>
    implements $DemandeVisitResponseCopyWith<$Res> {
  factory _$$DemandeVisitResponseImplCopyWith(_$DemandeVisitResponseImpl value,
          $Res Function(_$DemandeVisitResponseImpl) then) =
      __$$DemandeVisitResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DemandeVisiteModel data});

  @override
  $DemandeVisiteModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$DemandeVisitResponseImplCopyWithImpl<$Res>
    extends _$DemandeVisitResponseCopyWithImpl<$Res, _$DemandeVisitResponseImpl>
    implements _$$DemandeVisitResponseImplCopyWith<$Res> {
  __$$DemandeVisitResponseImplCopyWithImpl(_$DemandeVisitResponseImpl _value,
      $Res Function(_$DemandeVisitResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of DemandeVisitResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$DemandeVisitResponseImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as DemandeVisiteModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DemandeVisitResponseImpl implements _DemandeVisitResponse {
  _$DemandeVisitResponseImpl({required this.data});

  factory _$DemandeVisitResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DemandeVisitResponseImplFromJson(json);

  @override
  final DemandeVisiteModel data;

  @override
  String toString() {
    return 'DemandeVisitResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DemandeVisitResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of DemandeVisitResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DemandeVisitResponseImplCopyWith<_$DemandeVisitResponseImpl>
      get copyWith =>
          __$$DemandeVisitResponseImplCopyWithImpl<_$DemandeVisitResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DemandeVisitResponseImplToJson(
      this,
    );
  }
}

abstract class _DemandeVisitResponse implements DemandeVisitResponse {
  factory _DemandeVisitResponse({required final DemandeVisiteModel data}) =
      _$DemandeVisitResponseImpl;

  factory _DemandeVisitResponse.fromJson(Map<String, dynamic> json) =
      _$DemandeVisitResponseImpl.fromJson;

  @override
  DemandeVisiteModel get data;

  /// Create a copy of DemandeVisitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DemandeVisitResponseImplCopyWith<_$DemandeVisitResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
