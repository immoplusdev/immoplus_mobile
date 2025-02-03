// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_authenticate_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentAuthenticateBody _$PaymentAuthenticateBodyFromJson(
    Map<String, dynamic> json) {
  return _PaymentAuthenticateBody.fromJson(json);
}

/// @nodoc
mixin _$PaymentAuthenticateBody {
  String get otp => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  String get collection => throw _privateConstructorUsedError;

  /// Serializes this PaymentAuthenticateBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentAuthenticateBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentAuthenticateBodyCopyWith<PaymentAuthenticateBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentAuthenticateBodyCopyWith<$Res> {
  factory $PaymentAuthenticateBodyCopyWith(PaymentAuthenticateBody value,
          $Res Function(PaymentAuthenticateBody) then) =
      _$PaymentAuthenticateBodyCopyWithImpl<$Res, PaymentAuthenticateBody>;
  @useResult
  $Res call({String otp, String itemId, String collection});
}

/// @nodoc
class _$PaymentAuthenticateBodyCopyWithImpl<$Res,
        $Val extends PaymentAuthenticateBody>
    implements $PaymentAuthenticateBodyCopyWith<$Res> {
  _$PaymentAuthenticateBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentAuthenticateBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otp = null,
    Object? itemId = null,
    Object? collection = null,
  }) {
    return _then(_value.copyWith(
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      collection: null == collection
          ? _value.collection
          : collection // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentAuthenticateBodyImplCopyWith<$Res>
    implements $PaymentAuthenticateBodyCopyWith<$Res> {
  factory _$$PaymentAuthenticateBodyImplCopyWith(
          _$PaymentAuthenticateBodyImpl value,
          $Res Function(_$PaymentAuthenticateBodyImpl) then) =
      __$$PaymentAuthenticateBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String otp, String itemId, String collection});
}

/// @nodoc
class __$$PaymentAuthenticateBodyImplCopyWithImpl<$Res>
    extends _$PaymentAuthenticateBodyCopyWithImpl<$Res,
        _$PaymentAuthenticateBodyImpl>
    implements _$$PaymentAuthenticateBodyImplCopyWith<$Res> {
  __$$PaymentAuthenticateBodyImplCopyWithImpl(
      _$PaymentAuthenticateBodyImpl _value,
      $Res Function(_$PaymentAuthenticateBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentAuthenticateBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otp = null,
    Object? itemId = null,
    Object? collection = null,
  }) {
    return _then(_$PaymentAuthenticateBodyImpl(
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      collection: null == collection
          ? _value.collection
          : collection // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentAuthenticateBodyImpl implements _PaymentAuthenticateBody {
  _$PaymentAuthenticateBodyImpl(
      {this.otp = '', this.itemId = '', this.collection = ''});

  factory _$PaymentAuthenticateBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentAuthenticateBodyImplFromJson(json);

  @override
  @JsonKey()
  final String otp;
  @override
  @JsonKey()
  final String itemId;
  @override
  @JsonKey()
  final String collection;

  @override
  String toString() {
    return 'PaymentAuthenticateBody(otp: $otp, itemId: $itemId, collection: $collection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentAuthenticateBodyImpl &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.collection, collection) ||
                other.collection == collection));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, otp, itemId, collection);

  /// Create a copy of PaymentAuthenticateBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentAuthenticateBodyImplCopyWith<_$PaymentAuthenticateBodyImpl>
      get copyWith => __$$PaymentAuthenticateBodyImplCopyWithImpl<
          _$PaymentAuthenticateBodyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentAuthenticateBodyImplToJson(
      this,
    );
  }
}

abstract class _PaymentAuthenticateBody implements PaymentAuthenticateBody {
  factory _PaymentAuthenticateBody(
      {final String otp,
      final String itemId,
      final String collection}) = _$PaymentAuthenticateBodyImpl;

  factory _PaymentAuthenticateBody.fromJson(Map<String, dynamic> json) =
      _$PaymentAuthenticateBodyImpl.fromJson;

  @override
  String get otp;
  @override
  String get itemId;
  @override
  String get collection;

  /// Create a copy of PaymentAuthenticateBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentAuthenticateBodyImplCopyWith<_$PaymentAuthenticateBodyImpl>
      get copyWith => throw _privateConstructorUsedError;
}
