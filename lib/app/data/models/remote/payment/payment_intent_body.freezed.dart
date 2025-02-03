// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_intent_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentIntentBody _$PaymentIntentBodyFromJson(Map<String, dynamic> json) {
  return _PaymentIntentBody.fromJson(json);
}

/// @nodoc
mixin _$PaymentIntentBody {
  String get collection => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String get paymentCredentials => throw _privateConstructorUsedError;

  /// Serializes this PaymentIntentBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentIntentBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentIntentBodyCopyWith<PaymentIntentBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentIntentBodyCopyWith<$Res> {
  factory $PaymentIntentBodyCopyWith(
          PaymentIntentBody value, $Res Function(PaymentIntentBody) then) =
      _$PaymentIntentBodyCopyWithImpl<$Res, PaymentIntentBody>;
  @useResult
  $Res call(
      {String collection,
      String itemId,
      String paymentMethod,
      String paymentCredentials});
}

/// @nodoc
class _$PaymentIntentBodyCopyWithImpl<$Res, $Val extends PaymentIntentBody>
    implements $PaymentIntentBodyCopyWith<$Res> {
  _$PaymentIntentBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentIntentBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collection = null,
    Object? itemId = null,
    Object? paymentMethod = null,
    Object? paymentCredentials = null,
  }) {
    return _then(_value.copyWith(
      collection: null == collection
          ? _value.collection
          : collection // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      paymentCredentials: null == paymentCredentials
          ? _value.paymentCredentials
          : paymentCredentials // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentIntentBodyImplCopyWith<$Res>
    implements $PaymentIntentBodyCopyWith<$Res> {
  factory _$$PaymentIntentBodyImplCopyWith(_$PaymentIntentBodyImpl value,
          $Res Function(_$PaymentIntentBodyImpl) then) =
      __$$PaymentIntentBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String collection,
      String itemId,
      String paymentMethod,
      String paymentCredentials});
}

/// @nodoc
class __$$PaymentIntentBodyImplCopyWithImpl<$Res>
    extends _$PaymentIntentBodyCopyWithImpl<$Res, _$PaymentIntentBodyImpl>
    implements _$$PaymentIntentBodyImplCopyWith<$Res> {
  __$$PaymentIntentBodyImplCopyWithImpl(_$PaymentIntentBodyImpl _value,
      $Res Function(_$PaymentIntentBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentIntentBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collection = null,
    Object? itemId = null,
    Object? paymentMethod = null,
    Object? paymentCredentials = null,
  }) {
    return _then(_$PaymentIntentBodyImpl(
      collection: null == collection
          ? _value.collection
          : collection // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      paymentCredentials: null == paymentCredentials
          ? _value.paymentCredentials
          : paymentCredentials // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentIntentBodyImpl implements _PaymentIntentBody {
  const _$PaymentIntentBodyImpl(
      {this.collection = '',
      this.itemId = '',
      this.paymentMethod = '',
      this.paymentCredentials = ''});

  factory _$PaymentIntentBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentIntentBodyImplFromJson(json);

  @override
  @JsonKey()
  final String collection;
  @override
  @JsonKey()
  final String itemId;
  @override
  @JsonKey()
  final String paymentMethod;
  @override
  @JsonKey()
  final String paymentCredentials;

  @override
  String toString() {
    return 'PaymentIntentBody(collection: $collection, itemId: $itemId, paymentMethod: $paymentMethod, paymentCredentials: $paymentCredentials)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentIntentBodyImpl &&
            (identical(other.collection, collection) ||
                other.collection == collection) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentCredentials, paymentCredentials) ||
                other.paymentCredentials == paymentCredentials));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, collection, itemId, paymentMethod, paymentCredentials);

  /// Create a copy of PaymentIntentBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentIntentBodyImplCopyWith<_$PaymentIntentBodyImpl> get copyWith =>
      __$$PaymentIntentBodyImplCopyWithImpl<_$PaymentIntentBodyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentIntentBodyImplToJson(
      this,
    );
  }
}

abstract class _PaymentIntentBody implements PaymentIntentBody {
  const factory _PaymentIntentBody(
      {final String collection,
      final String itemId,
      final String paymentMethod,
      final String paymentCredentials}) = _$PaymentIntentBodyImpl;

  factory _PaymentIntentBody.fromJson(Map<String, dynamic> json) =
      _$PaymentIntentBodyImpl.fromJson;

  @override
  String get collection;
  @override
  String get itemId;
  @override
  String get paymentMethod;
  @override
  String get paymentCredentials;

  /// Create a copy of PaymentIntentBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentIntentBodyImplCopyWith<_$PaymentIntentBodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
