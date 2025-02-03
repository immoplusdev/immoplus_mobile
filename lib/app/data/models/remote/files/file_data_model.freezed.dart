// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FileDataModel _$FileDataModelFromJson(Map<String, dynamic> json) {
  return _FileDataModel.fromJson(json);
}

/// @nodoc
mixin _$FileDataModel {
  InnerFileDataModel? get data => throw _privateConstructorUsedError;

  /// Serializes this FileDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileDataModelCopyWith<FileDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileDataModelCopyWith<$Res> {
  factory $FileDataModelCopyWith(
          FileDataModel value, $Res Function(FileDataModel) then) =
      _$FileDataModelCopyWithImpl<$Res, FileDataModel>;
  @useResult
  $Res call({InnerFileDataModel? data});

  $InnerFileDataModelCopyWith<$Res>? get data;
}

/// @nodoc
class _$FileDataModelCopyWithImpl<$Res, $Val extends FileDataModel>
    implements $FileDataModelCopyWith<$Res> {
  _$FileDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileDataModel
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
              as InnerFileDataModel?,
    ) as $Val);
  }

  /// Create a copy of FileDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InnerFileDataModelCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $InnerFileDataModelCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FileDataModelImplCopyWith<$Res>
    implements $FileDataModelCopyWith<$Res> {
  factory _$$FileDataModelImplCopyWith(
          _$FileDataModelImpl value, $Res Function(_$FileDataModelImpl) then) =
      __$$FileDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({InnerFileDataModel? data});

  @override
  $InnerFileDataModelCopyWith<$Res>? get data;
}

/// @nodoc
class __$$FileDataModelImplCopyWithImpl<$Res>
    extends _$FileDataModelCopyWithImpl<$Res, _$FileDataModelImpl>
    implements _$$FileDataModelImplCopyWith<$Res> {
  __$$FileDataModelImplCopyWithImpl(
      _$FileDataModelImpl _value, $Res Function(_$FileDataModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$FileDataModelImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as InnerFileDataModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileDataModelImpl implements _FileDataModel {
  const _$FileDataModelImpl({this.data});

  factory _$FileDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileDataModelImplFromJson(json);

  @override
  final InnerFileDataModel? data;

  @override
  String toString() {
    return 'FileDataModel(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileDataModelImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of FileDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileDataModelImplCopyWith<_$FileDataModelImpl> get copyWith =>
      __$$FileDataModelImplCopyWithImpl<_$FileDataModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileDataModelImplToJson(
      this,
    );
  }
}

abstract class _FileDataModel implements FileDataModel {
  const factory _FileDataModel({final InnerFileDataModel? data}) =
      _$FileDataModelImpl;

  factory _FileDataModel.fromJson(Map<String, dynamic> json) =
      _$FileDataModelImpl.fromJson;

  @override
  InnerFileDataModel? get data;

  /// Create a copy of FileDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileDataModelImplCopyWith<_$FileDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
