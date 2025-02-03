// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReservationRequestBody _$ReservationRequestBodyFromJson(
    Map<String, dynamic> json) {
  return _ReservationRequestBody.fromJson(json);
}

/// @nodoc
mixin _$ReservationRequestBody {
  String get residence => throw _privateConstructorUsedError;
  List<DatesReservationModel> get datesReservation =>
      throw _privateConstructorUsedError;
  String get clientPhoneNumber => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this ReservationRequestBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReservationRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationRequestBodyCopyWith<ReservationRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationRequestBodyCopyWith<$Res> {
  factory $ReservationRequestBodyCopyWith(ReservationRequestBody value,
          $Res Function(ReservationRequestBody) then) =
      _$ReservationRequestBodyCopyWithImpl<$Res, ReservationRequestBody>;
  @useResult
  $Res call(
      {String residence,
      List<DatesReservationModel> datesReservation,
      String clientPhoneNumber,
      String? notes});
}

/// @nodoc
class _$ReservationRequestBodyCopyWithImpl<$Res,
        $Val extends ReservationRequestBody>
    implements $ReservationRequestBodyCopyWith<$Res> {
  _$ReservationRequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservationRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? residence = null,
    Object? datesReservation = null,
    Object? clientPhoneNumber = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      residence: null == residence
          ? _value.residence
          : residence // ignore: cast_nullable_to_non_nullable
              as String,
      datesReservation: null == datesReservation
          ? _value.datesReservation
          : datesReservation // ignore: cast_nullable_to_non_nullable
              as List<DatesReservationModel>,
      clientPhoneNumber: null == clientPhoneNumber
          ? _value.clientPhoneNumber
          : clientPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReservationRequestBodyImplCopyWith<$Res>
    implements $ReservationRequestBodyCopyWith<$Res> {
  factory _$$ReservationRequestBodyImplCopyWith(
          _$ReservationRequestBodyImpl value,
          $Res Function(_$ReservationRequestBodyImpl) then) =
      __$$ReservationRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String residence,
      List<DatesReservationModel> datesReservation,
      String clientPhoneNumber,
      String? notes});
}

/// @nodoc
class __$$ReservationRequestBodyImplCopyWithImpl<$Res>
    extends _$ReservationRequestBodyCopyWithImpl<$Res,
        _$ReservationRequestBodyImpl>
    implements _$$ReservationRequestBodyImplCopyWith<$Res> {
  __$$ReservationRequestBodyImplCopyWithImpl(
      _$ReservationRequestBodyImpl _value,
      $Res Function(_$ReservationRequestBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReservationRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? residence = null,
    Object? datesReservation = null,
    Object? clientPhoneNumber = null,
    Object? notes = freezed,
  }) {
    return _then(_$ReservationRequestBodyImpl(
      residence: null == residence
          ? _value.residence
          : residence // ignore: cast_nullable_to_non_nullable
              as String,
      datesReservation: null == datesReservation
          ? _value._datesReservation
          : datesReservation // ignore: cast_nullable_to_non_nullable
              as List<DatesReservationModel>,
      clientPhoneNumber: null == clientPhoneNumber
          ? _value.clientPhoneNumber
          : clientPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationRequestBodyImpl implements _ReservationRequestBody {
  const _$ReservationRequestBodyImpl(
      {required this.residence,
      required final List<DatesReservationModel> datesReservation,
      required this.clientPhoneNumber,
      this.notes})
      : _datesReservation = datesReservation;

  factory _$ReservationRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationRequestBodyImplFromJson(json);

  @override
  final String residence;
  final List<DatesReservationModel> _datesReservation;
  @override
  List<DatesReservationModel> get datesReservation {
    if (_datesReservation is EqualUnmodifiableListView)
      return _datesReservation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_datesReservation);
  }

  @override
  final String clientPhoneNumber;
  @override
  final String? notes;

  @override
  String toString() {
    return 'ReservationRequestBody(residence: $residence, datesReservation: $datesReservation, clientPhoneNumber: $clientPhoneNumber, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationRequestBodyImpl &&
            (identical(other.residence, residence) ||
                other.residence == residence) &&
            const DeepCollectionEquality()
                .equals(other._datesReservation, _datesReservation) &&
            (identical(other.clientPhoneNumber, clientPhoneNumber) ||
                other.clientPhoneNumber == clientPhoneNumber) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      residence,
      const DeepCollectionEquality().hash(_datesReservation),
      clientPhoneNumber,
      notes);

  /// Create a copy of ReservationRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationRequestBodyImplCopyWith<_$ReservationRequestBodyImpl>
      get copyWith => __$$ReservationRequestBodyImplCopyWithImpl<
          _$ReservationRequestBodyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationRequestBodyImplToJson(
      this,
    );
  }
}

abstract class _ReservationRequestBody implements ReservationRequestBody {
  const factory _ReservationRequestBody(
      {required final String residence,
      required final List<DatesReservationModel> datesReservation,
      required final String clientPhoneNumber,
      final String? notes}) = _$ReservationRequestBodyImpl;

  factory _ReservationRequestBody.fromJson(Map<String, dynamic> json) =
      _$ReservationRequestBodyImpl.fromJson;

  @override
  String get residence;
  @override
  List<DatesReservationModel> get datesReservation;
  @override
  String get clientPhoneNumber;
  @override
  String? get notes;

  /// Create a copy of ReservationRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationRequestBodyImplCopyWith<_$ReservationRequestBodyImpl>
      get copyWith => throw _privateConstructorUsedError;
}
