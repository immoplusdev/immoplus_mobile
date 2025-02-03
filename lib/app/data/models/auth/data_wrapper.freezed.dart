// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_wrapper.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DataWrapper _$DataWrapperFromJson(Map<String, dynamic> json) {
  return _DataWrapper.fromJson(json);
}

/// @nodoc
mixin _$DataWrapper {
  @JsonKey(name: 'data')
  DataModel get data => throw _privateConstructorUsedError;

  /// Serializes this DataWrapper to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DataWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DataWrapperCopyWith<DataWrapper> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataWrapperCopyWith<$Res> {
  factory $DataWrapperCopyWith(
          DataWrapper value, $Res Function(DataWrapper) then) =
      _$DataWrapperCopyWithImpl<$Res, DataWrapper>;
  @useResult
  $Res call({@JsonKey(name: 'data') DataModel data});

  $DataModelCopyWith<$Res> get data;
}

/// @nodoc
class _$DataWrapperCopyWithImpl<$Res, $Val extends DataWrapper>
    implements $DataWrapperCopyWith<$Res> {
  _$DataWrapperCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DataWrapper
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
              as DataModel,
    ) as $Val);
  }

  /// Create a copy of DataWrapper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DataModelCopyWith<$Res> get data {
    return $DataModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DataWrapperImplCopyWith<$Res>
    implements $DataWrapperCopyWith<$Res> {
  factory _$$DataWrapperImplCopyWith(
          _$DataWrapperImpl value, $Res Function(_$DataWrapperImpl) then) =
      __$$DataWrapperImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'data') DataModel data});

  @override
  $DataModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$DataWrapperImplCopyWithImpl<$Res>
    extends _$DataWrapperCopyWithImpl<$Res, _$DataWrapperImpl>
    implements _$$DataWrapperImplCopyWith<$Res> {
  __$$DataWrapperImplCopyWithImpl(
      _$DataWrapperImpl _value, $Res Function(_$DataWrapperImpl) _then)
      : super(_value, _then);

  /// Create a copy of DataWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$DataWrapperImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as DataModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DataWrapperImpl implements _DataWrapper {
  const _$DataWrapperImpl({@JsonKey(name: 'data') required this.data});

  factory _$DataWrapperImpl.fromJson(Map<String, dynamic> json) =>
      _$$DataWrapperImplFromJson(json);

  @override
  @JsonKey(name: 'data')
  final DataModel data;

  @override
  String toString() {
    return 'DataWrapper(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataWrapperImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of DataWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DataWrapperImplCopyWith<_$DataWrapperImpl> get copyWith =>
      __$$DataWrapperImplCopyWithImpl<_$DataWrapperImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DataWrapperImplToJson(
      this,
    );
  }
}

abstract class _DataWrapper implements DataWrapper {
  const factory _DataWrapper(
          {@JsonKey(name: 'data') required final DataModel data}) =
      _$DataWrapperImpl;

  factory _DataWrapper.fromJson(Map<String, dynamic> json) =
      _$DataWrapperImpl.fromJson;

  @override
  @JsonKey(name: 'data')
  DataModel get data;

  /// Create a copy of DataWrapper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DataWrapperImplCopyWith<_$DataWrapperImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
