// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proprietaire_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProprietaireModel _$ProprietaireModelFromJson(Map<String, dynamic> json) {
  return _ProprietaireModel.fromJson(json);
}

/// @nodoc
mixin _$ProprietaireModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this ProprietaireModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProprietaireModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProprietaireModelCopyWith<ProprietaireModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProprietaireModelCopyWith<$Res> {
  factory $ProprietaireModelCopyWith(
          ProprietaireModel value, $Res Function(ProprietaireModel) then) =
      _$ProprietaireModelCopyWithImpl<$Res, ProprietaireModel>;
  @useResult
  $Res call(
      {String id,
      String email,
      String firstName,
      String lastName,
      String phoneNumber});
}

/// @nodoc
class _$ProprietaireModelCopyWithImpl<$Res, $Val extends ProprietaireModel>
    implements $ProprietaireModelCopyWith<$Res> {
  _$ProprietaireModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProprietaireModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phoneNumber = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProprietaireModelImplCopyWith<$Res>
    implements $ProprietaireModelCopyWith<$Res> {
  factory _$$ProprietaireModelImplCopyWith(_$ProprietaireModelImpl value,
          $Res Function(_$ProprietaireModelImpl) then) =
      __$$ProprietaireModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String firstName,
      String lastName,
      String phoneNumber});
}

/// @nodoc
class __$$ProprietaireModelImplCopyWithImpl<$Res>
    extends _$ProprietaireModelCopyWithImpl<$Res, _$ProprietaireModelImpl>
    implements _$$ProprietaireModelImplCopyWith<$Res> {
  __$$ProprietaireModelImplCopyWithImpl(_$ProprietaireModelImpl _value,
      $Res Function(_$ProprietaireModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProprietaireModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phoneNumber = null,
  }) {
    return _then(_$ProprietaireModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProprietaireModelImpl implements _ProprietaireModel {
  const _$ProprietaireModelImpl(
      {this.id = '',
      this.email = '',
      this.firstName = '',
      this.lastName = '',
      this.phoneNumber = ''});

  factory _$ProprietaireModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProprietaireModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String firstName;
  @override
  @JsonKey()
  final String lastName;
  @override
  @JsonKey()
  final String phoneNumber;

  @override
  String toString() {
    return 'ProprietaireModel(id: $id, email: $email, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProprietaireModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, email, firstName, lastName, phoneNumber);

  /// Create a copy of ProprietaireModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProprietaireModelImplCopyWith<_$ProprietaireModelImpl> get copyWith =>
      __$$ProprietaireModelImplCopyWithImpl<_$ProprietaireModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProprietaireModelImplToJson(
      this,
    );
  }
}

abstract class _ProprietaireModel implements ProprietaireModel {
  const factory _ProprietaireModel(
      {final String id,
      final String email,
      final String firstName,
      final String lastName,
      final String phoneNumber}) = _$ProprietaireModelImpl;

  factory _ProprietaireModel.fromJson(Map<String, dynamic> json) =
      _$ProprietaireModelImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get phoneNumber;

  /// Create a copy of ProprietaireModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProprietaireModelImplCopyWith<_$ProprietaireModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
