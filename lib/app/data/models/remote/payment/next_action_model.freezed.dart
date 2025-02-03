// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'next_action_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NextActionData _$NextActionDataFromJson(Map<String, dynamic> json) {
  return _NextActionData.fromJson(json);
}

/// @nodoc
mixin _$NextActionData {
  String get url => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;

  /// Serializes this NextActionData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NextActionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NextActionDataCopyWith<NextActionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NextActionDataCopyWith<$Res> {
  factory $NextActionDataCopyWith(
          NextActionData value, $Res Function(NextActionData) then) =
      _$NextActionDataCopyWithImpl<$Res, NextActionData>;
  @useResult
  $Res call({String url, String method});
}

/// @nodoc
class _$NextActionDataCopyWithImpl<$Res, $Val extends NextActionData>
    implements $NextActionDataCopyWith<$Res> {
  _$NextActionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NextActionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? method = null,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NextActionDataImplCopyWith<$Res>
    implements $NextActionDataCopyWith<$Res> {
  factory _$$NextActionDataImplCopyWith(_$NextActionDataImpl value,
          $Res Function(_$NextActionDataImpl) then) =
      __$$NextActionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, String method});
}

/// @nodoc
class __$$NextActionDataImplCopyWithImpl<$Res>
    extends _$NextActionDataCopyWithImpl<$Res, _$NextActionDataImpl>
    implements _$$NextActionDataImplCopyWith<$Res> {
  __$$NextActionDataImplCopyWithImpl(
      _$NextActionDataImpl _value, $Res Function(_$NextActionDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of NextActionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? method = null,
  }) {
    return _then(_$NextActionDataImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NextActionDataImpl implements _NextActionData {
  const _$NextActionDataImpl({this.url = '', this.method = ''});

  factory _$NextActionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$NextActionDataImplFromJson(json);

  @override
  @JsonKey()
  final String url;
  @override
  @JsonKey()
  final String method;

  @override
  String toString() {
    return 'NextActionData(url: $url, method: $method)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NextActionDataImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.method, method) || other.method == method));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, method);

  /// Create a copy of NextActionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NextActionDataImplCopyWith<_$NextActionDataImpl> get copyWith =>
      __$$NextActionDataImplCopyWithImpl<_$NextActionDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NextActionDataImplToJson(
      this,
    );
  }
}

abstract class _NextActionData implements NextActionData {
  const factory _NextActionData({final String url, final String method}) =
      _$NextActionDataImpl;

  factory _NextActionData.fromJson(Map<String, dynamic> json) =
      _$NextActionDataImpl.fromJson;

  @override
  String get url;
  @override
  String get method;

  /// Create a copy of NextActionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NextActionDataImplCopyWith<_$NextActionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Hub2NextAction _$Hub2NextActionFromJson(Map<String, dynamic> json) {
  return _Hub2NextAction.fromJson(json);
}

/// @nodoc
mixin _$Hub2NextAction {
  String get type => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  NextActionData get data => throw _privateConstructorUsedError;

  /// Serializes this Hub2NextAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Hub2NextAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $Hub2NextActionCopyWith<Hub2NextAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Hub2NextActionCopyWith<$Res> {
  factory $Hub2NextActionCopyWith(
          Hub2NextAction value, $Res Function(Hub2NextAction) then) =
      _$Hub2NextActionCopyWithImpl<$Res, Hub2NextAction>;
  @useResult
  $Res call({String type, String message, NextActionData data});

  $NextActionDataCopyWith<$Res> get data;
}

/// @nodoc
class _$Hub2NextActionCopyWithImpl<$Res, $Val extends Hub2NextAction>
    implements $Hub2NextActionCopyWith<$Res> {
  _$Hub2NextActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Hub2NextAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? message = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as NextActionData,
    ) as $Val);
  }

  /// Create a copy of Hub2NextAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NextActionDataCopyWith<$Res> get data {
    return $NextActionDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$Hub2NextActionImplCopyWith<$Res>
    implements $Hub2NextActionCopyWith<$Res> {
  factory _$$Hub2NextActionImplCopyWith(_$Hub2NextActionImpl value,
          $Res Function(_$Hub2NextActionImpl) then) =
      __$$Hub2NextActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String message, NextActionData data});

  @override
  $NextActionDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$Hub2NextActionImplCopyWithImpl<$Res>
    extends _$Hub2NextActionCopyWithImpl<$Res, _$Hub2NextActionImpl>
    implements _$$Hub2NextActionImplCopyWith<$Res> {
  __$$Hub2NextActionImplCopyWithImpl(
      _$Hub2NextActionImpl _value, $Res Function(_$Hub2NextActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Hub2NextAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? message = null,
    Object? data = null,
  }) {
    return _then(_$Hub2NextActionImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as NextActionData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$Hub2NextActionImpl implements _Hub2NextAction {
  const _$Hub2NextActionImpl(
      {this.type = '', this.message = '', this.data = const NextActionData()});

  factory _$Hub2NextActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$Hub2NextActionImplFromJson(json);

  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final NextActionData data;

  @override
  String toString() {
    return 'Hub2NextAction(type: $type, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Hub2NextActionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, message, data);

  /// Create a copy of Hub2NextAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Hub2NextActionImplCopyWith<_$Hub2NextActionImpl> get copyWith =>
      __$$Hub2NextActionImplCopyWithImpl<_$Hub2NextActionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$Hub2NextActionImplToJson(
      this,
    );
  }
}

abstract class _Hub2NextAction implements Hub2NextAction {
  const factory _Hub2NextAction(
      {final String type,
      final String message,
      final NextActionData data}) = _$Hub2NextActionImpl;

  factory _Hub2NextAction.fromJson(Map<String, dynamic> json) =
      _$Hub2NextActionImpl.fromJson;

  @override
  String get type;
  @override
  String get message;
  @override
  NextActionData get data;

  /// Create a copy of Hub2NextAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Hub2NextActionImplCopyWith<_$Hub2NextActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
