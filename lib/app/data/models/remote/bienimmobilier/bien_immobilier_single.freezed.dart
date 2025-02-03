// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bien_immobilier_single.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BienImmobilierSingle _$BienImmobilierSingleFromJson(Map<String, dynamic> json) {
  return _BienImmobilierSingle.fromJson(json);
}

/// @nodoc
mixin _$BienImmobilierSingle {
  BienImmobilierModel? get data => throw _privateConstructorUsedError;

  /// Serializes this BienImmobilierSingle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BienImmobilierSingle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BienImmobilierSingleCopyWith<BienImmobilierSingle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BienImmobilierSingleCopyWith<$Res> {
  factory $BienImmobilierSingleCopyWith(BienImmobilierSingle value,
          $Res Function(BienImmobilierSingle) then) =
      _$BienImmobilierSingleCopyWithImpl<$Res, BienImmobilierSingle>;
  @useResult
  $Res call({BienImmobilierModel? data});

  $BienImmobilierModelCopyWith<$Res>? get data;
}

/// @nodoc
class _$BienImmobilierSingleCopyWithImpl<$Res,
        $Val extends BienImmobilierSingle>
    implements $BienImmobilierSingleCopyWith<$Res> {
  _$BienImmobilierSingleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BienImmobilierSingle
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
              as BienImmobilierModel?,
    ) as $Val);
  }

  /// Create a copy of BienImmobilierSingle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BienImmobilierModelCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $BienImmobilierModelCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BienImmobilierSingleImplCopyWith<$Res>
    implements $BienImmobilierSingleCopyWith<$Res> {
  factory _$$BienImmobilierSingleImplCopyWith(_$BienImmobilierSingleImpl value,
          $Res Function(_$BienImmobilierSingleImpl) then) =
      __$$BienImmobilierSingleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BienImmobilierModel? data});

  @override
  $BienImmobilierModelCopyWith<$Res>? get data;
}

/// @nodoc
class __$$BienImmobilierSingleImplCopyWithImpl<$Res>
    extends _$BienImmobilierSingleCopyWithImpl<$Res, _$BienImmobilierSingleImpl>
    implements _$$BienImmobilierSingleImplCopyWith<$Res> {
  __$$BienImmobilierSingleImplCopyWithImpl(_$BienImmobilierSingleImpl _value,
      $Res Function(_$BienImmobilierSingleImpl) _then)
      : super(_value, _then);

  /// Create a copy of BienImmobilierSingle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$BienImmobilierSingleImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as BienImmobilierModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BienImmobilierSingleImpl implements _BienImmobilierSingle {
  _$BienImmobilierSingleImpl({this.data});

  factory _$BienImmobilierSingleImpl.fromJson(Map<String, dynamic> json) =>
      _$$BienImmobilierSingleImplFromJson(json);

  @override
  final BienImmobilierModel? data;

  @override
  String toString() {
    return 'BienImmobilierSingle(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BienImmobilierSingleImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of BienImmobilierSingle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BienImmobilierSingleImplCopyWith<_$BienImmobilierSingleImpl>
      get copyWith =>
          __$$BienImmobilierSingleImplCopyWithImpl<_$BienImmobilierSingleImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BienImmobilierSingleImplToJson(
      this,
    );
  }
}

abstract class _BienImmobilierSingle implements BienImmobilierSingle {
  factory _BienImmobilierSingle({final BienImmobilierModel? data}) =
      _$BienImmobilierSingleImpl;

  factory _BienImmobilierSingle.fromJson(Map<String, dynamic> json) =
      _$BienImmobilierSingleImpl.fromJson;

  @override
  BienImmobilierModel? get data;

  /// Create a copy of BienImmobilierSingle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BienImmobilierSingleImplCopyWith<_$BienImmobilierSingleImpl>
      get copyWith => throw _privateConstructorUsedError;
}
