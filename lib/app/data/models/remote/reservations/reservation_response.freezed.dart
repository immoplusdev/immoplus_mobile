// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReservationResponse _$ReservationResponseFromJson(Map<String, dynamic> json) {
  return _ReservationResponse.fromJson(json);
}

/// @nodoc
mixin _$ReservationResponse {
  ReservationModel get data => throw _privateConstructorUsedError;

  /// Serializes this ReservationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReservationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationResponseCopyWith<ReservationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationResponseCopyWith<$Res> {
  factory $ReservationResponseCopyWith(
          ReservationResponse value, $Res Function(ReservationResponse) then) =
      _$ReservationResponseCopyWithImpl<$Res, ReservationResponse>;
  @useResult
  $Res call({ReservationModel data});

  $ReservationModelCopyWith<$Res> get data;
}

/// @nodoc
class _$ReservationResponseCopyWithImpl<$Res, $Val extends ReservationResponse>
    implements $ReservationResponseCopyWith<$Res> {
  _$ReservationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservationResponse
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
              as ReservationModel,
    ) as $Val);
  }

  /// Create a copy of ReservationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReservationModelCopyWith<$Res> get data {
    return $ReservationModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReservationResponseImplCopyWith<$Res>
    implements $ReservationResponseCopyWith<$Res> {
  factory _$$ReservationResponseImplCopyWith(_$ReservationResponseImpl value,
          $Res Function(_$ReservationResponseImpl) then) =
      __$$ReservationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ReservationModel data});

  @override
  $ReservationModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$ReservationResponseImplCopyWithImpl<$Res>
    extends _$ReservationResponseCopyWithImpl<$Res, _$ReservationResponseImpl>
    implements _$$ReservationResponseImplCopyWith<$Res> {
  __$$ReservationResponseImplCopyWithImpl(_$ReservationResponseImpl _value,
      $Res Function(_$ReservationResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReservationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$ReservationResponseImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ReservationModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationResponseImpl implements _ReservationResponse {
  _$ReservationResponseImpl({required this.data});

  factory _$ReservationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationResponseImplFromJson(json);

  @override
  final ReservationModel data;

  @override
  String toString() {
    return 'ReservationResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of ReservationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationResponseImplCopyWith<_$ReservationResponseImpl> get copyWith =>
      __$$ReservationResponseImplCopyWithImpl<_$ReservationResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationResponseImplToJson(
      this,
    );
  }
}

abstract class _ReservationResponse implements ReservationResponse {
  factory _ReservationResponse({required final ReservationModel data}) =
      _$ReservationResponseImpl;

  factory _ReservationResponse.fromJson(Map<String, dynamic> json) =
      _$ReservationResponseImpl.fromJson;

  @override
  ReservationModel get data;

  /// Create a copy of ReservationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationResponseImplCopyWith<_$ReservationResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
