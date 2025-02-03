// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'files_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FileResponseModel _$FileResponseModelFromJson(Map<String, dynamic> json) {
  return _FileResponseModel.fromJson(json);
}

/// @nodoc
mixin _$FileResponseModel {
  @JsonKey(name: 'data')
  FileDataModel? get data => throw _privateConstructorUsedError;

  /// Serializes this FileResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileResponseModelCopyWith<FileResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileResponseModelCopyWith<$Res> {
  factory $FileResponseModelCopyWith(
          FileResponseModel value, $Res Function(FileResponseModel) then) =
      _$FileResponseModelCopyWithImpl<$Res, FileResponseModel>;
  @useResult
  $Res call({@JsonKey(name: 'data') FileDataModel? data});

  $FileDataModelCopyWith<$Res>? get data;
}

/// @nodoc
class _$FileResponseModelCopyWithImpl<$Res, $Val extends FileResponseModel>
    implements $FileResponseModelCopyWith<$Res> {
  _$FileResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileResponseModel
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
              as FileDataModel?,
    ) as $Val);
  }

  /// Create a copy of FileResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FileDataModelCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $FileDataModelCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FileResponseModelImplCopyWith<$Res>
    implements $FileResponseModelCopyWith<$Res> {
  factory _$$FileResponseModelImplCopyWith(_$FileResponseModelImpl value,
          $Res Function(_$FileResponseModelImpl) then) =
      __$$FileResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'data') FileDataModel? data});

  @override
  $FileDataModelCopyWith<$Res>? get data;
}

/// @nodoc
class __$$FileResponseModelImplCopyWithImpl<$Res>
    extends _$FileResponseModelCopyWithImpl<$Res, _$FileResponseModelImpl>
    implements _$$FileResponseModelImplCopyWith<$Res> {
  __$$FileResponseModelImplCopyWithImpl(_$FileResponseModelImpl _value,
      $Res Function(_$FileResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$FileResponseModelImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as FileDataModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileResponseModelImpl implements _FileResponseModel {
  const _$FileResponseModelImpl({@JsonKey(name: 'data') this.data});

  factory _$FileResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileResponseModelImplFromJson(json);

  @override
  @JsonKey(name: 'data')
  final FileDataModel? data;

  @override
  String toString() {
    return 'FileResponseModel(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileResponseModelImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of FileResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileResponseModelImplCopyWith<_$FileResponseModelImpl> get copyWith =>
      __$$FileResponseModelImplCopyWithImpl<_$FileResponseModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileResponseModelImplToJson(
      this,
    );
  }
}

abstract class _FileResponseModel implements FileResponseModel {
  const factory _FileResponseModel(
          {@JsonKey(name: 'data') final FileDataModel? data}) =
      _$FileResponseModelImpl;

  factory _FileResponseModel.fromJson(Map<String, dynamic> json) =
      _$FileResponseModelImpl.fromJson;

  @override
  @JsonKey(name: 'data')
  FileDataModel? get data;

  /// Create a copy of FileResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileResponseModelImplCopyWith<_$FileResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
