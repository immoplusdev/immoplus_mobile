// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateUserResponseModel _$UpdateUserResponseModelFromJson(
    Map<String, dynamic> json) {
  return _UpdateUserResponseModel.fromJson(json);
}

/// @nodoc
mixin _$UpdateUserResponseModel {
  UserModel get data => throw _privateConstructorUsedError;

  /// Serializes this UpdateUserResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateUserResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateUserResponseModelCopyWith<UpdateUserResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateUserResponseModelCopyWith<$Res> {
  factory $UpdateUserResponseModelCopyWith(UpdateUserResponseModel value,
          $Res Function(UpdateUserResponseModel) then) =
      _$UpdateUserResponseModelCopyWithImpl<$Res, UpdateUserResponseModel>;
  @useResult
  $Res call({UserModel data});

  $UserModelCopyWith<$Res> get data;
}

/// @nodoc
class _$UpdateUserResponseModelCopyWithImpl<$Res,
        $Val extends UpdateUserResponseModel>
    implements $UpdateUserResponseModelCopyWith<$Res> {
  _$UpdateUserResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateUserResponseModel
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
              as UserModel,
    ) as $Val);
  }

  /// Create a copy of UpdateUserResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get data {
    return $UserModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UpdateUserResponseModelImplCopyWith<$Res>
    implements $UpdateUserResponseModelCopyWith<$Res> {
  factory _$$UpdateUserResponseModelImplCopyWith(
          _$UpdateUserResponseModelImpl value,
          $Res Function(_$UpdateUserResponseModelImpl) then) =
      __$$UpdateUserResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserModel data});

  @override
  $UserModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$UpdateUserResponseModelImplCopyWithImpl<$Res>
    extends _$UpdateUserResponseModelCopyWithImpl<$Res,
        _$UpdateUserResponseModelImpl>
    implements _$$UpdateUserResponseModelImplCopyWith<$Res> {
  __$$UpdateUserResponseModelImplCopyWithImpl(
      _$UpdateUserResponseModelImpl _value,
      $Res Function(_$UpdateUserResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateUserResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$UpdateUserResponseModelImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as UserModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateUserResponseModelImpl implements _UpdateUserResponseModel {
  _$UpdateUserResponseModelImpl({required this.data});

  factory _$UpdateUserResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateUserResponseModelImplFromJson(json);

  @override
  final UserModel data;

  @override
  String toString() {
    return 'UpdateUserResponseModel(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserResponseModelImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of UpdateUserResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserResponseModelImplCopyWith<_$UpdateUserResponseModelImpl>
      get copyWith => __$$UpdateUserResponseModelImplCopyWithImpl<
          _$UpdateUserResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateUserResponseModelImplToJson(
      this,
    );
  }
}

abstract class _UpdateUserResponseModel implements UpdateUserResponseModel {
  factory _UpdateUserResponseModel({required final UserModel data}) =
      _$UpdateUserResponseModelImpl;

  factory _UpdateUserResponseModel.fromJson(Map<String, dynamic> json) =
      _$UpdateUserResponseModelImpl.fromJson;

  @override
  UserModel get data;

  /// Create a copy of UpdateUserResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateUserResponseModelImplCopyWith<_$UpdateUserResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
