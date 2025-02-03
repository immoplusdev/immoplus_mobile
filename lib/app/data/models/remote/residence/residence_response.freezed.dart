// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'residence_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResidenceResponse _$ResidenceResponseFromJson(Map<String, dynamic> json) {
  return _ResidenceResponse.fromJson(json);
}

/// @nodoc
mixin _$ResidenceResponse {
  ResidenceModel get data => throw _privateConstructorUsedError;

  /// Serializes this ResidenceResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResidenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResidenceResponseCopyWith<ResidenceResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResidenceResponseCopyWith<$Res> {
  factory $ResidenceResponseCopyWith(
          ResidenceResponse value, $Res Function(ResidenceResponse) then) =
      _$ResidenceResponseCopyWithImpl<$Res, ResidenceResponse>;
  @useResult
  $Res call({ResidenceModel data});

  $ResidenceModelCopyWith<$Res> get data;
}

/// @nodoc
class _$ResidenceResponseCopyWithImpl<$Res, $Val extends ResidenceResponse>
    implements $ResidenceResponseCopyWith<$Res> {
  _$ResidenceResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResidenceResponse
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
              as ResidenceModel,
    ) as $Val);
  }

  /// Create a copy of ResidenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResidenceModelCopyWith<$Res> get data {
    return $ResidenceModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResidenceResponseImplCopyWith<$Res>
    implements $ResidenceResponseCopyWith<$Res> {
  factory _$$ResidenceResponseImplCopyWith(_$ResidenceResponseImpl value,
          $Res Function(_$ResidenceResponseImpl) then) =
      __$$ResidenceResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ResidenceModel data});

  @override
  $ResidenceModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$ResidenceResponseImplCopyWithImpl<$Res>
    extends _$ResidenceResponseCopyWithImpl<$Res, _$ResidenceResponseImpl>
    implements _$$ResidenceResponseImplCopyWith<$Res> {
  __$$ResidenceResponseImplCopyWithImpl(_$ResidenceResponseImpl _value,
      $Res Function(_$ResidenceResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResidenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$ResidenceResponseImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ResidenceModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResidenceResponseImpl implements _ResidenceResponse {
  _$ResidenceResponseImpl({required this.data});

  factory _$ResidenceResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResidenceResponseImplFromJson(json);

  @override
  final ResidenceModel data;

  @override
  String toString() {
    return 'ResidenceResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResidenceResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of ResidenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResidenceResponseImplCopyWith<_$ResidenceResponseImpl> get copyWith =>
      __$$ResidenceResponseImplCopyWithImpl<_$ResidenceResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResidenceResponseImplToJson(
      this,
    );
  }
}

abstract class _ResidenceResponse implements ResidenceResponse {
  factory _ResidenceResponse({required final ResidenceModel data}) =
      _$ResidenceResponseImpl;

  factory _ResidenceResponse.fromJson(Map<String, dynamic> json) =
      _$ResidenceResponseImpl.fromJson;

  @override
  ResidenceModel get data;

  /// Create a copy of ResidenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResidenceResponseImplCopyWith<_$ResidenceResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
