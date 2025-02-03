// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  String? get language => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get otp => throw _privateConstructorUsedError;
  String? get otpExpiration => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get commune => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get address2 => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  bool? get identityVerified => throw _privateConstructorUsedError;
  bool? get emailVerified => throw _privateConstructorUsedError;
  bool? get phoneNumberVerified => throw _privateConstructorUsedError;
  int? get authLoginAttempts => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  RoleModel get role => throw _privateConstructorUsedError;
  AdditionalDataModel get additionalData => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      String? firstName,
      String? lastName,
      String? email,
      String? password,
      String? language,
      String? phoneNumber,
      String? otp,
      String? otpExpiration,
      String? country,
      String? state,
      String? city,
      String? commune,
      String? address,
      String? address2,
      String? currency,
      bool? identityVerified,
      bool? emailVerified,
      bool? phoneNumberVerified,
      int? authLoginAttempts,
      String? status,
      String? createdAt,
      String? updatedAt,
      String? avatar,
      RoleModel role,
      AdditionalDataModel additionalData});

  $RoleModelCopyWith<$Res> get role;
  $AdditionalDataModelCopyWith<$Res> get additionalData;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? language = freezed,
    Object? phoneNumber = freezed,
    Object? otp = freezed,
    Object? otpExpiration = freezed,
    Object? country = freezed,
    Object? state = freezed,
    Object? city = freezed,
    Object? commune = freezed,
    Object? address = freezed,
    Object? address2 = freezed,
    Object? currency = freezed,
    Object? identityVerified = freezed,
    Object? emailVerified = freezed,
    Object? phoneNumberVerified = freezed,
    Object? authLoginAttempts = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? avatar = freezed,
    Object? role = null,
    Object? additionalData = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      otp: freezed == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String?,
      otpExpiration: freezed == otpExpiration
          ? _value.otpExpiration
          : otpExpiration // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      commune: freezed == commune
          ? _value.commune
          : commune // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      address2: freezed == address2
          ? _value.address2
          : address2 // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      identityVerified: freezed == identityVerified
          ? _value.identityVerified
          : identityVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      emailVerified: freezed == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      phoneNumberVerified: freezed == phoneNumberVerified
          ? _value.phoneNumberVerified
          : phoneNumberVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      authLoginAttempts: freezed == authLoginAttempts
          ? _value.authLoginAttempts
          : authLoginAttempts // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as RoleModel,
      additionalData: null == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as AdditionalDataModel,
    ) as $Val);
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RoleModelCopyWith<$Res> get role {
    return $RoleModelCopyWith<$Res>(_value.role, (value) {
      return _then(_value.copyWith(role: value) as $Val);
    });
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdditionalDataModelCopyWith<$Res> get additionalData {
    return $AdditionalDataModelCopyWith<$Res>(_value.additionalData, (value) {
      return _then(_value.copyWith(additionalData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      String? firstName,
      String? lastName,
      String? email,
      String? password,
      String? language,
      String? phoneNumber,
      String? otp,
      String? otpExpiration,
      String? country,
      String? state,
      String? city,
      String? commune,
      String? address,
      String? address2,
      String? currency,
      bool? identityVerified,
      bool? emailVerified,
      bool? phoneNumberVerified,
      int? authLoginAttempts,
      String? status,
      String? createdAt,
      String? updatedAt,
      String? avatar,
      RoleModel role,
      AdditionalDataModel additionalData});

  @override
  $RoleModelCopyWith<$Res> get role;
  @override
  $AdditionalDataModelCopyWith<$Res> get additionalData;
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? language = freezed,
    Object? phoneNumber = freezed,
    Object? otp = freezed,
    Object? otpExpiration = freezed,
    Object? country = freezed,
    Object? state = freezed,
    Object? city = freezed,
    Object? commune = freezed,
    Object? address = freezed,
    Object? address2 = freezed,
    Object? currency = freezed,
    Object? identityVerified = freezed,
    Object? emailVerified = freezed,
    Object? phoneNumberVerified = freezed,
    Object? authLoginAttempts = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? avatar = freezed,
    Object? role = null,
    Object? additionalData = null,
  }) {
    return _then(_$UserModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      otp: freezed == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String?,
      otpExpiration: freezed == otpExpiration
          ? _value.otpExpiration
          : otpExpiration // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      commune: freezed == commune
          ? _value.commune
          : commune // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      address2: freezed == address2
          ? _value.address2
          : address2 // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      identityVerified: freezed == identityVerified
          ? _value.identityVerified
          : identityVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      emailVerified: freezed == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      phoneNumberVerified: freezed == phoneNumberVerified
          ? _value.phoneNumberVerified
          : phoneNumberVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      authLoginAttempts: freezed == authLoginAttempts
          ? _value.authLoginAttempts
          : authLoginAttempts // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as RoleModel,
      additionalData: null == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as AdditionalDataModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {@JsonKey(name: 'id') this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.language,
      this.phoneNumber,
      this.otp,
      this.otpExpiration,
      this.country,
      this.state,
      this.city,
      this.commune,
      this.address,
      this.address2,
      this.currency,
      this.identityVerified,
      this.emailVerified,
      this.phoneNumberVerified,
      this.authLoginAttempts,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.avatar,
      required this.role,
      required this.additionalData});

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String? id;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? email;
  @override
  final String? password;
  @override
  final String? language;
  @override
  final String? phoneNumber;
  @override
  final String? otp;
  @override
  final String? otpExpiration;
  @override
  final String? country;
  @override
  final String? state;
  @override
  final String? city;
  @override
  final String? commune;
  @override
  final String? address;
  @override
  final String? address2;
  @override
  final String? currency;
  @override
  final bool? identityVerified;
  @override
  final bool? emailVerified;
  @override
  final bool? phoneNumberVerified;
  @override
  final int? authLoginAttempts;
  @override
  final String? status;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final String? avatar;
  @override
  final RoleModel role;
  @override
  final AdditionalDataModel additionalData;

  @override
  String toString() {
    return 'UserModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, password: $password, language: $language, phoneNumber: $phoneNumber, otp: $otp, otpExpiration: $otpExpiration, country: $country, state: $state, city: $city, commune: $commune, address: $address, address2: $address2, currency: $currency, identityVerified: $identityVerified, emailVerified: $emailVerified, phoneNumberVerified: $phoneNumberVerified, authLoginAttempts: $authLoginAttempts, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, avatar: $avatar, role: $role, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.otpExpiration, otpExpiration) ||
                other.otpExpiration == otpExpiration) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.commune, commune) || other.commune == commune) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.address2, address2) ||
                other.address2 == address2) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.identityVerified, identityVerified) ||
                other.identityVerified == identityVerified) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.phoneNumberVerified, phoneNumberVerified) ||
                other.phoneNumberVerified == phoneNumberVerified) &&
            (identical(other.authLoginAttempts, authLoginAttempts) ||
                other.authLoginAttempts == authLoginAttempts) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.additionalData, additionalData) ||
                other.additionalData == additionalData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        firstName,
        lastName,
        email,
        password,
        language,
        phoneNumber,
        otp,
        otpExpiration,
        country,
        state,
        city,
        commune,
        address,
        address2,
        currency,
        identityVerified,
        emailVerified,
        phoneNumberVerified,
        authLoginAttempts,
        status,
        createdAt,
        updatedAt,
        avatar,
        role,
        additionalData
      ]);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {@JsonKey(name: 'id') final String? id,
      final String? firstName,
      final String? lastName,
      final String? email,
      final String? password,
      final String? language,
      final String? phoneNumber,
      final String? otp,
      final String? otpExpiration,
      final String? country,
      final String? state,
      final String? city,
      final String? commune,
      final String? address,
      final String? address2,
      final String? currency,
      final bool? identityVerified,
      final bool? emailVerified,
      final bool? phoneNumberVerified,
      final int? authLoginAttempts,
      final String? status,
      final String? createdAt,
      final String? updatedAt,
      final String? avatar,
      required final RoleModel role,
      required final AdditionalDataModel additionalData}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String? get id;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get email;
  @override
  String? get password;
  @override
  String? get language;
  @override
  String? get phoneNumber;
  @override
  String? get otp;
  @override
  String? get otpExpiration;
  @override
  String? get country;
  @override
  String? get state;
  @override
  String? get city;
  @override
  String? get commune;
  @override
  String? get address;
  @override
  String? get address2;
  @override
  String? get currency;
  @override
  bool? get identityVerified;
  @override
  bool? get emailVerified;
  @override
  bool? get phoneNumberVerified;
  @override
  int? get authLoginAttempts;
  @override
  String? get status;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;
  @override
  String? get avatar;
  @override
  RoleModel get role;
  @override
  AdditionalDataModel get additionalData;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
