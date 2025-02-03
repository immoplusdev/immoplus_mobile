// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'commodite_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommoditeModel _$CommoditeModelFromJson(Map<String, dynamic> json) {
  return _CommoditeModel.fromJson(json);
}

/// @nodoc
mixin _$CommoditeModel {
  String get text => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;

  /// Serializes this CommoditeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommoditeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommoditeModelCopyWith<CommoditeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommoditeModelCopyWith<$Res> {
  factory $CommoditeModelCopyWith(
          CommoditeModel value, $Res Function(CommoditeModel) then) =
      _$CommoditeModelCopyWithImpl<$Res, CommoditeModel>;
  @useResult
  $Res call({String text, String icon});
}

/// @nodoc
class _$CommoditeModelCopyWithImpl<$Res, $Val extends CommoditeModel>
    implements $CommoditeModelCopyWith<$Res> {
  _$CommoditeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommoditeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? icon = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommoditeModelImplCopyWith<$Res>
    implements $CommoditeModelCopyWith<$Res> {
  factory _$$CommoditeModelImplCopyWith(_$CommoditeModelImpl value,
          $Res Function(_$CommoditeModelImpl) then) =
      __$$CommoditeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, String icon});
}

/// @nodoc
class __$$CommoditeModelImplCopyWithImpl<$Res>
    extends _$CommoditeModelCopyWithImpl<$Res, _$CommoditeModelImpl>
    implements _$$CommoditeModelImplCopyWith<$Res> {
  __$$CommoditeModelImplCopyWithImpl(
      _$CommoditeModelImpl _value, $Res Function(_$CommoditeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommoditeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? icon = null,
  }) {
    return _then(_$CommoditeModelImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommoditeModelImpl implements _CommoditeModel {
  const _$CommoditeModelImpl({this.text = '', this.icon = ''});

  factory _$CommoditeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommoditeModelImplFromJson(json);

  @override
  @JsonKey()
  final String text;
  @override
  @JsonKey()
  final String icon;

  @override
  String toString() {
    return 'CommoditeModel(text: $text, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommoditeModelImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, icon);

  /// Create a copy of CommoditeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommoditeModelImplCopyWith<_$CommoditeModelImpl> get copyWith =>
      __$$CommoditeModelImplCopyWithImpl<_$CommoditeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommoditeModelImplToJson(
      this,
    );
  }
}

abstract class _CommoditeModel implements CommoditeModel {
  const factory _CommoditeModel({final String text, final String icon}) =
      _$CommoditeModelImpl;

  factory _CommoditeModel.fromJson(Map<String, dynamic> json) =
      _$CommoditeModelImpl.fromJson;

  @override
  String get text;
  @override
  String get icon;

  /// Create a copy of CommoditeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommoditeModelImplCopyWith<_$CommoditeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
