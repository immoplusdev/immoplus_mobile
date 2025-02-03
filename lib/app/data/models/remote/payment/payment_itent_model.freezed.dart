// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_itent_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentItentModel _$PaymentItentModelFromJson(Map<String, dynamic> json) {
  return _PaymentItentModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentItentModel {
  PaymentItentData get data => throw _privateConstructorUsedError;

  /// Serializes this PaymentItentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentItentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentItentModelCopyWith<PaymentItentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentItentModelCopyWith<$Res> {
  factory $PaymentItentModelCopyWith(
          PaymentItentModel value, $Res Function(PaymentItentModel) then) =
      _$PaymentItentModelCopyWithImpl<$Res, PaymentItentModel>;
  @useResult
  $Res call({PaymentItentData data});

  $PaymentItentDataCopyWith<$Res> get data;
}

/// @nodoc
class _$PaymentItentModelCopyWithImpl<$Res, $Val extends PaymentItentModel>
    implements $PaymentItentModelCopyWith<$Res> {
  _$PaymentItentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentItentModel
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
              as PaymentItentData,
    ) as $Val);
  }

  /// Create a copy of PaymentItentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentItentDataCopyWith<$Res> get data {
    return $PaymentItentDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaymentItentModelImplCopyWith<$Res>
    implements $PaymentItentModelCopyWith<$Res> {
  factory _$$PaymentItentModelImplCopyWith(_$PaymentItentModelImpl value,
          $Res Function(_$PaymentItentModelImpl) then) =
      __$$PaymentItentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PaymentItentData data});

  @override
  $PaymentItentDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$PaymentItentModelImplCopyWithImpl<$Res>
    extends _$PaymentItentModelCopyWithImpl<$Res, _$PaymentItentModelImpl>
    implements _$$PaymentItentModelImplCopyWith<$Res> {
  __$$PaymentItentModelImplCopyWithImpl(_$PaymentItentModelImpl _value,
      $Res Function(_$PaymentItentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentItentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$PaymentItentModelImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as PaymentItentData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentItentModelImpl implements _PaymentItentModel {
  _$PaymentItentModelImpl({required this.data});

  factory _$PaymentItentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentItentModelImplFromJson(json);

  @override
  final PaymentItentData data;

  @override
  String toString() {
    return 'PaymentItentModel(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentItentModelImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of PaymentItentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentItentModelImplCopyWith<_$PaymentItentModelImpl> get copyWith =>
      __$$PaymentItentModelImplCopyWithImpl<_$PaymentItentModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentItentModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentItentModel implements PaymentItentModel {
  factory _PaymentItentModel({required final PaymentItentData data}) =
      _$PaymentItentModelImpl;

  factory _PaymentItentModel.fromJson(Map<String, dynamic> json) =
      _$PaymentItentModelImpl.fromJson;

  @override
  PaymentItentData get data;

  /// Create a copy of PaymentItentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentItentModelImplCopyWith<_$PaymentItentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
