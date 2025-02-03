// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_opt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SendOptModel _$SendOptModelFromJson(Map<String, dynamic> json) {
  return _SendOptModel.fromJson(json);
}

/// @nodoc
mixin _$SendOptModel {
  String get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this SendOptModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SendOptModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendOptModelCopyWith<SendOptModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendOptModelCopyWith<$Res> {
  factory $SendOptModelCopyWith(
          SendOptModel value, $Res Function(SendOptModel) then) =
      _$SendOptModelCopyWithImpl<$Res, SendOptModel>;
  @useResult
  $Res call({String phoneNumber});
}

/// @nodoc
class _$SendOptModelCopyWithImpl<$Res, $Val extends SendOptModel>
    implements $SendOptModelCopyWith<$Res> {
  _$SendOptModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendOptModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
  }) {
    return _then(_value.copyWith(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SendOptModelImplCopyWith<$Res>
    implements $SendOptModelCopyWith<$Res> {
  factory _$$SendOptModelImplCopyWith(
          _$SendOptModelImpl value, $Res Function(_$SendOptModelImpl) then) =
      __$$SendOptModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phoneNumber});
}

/// @nodoc
class __$$SendOptModelImplCopyWithImpl<$Res>
    extends _$SendOptModelCopyWithImpl<$Res, _$SendOptModelImpl>
    implements _$$SendOptModelImplCopyWith<$Res> {
  __$$SendOptModelImplCopyWithImpl(
      _$SendOptModelImpl _value, $Res Function(_$SendOptModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SendOptModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
  }) {
    return _then(_$SendOptModelImpl(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SendOptModelImpl implements _SendOptModel {
  const _$SendOptModelImpl({required this.phoneNumber});

  factory _$SendOptModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendOptModelImplFromJson(json);

  @override
  final String phoneNumber;

  @override
  String toString() {
    return 'SendOptModel(phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendOptModelImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber);

  /// Create a copy of SendOptModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendOptModelImplCopyWith<_$SendOptModelImpl> get copyWith =>
      __$$SendOptModelImplCopyWithImpl<_$SendOptModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendOptModelImplToJson(
      this,
    );
  }
}

abstract class _SendOptModel implements SendOptModel {
  const factory _SendOptModel({required final String phoneNumber}) =
      _$SendOptModelImpl;

  factory _SendOptModel.fromJson(Map<String, dynamic> json) =
      _$SendOptModelImpl.fromJson;

  @override
  String get phoneNumber;

  /// Create a copy of SendOptModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendOptModelImplCopyWith<_$SendOptModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
