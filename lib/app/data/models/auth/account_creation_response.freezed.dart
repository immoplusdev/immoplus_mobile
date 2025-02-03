// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_creation_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AccountCreationResponse _$AccountCreationResponseFromJson(
    Map<String, dynamic> json) {
  return _AccountCreationResponse.fromJson(json);
}

/// @nodoc
mixin _$AccountCreationResponse {
  @JsonKey(name: 'data')
  DataModel get data => throw _privateConstructorUsedError;

  /// Serializes this AccountCreationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountCreationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountCreationResponseCopyWith<AccountCreationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCreationResponseCopyWith<$Res> {
  factory $AccountCreationResponseCopyWith(AccountCreationResponse value,
          $Res Function(AccountCreationResponse) then) =
      _$AccountCreationResponseCopyWithImpl<$Res, AccountCreationResponse>;
  @useResult
  $Res call({@JsonKey(name: 'data') DataModel data});

  $DataModelCopyWith<$Res> get data;
}

/// @nodoc
class _$AccountCreationResponseCopyWithImpl<$Res,
        $Val extends AccountCreationResponse>
    implements $AccountCreationResponseCopyWith<$Res> {
  _$AccountCreationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountCreationResponse
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

  /// Create a copy of AccountCreationResponse
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
abstract class _$$AccountCreationResponseImplCopyWith<$Res>
    implements $AccountCreationResponseCopyWith<$Res> {
  factory _$$AccountCreationResponseImplCopyWith(
          _$AccountCreationResponseImpl value,
          $Res Function(_$AccountCreationResponseImpl) then) =
      __$$AccountCreationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'data') DataModel data});

  @override
  $DataModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$AccountCreationResponseImplCopyWithImpl<$Res>
    extends _$AccountCreationResponseCopyWithImpl<$Res,
        _$AccountCreationResponseImpl>
    implements _$$AccountCreationResponseImplCopyWith<$Res> {
  __$$AccountCreationResponseImplCopyWithImpl(
      _$AccountCreationResponseImpl _value,
      $Res Function(_$AccountCreationResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountCreationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$AccountCreationResponseImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as DataModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountCreationResponseImpl implements _AccountCreationResponse {
  const _$AccountCreationResponseImpl(
      {@JsonKey(name: 'data') required this.data});

  factory _$AccountCreationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountCreationResponseImplFromJson(json);

  @override
  @JsonKey(name: 'data')
  final DataModel data;

  @override
  String toString() {
    return 'AccountCreationResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountCreationResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of AccountCreationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountCreationResponseImplCopyWith<_$AccountCreationResponseImpl>
      get copyWith => __$$AccountCreationResponseImplCopyWithImpl<
          _$AccountCreationResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountCreationResponseImplToJson(
      this,
    );
  }
}

abstract class _AccountCreationResponse implements AccountCreationResponse {
  const factory _AccountCreationResponse(
          {@JsonKey(name: 'data') required final DataModel data}) =
      _$AccountCreationResponseImpl;

  factory _AccountCreationResponse.fromJson(Map<String, dynamic> json) =
      _$AccountCreationResponseImpl.fromJson;

  @override
  @JsonKey(name: 'data')
  DataModel get data;

  /// Create a copy of AccountCreationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountCreationResponseImplCopyWith<_$AccountCreationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
