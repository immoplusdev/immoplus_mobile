// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'estimate_price_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EstimatePriceModel _$EstimatePriceModelFromJson(Map<String, dynamic> json) {
  return _EstimatePriceModel.fromJson(json);
}

/// @nodoc
mixin _$EstimatePriceModel {
  EstimatePriceData? get data => throw _privateConstructorUsedError;

  /// Serializes this EstimatePriceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EstimatePriceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EstimatePriceModelCopyWith<EstimatePriceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EstimatePriceModelCopyWith<$Res> {
  factory $EstimatePriceModelCopyWith(
          EstimatePriceModel value, $Res Function(EstimatePriceModel) then) =
      _$EstimatePriceModelCopyWithImpl<$Res, EstimatePriceModel>;
  @useResult
  $Res call({EstimatePriceData? data});

  $EstimatePriceDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$EstimatePriceModelCopyWithImpl<$Res, $Val extends EstimatePriceModel>
    implements $EstimatePriceModelCopyWith<$Res> {
  _$EstimatePriceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EstimatePriceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as EstimatePriceData?,
    ) as $Val);
  }

  /// Create a copy of EstimatePriceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EstimatePriceDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $EstimatePriceDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EstimatePriceModelImplCopyWith<$Res>
    implements $EstimatePriceModelCopyWith<$Res> {
  factory _$$EstimatePriceModelImplCopyWith(_$EstimatePriceModelImpl value,
          $Res Function(_$EstimatePriceModelImpl) then) =
      __$$EstimatePriceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({EstimatePriceData? data});

  @override
  $EstimatePriceDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$EstimatePriceModelImplCopyWithImpl<$Res>
    extends _$EstimatePriceModelCopyWithImpl<$Res, _$EstimatePriceModelImpl>
    implements _$$EstimatePriceModelImplCopyWith<$Res> {
  __$$EstimatePriceModelImplCopyWithImpl(_$EstimatePriceModelImpl _value,
      $Res Function(_$EstimatePriceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EstimatePriceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$EstimatePriceModelImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as EstimatePriceData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EstimatePriceModelImpl implements _EstimatePriceModel {
  const _$EstimatePriceModelImpl({this.data});

  factory _$EstimatePriceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EstimatePriceModelImplFromJson(json);

  @override
  final EstimatePriceData? data;

  @override
  String toString() {
    return 'EstimatePriceModel(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EstimatePriceModelImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of EstimatePriceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EstimatePriceModelImplCopyWith<_$EstimatePriceModelImpl> get copyWith =>
      __$$EstimatePriceModelImplCopyWithImpl<_$EstimatePriceModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EstimatePriceModelImplToJson(
      this,
    );
  }
}

abstract class _EstimatePriceModel implements EstimatePriceModel {
  const factory _EstimatePriceModel({final EstimatePriceData? data}) =
      _$EstimatePriceModelImpl;

  factory _EstimatePriceModel.fromJson(Map<String, dynamic> json) =
      _$EstimatePriceModelImpl.fromJson;

  @override
  EstimatePriceData? get data;

  /// Create a copy of EstimatePriceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EstimatePriceModelImplCopyWith<_$EstimatePriceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EstimatePriceData _$EstimatePriceDataFromJson(Map<String, dynamic> json) {
  return _EstimatePriceData.fromJson(json);
}

/// @nodoc
mixin _$EstimatePriceData {
  String get residence => throw _privateConstructorUsedError;
  List<ReservationDate> get datesReservation =>
      throw _privateConstructorUsedError;
  double get montantTotalReservation => throw _privateConstructorUsedError;
  double get montantReservationSansCommission =>
      throw _privateConstructorUsedError;

  /// Serializes this EstimatePriceData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EstimatePriceData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EstimatePriceDataCopyWith<EstimatePriceData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EstimatePriceDataCopyWith<$Res> {
  factory $EstimatePriceDataCopyWith(
          EstimatePriceData value, $Res Function(EstimatePriceData) then) =
      _$EstimatePriceDataCopyWithImpl<$Res, EstimatePriceData>;
  @useResult
  $Res call(
      {String residence,
      List<ReservationDate> datesReservation,
      double montantTotalReservation,
      double montantReservationSansCommission});
}

/// @nodoc
class _$EstimatePriceDataCopyWithImpl<$Res, $Val extends EstimatePriceData>
    implements $EstimatePriceDataCopyWith<$Res> {
  _$EstimatePriceDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EstimatePriceData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? residence = null,
    Object? datesReservation = null,
    Object? montantTotalReservation = null,
    Object? montantReservationSansCommission = null,
  }) {
    return _then(_value.copyWith(
      residence: null == residence
          ? _value.residence
          : residence // ignore: cast_nullable_to_non_nullable
              as String,
      datesReservation: null == datesReservation
          ? _value.datesReservation
          : datesReservation // ignore: cast_nullable_to_non_nullable
              as List<ReservationDate>,
      montantTotalReservation: null == montantTotalReservation
          ? _value.montantTotalReservation
          : montantTotalReservation // ignore: cast_nullable_to_non_nullable
              as double,
      montantReservationSansCommission: null == montantReservationSansCommission
          ? _value.montantReservationSansCommission
          : montantReservationSansCommission // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EstimatePriceDataImplCopyWith<$Res>
    implements $EstimatePriceDataCopyWith<$Res> {
  factory _$$EstimatePriceDataImplCopyWith(_$EstimatePriceDataImpl value,
          $Res Function(_$EstimatePriceDataImpl) then) =
      __$$EstimatePriceDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String residence,
      List<ReservationDate> datesReservation,
      double montantTotalReservation,
      double montantReservationSansCommission});
}

/// @nodoc
class __$$EstimatePriceDataImplCopyWithImpl<$Res>
    extends _$EstimatePriceDataCopyWithImpl<$Res, _$EstimatePriceDataImpl>
    implements _$$EstimatePriceDataImplCopyWith<$Res> {
  __$$EstimatePriceDataImplCopyWithImpl(_$EstimatePriceDataImpl _value,
      $Res Function(_$EstimatePriceDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of EstimatePriceData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? residence = null,
    Object? datesReservation = null,
    Object? montantTotalReservation = null,
    Object? montantReservationSansCommission = null,
  }) {
    return _then(_$EstimatePriceDataImpl(
      residence: null == residence
          ? _value.residence
          : residence // ignore: cast_nullable_to_non_nullable
              as String,
      datesReservation: null == datesReservation
          ? _value._datesReservation
          : datesReservation // ignore: cast_nullable_to_non_nullable
              as List<ReservationDate>,
      montantTotalReservation: null == montantTotalReservation
          ? _value.montantTotalReservation
          : montantTotalReservation // ignore: cast_nullable_to_non_nullable
              as double,
      montantReservationSansCommission: null == montantReservationSansCommission
          ? _value.montantReservationSansCommission
          : montantReservationSansCommission // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EstimatePriceDataImpl implements _EstimatePriceData {
  const _$EstimatePriceDataImpl(
      {this.residence = '',
      final List<ReservationDate> datesReservation = const [],
      this.montantTotalReservation = 0,
      this.montantReservationSansCommission = 0})
      : _datesReservation = datesReservation;

  factory _$EstimatePriceDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$EstimatePriceDataImplFromJson(json);

  @override
  @JsonKey()
  final String residence;
  final List<ReservationDate> _datesReservation;
  @override
  @JsonKey()
  List<ReservationDate> get datesReservation {
    if (_datesReservation is EqualUnmodifiableListView)
      return _datesReservation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_datesReservation);
  }

  @override
  @JsonKey()
  final double montantTotalReservation;
  @override
  @JsonKey()
  final double montantReservationSansCommission;

  @override
  String toString() {
    return 'EstimatePriceData(residence: $residence, datesReservation: $datesReservation, montantTotalReservation: $montantTotalReservation, montantReservationSansCommission: $montantReservationSansCommission)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EstimatePriceDataImpl &&
            (identical(other.residence, residence) ||
                other.residence == residence) &&
            const DeepCollectionEquality()
                .equals(other._datesReservation, _datesReservation) &&
            (identical(
                    other.montantTotalReservation, montantTotalReservation) ||
                other.montantTotalReservation == montantTotalReservation) &&
            (identical(other.montantReservationSansCommission,
                    montantReservationSansCommission) ||
                other.montantReservationSansCommission ==
                    montantReservationSansCommission));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      residence,
      const DeepCollectionEquality().hash(_datesReservation),
      montantTotalReservation,
      montantReservationSansCommission);

  /// Create a copy of EstimatePriceData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EstimatePriceDataImplCopyWith<_$EstimatePriceDataImpl> get copyWith =>
      __$$EstimatePriceDataImplCopyWithImpl<_$EstimatePriceDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EstimatePriceDataImplToJson(
      this,
    );
  }
}

abstract class _EstimatePriceData implements EstimatePriceData {
  const factory _EstimatePriceData(
      {final String residence,
      final List<ReservationDate> datesReservation,
      final double montantTotalReservation,
      final double montantReservationSansCommission}) = _$EstimatePriceDataImpl;

  factory _EstimatePriceData.fromJson(Map<String, dynamic> json) =
      _$EstimatePriceDataImpl.fromJson;

  @override
  String get residence;
  @override
  List<ReservationDate> get datesReservation;
  @override
  double get montantTotalReservation;
  @override
  double get montantReservationSansCommission;

  /// Create a copy of EstimatePriceData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EstimatePriceDataImplCopyWith<_$EstimatePriceDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReservationDate _$ReservationDateFromJson(Map<String, dynamic> json) {
  return _ReservationDate.fromJson(json);
}

/// @nodoc
mixin _$ReservationDate {
  DateTime? get date => throw _privateConstructorUsedError;

  /// Serializes this ReservationDate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReservationDate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationDateCopyWith<ReservationDate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationDateCopyWith<$Res> {
  factory $ReservationDateCopyWith(
          ReservationDate value, $Res Function(ReservationDate) then) =
      _$ReservationDateCopyWithImpl<$Res, ReservationDate>;
  @useResult
  $Res call({DateTime? date});
}

/// @nodoc
class _$ReservationDateCopyWithImpl<$Res, $Val extends ReservationDate>
    implements $ReservationDateCopyWith<$Res> {
  _$ReservationDateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservationDate
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
abstract class _$$ReservationDateImplCopyWith<$Res>
    implements $ReservationDateCopyWith<$Res> {
  factory _$$ReservationDateImplCopyWith(_$ReservationDateImpl value,
          $Res Function(_$ReservationDateImpl) then) =
      __$$ReservationDateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? date});
}

/// @nodoc
class __$$ReservationDateImplCopyWithImpl<$Res>
    extends _$ReservationDateCopyWithImpl<$Res, _$ReservationDateImpl>
    implements _$$ReservationDateImplCopyWith<$Res> {
  __$$ReservationDateImplCopyWithImpl(
      _$ReservationDateImpl _value, $Res Function(_$ReservationDateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReservationDate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
  }) {
    return _then(_$ReservationDateImpl(
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationDateImpl implements _ReservationDate {
  const _$ReservationDateImpl({this.date});

  factory _$ReservationDateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationDateImplFromJson(json);

  @override
  final DateTime? date;

  @override
  String toString() {
    return 'ReservationDate(date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationDateImpl &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date);

  /// Create a copy of ReservationDate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationDateImplCopyWith<_$ReservationDateImpl> get copyWith =>
      __$$ReservationDateImplCopyWithImpl<_$ReservationDateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationDateImplToJson(
      this,
    );
  }
}

abstract class _ReservationDate implements ReservationDate {
  const factory _ReservationDate({final DateTime? date}) =
      _$ReservationDateImpl;

  factory _ReservationDate.fromJson(Map<String, dynamic> json) =
      _$ReservationDateImpl.fromJson;

  @override
  DateTime? get date;

  /// Create a copy of ReservationDate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationDateImplCopyWith<_$ReservationDateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
