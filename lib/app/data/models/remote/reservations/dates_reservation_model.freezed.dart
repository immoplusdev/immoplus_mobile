// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dates_reservation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DatesReservationModel _$DatesReservationModelFromJson(
    Map<String, dynamic> json) {
  return _DatesReservationModel.fromJson(json);
}

/// @nodoc
mixin _$DatesReservationModel {
  DateTime? get date => throw _privateConstructorUsedError;

  /// Serializes this DatesReservationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DatesReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DatesReservationModelCopyWith<DatesReservationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DatesReservationModelCopyWith<$Res> {
  factory $DatesReservationModelCopyWith(DatesReservationModel value,
          $Res Function(DatesReservationModel) then) =
      _$DatesReservationModelCopyWithImpl<$Res, DatesReservationModel>;
  @useResult
  $Res call({DateTime? date});
}

/// @nodoc
class _$DatesReservationModelCopyWithImpl<$Res,
        $Val extends DatesReservationModel>
    implements $DatesReservationModelCopyWith<$Res> {
  _$DatesReservationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DatesReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DatesReservationModelImplCopyWith<$Res>
    implements $DatesReservationModelCopyWith<$Res> {
  factory _$$DatesReservationModelImplCopyWith(
          _$DatesReservationModelImpl value,
          $Res Function(_$DatesReservationModelImpl) then) =
      __$$DatesReservationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? date});
}

/// @nodoc
class __$$DatesReservationModelImplCopyWithImpl<$Res>
    extends _$DatesReservationModelCopyWithImpl<$Res,
        _$DatesReservationModelImpl>
    implements _$$DatesReservationModelImplCopyWith<$Res> {
  __$$DatesReservationModelImplCopyWithImpl(_$DatesReservationModelImpl _value,
      $Res Function(_$DatesReservationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DatesReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
  }) {
    return _then(_$DatesReservationModelImpl(
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DatesReservationModelImpl implements _DatesReservationModel {
  const _$DatesReservationModelImpl({this.date = null});

  factory _$DatesReservationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DatesReservationModelImplFromJson(json);

  @override
  @JsonKey()
  final DateTime? date;

  @override
  String toString() {
    return 'DatesReservationModel(date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatesReservationModelImpl &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date);

  /// Create a copy of DatesReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DatesReservationModelImplCopyWith<_$DatesReservationModelImpl>
      get copyWith => __$$DatesReservationModelImplCopyWithImpl<
          _$DatesReservationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DatesReservationModelImplToJson(
      this,
    );
  }
}

abstract class _DatesReservationModel implements DatesReservationModel {
  const factory _DatesReservationModel({final DateTime? date}) =
      _$DatesReservationModelImpl;

  factory _DatesReservationModel.fromJson(Map<String, dynamic> json) =
      _$DatesReservationModelImpl.fromJson;

  @override
  DateTime? get date;

  /// Create a copy of DatesReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DatesReservationModelImplCopyWith<_$DatesReservationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
