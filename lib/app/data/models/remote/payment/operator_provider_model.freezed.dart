// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operator_provider_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OperatorProviderModel _$OperatorProviderModelFromJson(
    Map<String, dynamic> json) {
  return _OperatorProviderModel.fromJson(json);
}

/// @nodoc
mixin _$OperatorProviderModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Serializes this OperatorProviderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OperatorProviderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OperatorProviderModelCopyWith<OperatorProviderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OperatorProviderModelCopyWith<$Res> {
  factory $OperatorProviderModelCopyWith(OperatorProviderModel value,
          $Res Function(OperatorProviderModel) then) =
      _$OperatorProviderModelCopyWithImpl<$Res, OperatorProviderModel>;
  @useResult
  $Res call(
      {String id, String name, String country, String method, String currency});
}

/// @nodoc
class _$OperatorProviderModelCopyWithImpl<$Res,
        $Val extends OperatorProviderModel>
    implements $OperatorProviderModelCopyWith<$Res> {
  _$OperatorProviderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OperatorProviderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? country = null,
    Object? method = null,
    Object? currency = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OperatorProviderModelImplCopyWith<$Res>
    implements $OperatorProviderModelCopyWith<$Res> {
  factory _$$OperatorProviderModelImplCopyWith(
          _$OperatorProviderModelImpl value,
          $Res Function(_$OperatorProviderModelImpl) then) =
      __$$OperatorProviderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String name, String country, String method, String currency});
}

/// @nodoc
class __$$OperatorProviderModelImplCopyWithImpl<$Res>
    extends _$OperatorProviderModelCopyWithImpl<$Res,
        _$OperatorProviderModelImpl>
    implements _$$OperatorProviderModelImplCopyWith<$Res> {
  __$$OperatorProviderModelImplCopyWithImpl(_$OperatorProviderModelImpl _value,
      $Res Function(_$OperatorProviderModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OperatorProviderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? country = null,
    Object? method = null,
    Object? currency = null,
  }) {
    return _then(_$OperatorProviderModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OperatorProviderModelImpl implements _OperatorProviderModel {
  const _$OperatorProviderModelImpl(
      {this.id = '',
      this.name = '',
      this.country = '',
      this.method = '',
      this.currency = ''});

  factory _$OperatorProviderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OperatorProviderModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String country;
  @override
  @JsonKey()
  final String method;
  @override
  @JsonKey()
  final String currency;

  @override
  String toString() {
    return 'OperatorProviderModel(id: $id, name: $name, country: $country, method: $method, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperatorProviderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, country, method, currency);

  /// Create a copy of OperatorProviderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OperatorProviderModelImplCopyWith<_$OperatorProviderModelImpl>
      get copyWith => __$$OperatorProviderModelImplCopyWithImpl<
          _$OperatorProviderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OperatorProviderModelImplToJson(
      this,
    );
  }
}

abstract class _OperatorProviderModel implements OperatorProviderModel {
  const factory _OperatorProviderModel(
      {final String id,
      final String name,
      final String country,
      final String method,
      final String currency}) = _$OperatorProviderModelImpl;

  factory _OperatorProviderModel.fromJson(Map<String, dynamic> json) =
      _$OperatorProviderModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get country;
  @override
  String get method;
  @override
  String get currency;

  /// Create a copy of OperatorProviderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OperatorProviderModelImplCopyWith<_$OperatorProviderModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
