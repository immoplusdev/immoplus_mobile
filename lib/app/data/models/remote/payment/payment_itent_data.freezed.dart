// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_itent_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentItentData _$PaymentItentDataFromJson(Map<String, dynamic> json) {
  return _PaymentItentData.fromJson(json);
}

/// @nodoc
mixin _$PaymentItentData {
  String get id => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  int get amountNoFees => throw _privateConstructorUsedError;
  String get paymentType => throw _privateConstructorUsedError;
  String get collection => throw _privateConstructorUsedError;
  String get paymentStatus => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  String get hub2PaymentId => throw _privateConstructorUsedError;
  String? get hub2Exception => throw _privateConstructorUsedError;
  Hub2NextAction? get hub2NextAction => throw _privateConstructorUsedError;
  String get hub2Token =>
      throw _privateConstructorUsedError; //Hub2Metadata? hub2Metadata,
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this PaymentItentData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentItentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentItentDataCopyWith<PaymentItentData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentItentDataCopyWith<$Res> {
  factory $PaymentItentDataCopyWith(
          PaymentItentData value, $Res Function(PaymentItentData) then) =
      _$PaymentItentDataCopyWithImpl<$Res, PaymentItentData>;
  @useResult
  $Res call(
      {String id,
      int amount,
      int amountNoFees,
      String paymentType,
      String collection,
      String paymentStatus,
      String paymentMethod,
      String itemId,
      String hub2PaymentId,
      String? hub2Exception,
      Hub2NextAction? hub2NextAction,
      String hub2Token,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt});

  $Hub2NextActionCopyWith<$Res>? get hub2NextAction;
}

/// @nodoc
class _$PaymentItentDataCopyWithImpl<$Res, $Val extends PaymentItentData>
    implements $PaymentItentDataCopyWith<$Res> {
  _$PaymentItentDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentItentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? amountNoFees = null,
    Object? paymentType = null,
    Object? collection = null,
    Object? paymentStatus = null,
    Object? paymentMethod = null,
    Object? itemId = null,
    Object? hub2PaymentId = null,
    Object? hub2Exception = freezed,
    Object? hub2NextAction = freezed,
    Object? hub2Token = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      amountNoFees: null == amountNoFees
          ? _value.amountNoFees
          : amountNoFees // ignore: cast_nullable_to_non_nullable
              as int,
      paymentType: null == paymentType
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as String,
      collection: null == collection
          ? _value.collection
          : collection // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      hub2PaymentId: null == hub2PaymentId
          ? _value.hub2PaymentId
          : hub2PaymentId // ignore: cast_nullable_to_non_nullable
              as String,
      hub2Exception: freezed == hub2Exception
          ? _value.hub2Exception
          : hub2Exception // ignore: cast_nullable_to_non_nullable
              as String?,
      hub2NextAction: freezed == hub2NextAction
          ? _value.hub2NextAction
          : hub2NextAction // ignore: cast_nullable_to_non_nullable
              as Hub2NextAction?,
      hub2Token: null == hub2Token
          ? _value.hub2Token
          : hub2Token // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of PaymentItentData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Hub2NextActionCopyWith<$Res>? get hub2NextAction {
    if (_value.hub2NextAction == null) {
      return null;
    }

    return $Hub2NextActionCopyWith<$Res>(_value.hub2NextAction!, (value) {
      return _then(_value.copyWith(hub2NextAction: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaymentItentDataImplCopyWith<$Res>
    implements $PaymentItentDataCopyWith<$Res> {
  factory _$$PaymentItentDataImplCopyWith(_$PaymentItentDataImpl value,
          $Res Function(_$PaymentItentDataImpl) then) =
      __$$PaymentItentDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int amount,
      int amountNoFees,
      String paymentType,
      String collection,
      String paymentStatus,
      String paymentMethod,
      String itemId,
      String hub2PaymentId,
      String? hub2Exception,
      Hub2NextAction? hub2NextAction,
      String hub2Token,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt});

  @override
  $Hub2NextActionCopyWith<$Res>? get hub2NextAction;
}

/// @nodoc
class __$$PaymentItentDataImplCopyWithImpl<$Res>
    extends _$PaymentItentDataCopyWithImpl<$Res, _$PaymentItentDataImpl>
    implements _$$PaymentItentDataImplCopyWith<$Res> {
  __$$PaymentItentDataImplCopyWithImpl(_$PaymentItentDataImpl _value,
      $Res Function(_$PaymentItentDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentItentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? amountNoFees = null,
    Object? paymentType = null,
    Object? collection = null,
    Object? paymentStatus = null,
    Object? paymentMethod = null,
    Object? itemId = null,
    Object? hub2PaymentId = null,
    Object? hub2Exception = freezed,
    Object? hub2NextAction = freezed,
    Object? hub2Token = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_$PaymentItentDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      amountNoFees: null == amountNoFees
          ? _value.amountNoFees
          : amountNoFees // ignore: cast_nullable_to_non_nullable
              as int,
      paymentType: null == paymentType
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as String,
      collection: null == collection
          ? _value.collection
          : collection // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      hub2PaymentId: null == hub2PaymentId
          ? _value.hub2PaymentId
          : hub2PaymentId // ignore: cast_nullable_to_non_nullable
              as String,
      hub2Exception: freezed == hub2Exception
          ? _value.hub2Exception
          : hub2Exception // ignore: cast_nullable_to_non_nullable
              as String?,
      hub2NextAction: freezed == hub2NextAction
          ? _value.hub2NextAction
          : hub2NextAction // ignore: cast_nullable_to_non_nullable
              as Hub2NextAction?,
      hub2Token: null == hub2Token
          ? _value.hub2Token
          : hub2Token // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentItentDataImpl implements _PaymentItentData {
  _$PaymentItentDataImpl(
      {this.id = '',
      this.amount = 0,
      this.amountNoFees = 0,
      this.paymentType = '',
      this.collection = '',
      this.paymentStatus = '',
      this.paymentMethod = '',
      this.itemId = '',
      this.hub2PaymentId = '',
      this.hub2Exception,
      this.hub2NextAction,
      this.hub2Token = '',
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  factory _$PaymentItentDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentItentDataImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final int amount;
  @override
  @JsonKey()
  final int amountNoFees;
  @override
  @JsonKey()
  final String paymentType;
  @override
  @JsonKey()
  final String collection;
  @override
  @JsonKey()
  final String paymentStatus;
  @override
  @JsonKey()
  final String paymentMethod;
  @override
  @JsonKey()
  final String itemId;
  @override
  @JsonKey()
  final String hub2PaymentId;
  @override
  final String? hub2Exception;
  @override
  final Hub2NextAction? hub2NextAction;
  @override
  @JsonKey()
  final String hub2Token;
//Hub2Metadata? hub2Metadata,
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'PaymentItentData(id: $id, amount: $amount, amountNoFees: $amountNoFees, paymentType: $paymentType, collection: $collection, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, itemId: $itemId, hub2PaymentId: $hub2PaymentId, hub2Exception: $hub2Exception, hub2NextAction: $hub2NextAction, hub2Token: $hub2Token, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentItentDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.amountNoFees, amountNoFees) ||
                other.amountNoFees == amountNoFees) &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
            (identical(other.collection, collection) ||
                other.collection == collection) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.hub2PaymentId, hub2PaymentId) ||
                other.hub2PaymentId == hub2PaymentId) &&
            (identical(other.hub2Exception, hub2Exception) ||
                other.hub2Exception == hub2Exception) &&
            (identical(other.hub2NextAction, hub2NextAction) ||
                other.hub2NextAction == hub2NextAction) &&
            (identical(other.hub2Token, hub2Token) ||
                other.hub2Token == hub2Token) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      amount,
      amountNoFees,
      paymentType,
      collection,
      paymentStatus,
      paymentMethod,
      itemId,
      hub2PaymentId,
      hub2Exception,
      hub2NextAction,
      hub2Token,
      createdAt,
      updatedAt,
      deletedAt);

  /// Create a copy of PaymentItentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentItentDataImplCopyWith<_$PaymentItentDataImpl> get copyWith =>
      __$$PaymentItentDataImplCopyWithImpl<_$PaymentItentDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentItentDataImplToJson(
      this,
    );
  }
}

abstract class _PaymentItentData implements PaymentItentData {
  factory _PaymentItentData(
      {final String id,
      final int amount,
      final int amountNoFees,
      final String paymentType,
      final String collection,
      final String paymentStatus,
      final String paymentMethod,
      final String itemId,
      final String hub2PaymentId,
      final String? hub2Exception,
      final Hub2NextAction? hub2NextAction,
      final String hub2Token,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final DateTime? deletedAt}) = _$PaymentItentDataImpl;

  factory _PaymentItentData.fromJson(Map<String, dynamic> json) =
      _$PaymentItentDataImpl.fromJson;

  @override
  String get id;
  @override
  int get amount;
  @override
  int get amountNoFees;
  @override
  String get paymentType;
  @override
  String get collection;
  @override
  String get paymentStatus;
  @override
  String get paymentMethod;
  @override
  String get itemId;
  @override
  String get hub2PaymentId;
  @override
  String? get hub2Exception;
  @override
  Hub2NextAction? get hub2NextAction;
  @override
  String get hub2Token; //Hub2Metadata? hub2Metadata,
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get deletedAt;

  /// Create a copy of PaymentItentData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentItentDataImplCopyWith<_$PaymentItentDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
