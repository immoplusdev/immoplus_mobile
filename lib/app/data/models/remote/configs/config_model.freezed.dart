// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConfigModel _$ConfigModelFromJson(Map<String, dynamic> json) {
  return _ConfigModel.fromJson(json);
}

/// @nodoc
mixin _$ConfigModel {
  ConfigData? get data => throw _privateConstructorUsedError;

  /// Serializes this ConfigModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfigModelCopyWith<ConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigModelCopyWith<$Res> {
  factory $ConfigModelCopyWith(
          ConfigModel value, $Res Function(ConfigModel) then) =
      _$ConfigModelCopyWithImpl<$Res, ConfigModel>;
  @useResult
  $Res call({ConfigData? data});

  $ConfigDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$ConfigModelCopyWithImpl<$Res, $Val extends ConfigModel>
    implements $ConfigModelCopyWith<$Res> {
  _$ConfigModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfigModel
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
              as ConfigData?,
    ) as $Val);
  }

  /// Create a copy of ConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConfigDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $ConfigDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConfigModelImplCopyWith<$Res>
    implements $ConfigModelCopyWith<$Res> {
  factory _$$ConfigModelImplCopyWith(
          _$ConfigModelImpl value, $Res Function(_$ConfigModelImpl) then) =
      __$$ConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ConfigData? data});

  @override
  $ConfigDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$ConfigModelImplCopyWithImpl<$Res>
    extends _$ConfigModelCopyWithImpl<$Res, _$ConfigModelImpl>
    implements _$$ConfigModelImplCopyWith<$Res> {
  __$$ConfigModelImplCopyWithImpl(
      _$ConfigModelImpl _value, $Res Function(_$ConfigModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$ConfigModelImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ConfigData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfigModelImpl implements _ConfigModel {
  _$ConfigModelImpl({this.data});

  factory _$ConfigModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfigModelImplFromJson(json);

  @override
  final ConfigData? data;

  @override
  String toString() {
    return 'ConfigModel(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigModelImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of ConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigModelImplCopyWith<_$ConfigModelImpl> get copyWith =>
      __$$ConfigModelImplCopyWithImpl<_$ConfigModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfigModelImplToJson(
      this,
    );
  }
}

abstract class _ConfigModel implements ConfigModel {
  factory _ConfigModel({final ConfigData? data}) = _$ConfigModelImpl;

  factory _ConfigModel.fromJson(Map<String, dynamic> json) =
      _$ConfigModelImpl.fromJson;

  @override
  ConfigData? get data;

  /// Create a copy of ConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigModelImplCopyWith<_$ConfigModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConfigData _$ConfigDataFromJson(Map<String, dynamic> json) {
  return _ConfigData.fromJson(json);
}

/// @nodoc
mixin _$ConfigData {
  String get id => throw _privateConstructorUsedError;
  String get websiteUrl => throw _privateConstructorUsedError;
  int get normalVisitPrice => throw _privateConstructorUsedError;
  int get expressVisitPrice => throw _privateConstructorUsedError;
  int get pourcentageCommissionReservation =>
      throw _privateConstructorUsedError;
  String get projectName => throw _privateConstructorUsedError;
  String get projectUrl => throw _privateConstructorUsedError;
  String get smsSenderName => throw _privateConstructorUsedError;
  double get proximityRadius => throw _privateConstructorUsedError;
  double get standardShippingPrice => throw _privateConstructorUsedError;
  double get flashShippingPrice => throw _privateConstructorUsedError;
  String get contactEmail => throw _privateConstructorUsedError;
  String get contactPhoneNumber => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  List<dynamic> get categories => throw _privateConstructorUsedError;
  List<dynamic> get categoryPaymentTypes => throw _privateConstructorUsedError;
  List<dynamic> get defaultStatus => throw _privateConstructorUsedError;
  List<dynamic> get galleryGroups => throw _privateConstructorUsedError;
  List<dynamic> get languages => throw _privateConstructorUsedError;
  List<dynamic> get orderPaymentTypes => throw _privateConstructorUsedError;
  List<dynamic> get paymentStatus => throw _privateConstructorUsedError;
  List<dynamic> get productTypes => throw _privateConstructorUsedError;
  List<dynamic> get servicePaymentTypes => throw _privateConstructorUsedError;
  List<dynamic> get serviceStatus => throw _privateConstructorUsedError;
  List<dynamic> get shippingStatus => throw _privateConstructorUsedError;
  List<dynamic> get shippingTypes => throw _privateConstructorUsedError;
  List<dynamic> get visitPaymentTypes => throw _privateConstructorUsedError;
  List<TypesResidence> get typesResidence => throw _privateConstructorUsedError;
  List<TypesDemandeVisite> get typesDemandeVisite =>
      throw _privateConstructorUsedError;

  /// Serializes this ConfigData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConfigData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfigDataCopyWith<ConfigData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigDataCopyWith<$Res> {
  factory $ConfigDataCopyWith(
          ConfigData value, $Res Function(ConfigData) then) =
      _$ConfigDataCopyWithImpl<$Res, ConfigData>;
  @useResult
  $Res call(
      {String id,
      String websiteUrl,
      int normalVisitPrice,
      int expressVisitPrice,
      int pourcentageCommissionReservation,
      String projectName,
      String projectUrl,
      String smsSenderName,
      double proximityRadius,
      double standardShippingPrice,
      double flashShippingPrice,
      String contactEmail,
      String contactPhoneNumber,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      List<dynamic> categories,
      List<dynamic> categoryPaymentTypes,
      List<dynamic> defaultStatus,
      List<dynamic> galleryGroups,
      List<dynamic> languages,
      List<dynamic> orderPaymentTypes,
      List<dynamic> paymentStatus,
      List<dynamic> productTypes,
      List<dynamic> servicePaymentTypes,
      List<dynamic> serviceStatus,
      List<dynamic> shippingStatus,
      List<dynamic> shippingTypes,
      List<dynamic> visitPaymentTypes,
      List<TypesResidence> typesResidence,
      List<TypesDemandeVisite> typesDemandeVisite});
}

/// @nodoc
class _$ConfigDataCopyWithImpl<$Res, $Val extends ConfigData>
    implements $ConfigDataCopyWith<$Res> {
  _$ConfigDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfigData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? websiteUrl = null,
    Object? normalVisitPrice = null,
    Object? expressVisitPrice = null,
    Object? pourcentageCommissionReservation = null,
    Object? projectName = null,
    Object? projectUrl = null,
    Object? smsSenderName = null,
    Object? proximityRadius = null,
    Object? standardShippingPrice = null,
    Object? flashShippingPrice = null,
    Object? contactEmail = null,
    Object? contactPhoneNumber = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? categories = null,
    Object? categoryPaymentTypes = null,
    Object? defaultStatus = null,
    Object? galleryGroups = null,
    Object? languages = null,
    Object? orderPaymentTypes = null,
    Object? paymentStatus = null,
    Object? productTypes = null,
    Object? servicePaymentTypes = null,
    Object? serviceStatus = null,
    Object? shippingStatus = null,
    Object? shippingTypes = null,
    Object? visitPaymentTypes = null,
    Object? typesResidence = null,
    Object? typesDemandeVisite = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      websiteUrl: null == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String,
      normalVisitPrice: null == normalVisitPrice
          ? _value.normalVisitPrice
          : normalVisitPrice // ignore: cast_nullable_to_non_nullable
              as int,
      expressVisitPrice: null == expressVisitPrice
          ? _value.expressVisitPrice
          : expressVisitPrice // ignore: cast_nullable_to_non_nullable
              as int,
      pourcentageCommissionReservation: null == pourcentageCommissionReservation
          ? _value.pourcentageCommissionReservation
          : pourcentageCommissionReservation // ignore: cast_nullable_to_non_nullable
              as int,
      projectName: null == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String,
      projectUrl: null == projectUrl
          ? _value.projectUrl
          : projectUrl // ignore: cast_nullable_to_non_nullable
              as String,
      smsSenderName: null == smsSenderName
          ? _value.smsSenderName
          : smsSenderName // ignore: cast_nullable_to_non_nullable
              as String,
      proximityRadius: null == proximityRadius
          ? _value.proximityRadius
          : proximityRadius // ignore: cast_nullable_to_non_nullable
              as double,
      standardShippingPrice: null == standardShippingPrice
          ? _value.standardShippingPrice
          : standardShippingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      flashShippingPrice: null == flashShippingPrice
          ? _value.flashShippingPrice
          : flashShippingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      contactEmail: null == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String,
      contactPhoneNumber: null == contactPhoneNumber
          ? _value.contactPhoneNumber
          : contactPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      categoryPaymentTypes: null == categoryPaymentTypes
          ? _value.categoryPaymentTypes
          : categoryPaymentTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      defaultStatus: null == defaultStatus
          ? _value.defaultStatus
          : defaultStatus // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      galleryGroups: null == galleryGroups
          ? _value.galleryGroups
          : galleryGroups // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      languages: null == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      orderPaymentTypes: null == orderPaymentTypes
          ? _value.orderPaymentTypes
          : orderPaymentTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      productTypes: null == productTypes
          ? _value.productTypes
          : productTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      servicePaymentTypes: null == servicePaymentTypes
          ? _value.servicePaymentTypes
          : servicePaymentTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      serviceStatus: null == serviceStatus
          ? _value.serviceStatus
          : serviceStatus // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      shippingStatus: null == shippingStatus
          ? _value.shippingStatus
          : shippingStatus // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      shippingTypes: null == shippingTypes
          ? _value.shippingTypes
          : shippingTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      visitPaymentTypes: null == visitPaymentTypes
          ? _value.visitPaymentTypes
          : visitPaymentTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      typesResidence: null == typesResidence
          ? _value.typesResidence
          : typesResidence // ignore: cast_nullable_to_non_nullable
              as List<TypesResidence>,
      typesDemandeVisite: null == typesDemandeVisite
          ? _value.typesDemandeVisite
          : typesDemandeVisite // ignore: cast_nullable_to_non_nullable
              as List<TypesDemandeVisite>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConfigDataImplCopyWith<$Res>
    implements $ConfigDataCopyWith<$Res> {
  factory _$$ConfigDataImplCopyWith(
          _$ConfigDataImpl value, $Res Function(_$ConfigDataImpl) then) =
      __$$ConfigDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String websiteUrl,
      int normalVisitPrice,
      int expressVisitPrice,
      int pourcentageCommissionReservation,
      String projectName,
      String projectUrl,
      String smsSenderName,
      double proximityRadius,
      double standardShippingPrice,
      double flashShippingPrice,
      String contactEmail,
      String contactPhoneNumber,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      List<dynamic> categories,
      List<dynamic> categoryPaymentTypes,
      List<dynamic> defaultStatus,
      List<dynamic> galleryGroups,
      List<dynamic> languages,
      List<dynamic> orderPaymentTypes,
      List<dynamic> paymentStatus,
      List<dynamic> productTypes,
      List<dynamic> servicePaymentTypes,
      List<dynamic> serviceStatus,
      List<dynamic> shippingStatus,
      List<dynamic> shippingTypes,
      List<dynamic> visitPaymentTypes,
      List<TypesResidence> typesResidence,
      List<TypesDemandeVisite> typesDemandeVisite});
}

/// @nodoc
class __$$ConfigDataImplCopyWithImpl<$Res>
    extends _$ConfigDataCopyWithImpl<$Res, _$ConfigDataImpl>
    implements _$$ConfigDataImplCopyWith<$Res> {
  __$$ConfigDataImplCopyWithImpl(
      _$ConfigDataImpl _value, $Res Function(_$ConfigDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConfigData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? websiteUrl = null,
    Object? normalVisitPrice = null,
    Object? expressVisitPrice = null,
    Object? pourcentageCommissionReservation = null,
    Object? projectName = null,
    Object? projectUrl = null,
    Object? smsSenderName = null,
    Object? proximityRadius = null,
    Object? standardShippingPrice = null,
    Object? flashShippingPrice = null,
    Object? contactEmail = null,
    Object? contactPhoneNumber = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? categories = null,
    Object? categoryPaymentTypes = null,
    Object? defaultStatus = null,
    Object? galleryGroups = null,
    Object? languages = null,
    Object? orderPaymentTypes = null,
    Object? paymentStatus = null,
    Object? productTypes = null,
    Object? servicePaymentTypes = null,
    Object? serviceStatus = null,
    Object? shippingStatus = null,
    Object? shippingTypes = null,
    Object? visitPaymentTypes = null,
    Object? typesResidence = null,
    Object? typesDemandeVisite = null,
  }) {
    return _then(_$ConfigDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      websiteUrl: null == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String,
      normalVisitPrice: null == normalVisitPrice
          ? _value.normalVisitPrice
          : normalVisitPrice // ignore: cast_nullable_to_non_nullable
              as int,
      expressVisitPrice: null == expressVisitPrice
          ? _value.expressVisitPrice
          : expressVisitPrice // ignore: cast_nullable_to_non_nullable
              as int,
      pourcentageCommissionReservation: null == pourcentageCommissionReservation
          ? _value.pourcentageCommissionReservation
          : pourcentageCommissionReservation // ignore: cast_nullable_to_non_nullable
              as int,
      projectName: null == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String,
      projectUrl: null == projectUrl
          ? _value.projectUrl
          : projectUrl // ignore: cast_nullable_to_non_nullable
              as String,
      smsSenderName: null == smsSenderName
          ? _value.smsSenderName
          : smsSenderName // ignore: cast_nullable_to_non_nullable
              as String,
      proximityRadius: null == proximityRadius
          ? _value.proximityRadius
          : proximityRadius // ignore: cast_nullable_to_non_nullable
              as double,
      standardShippingPrice: null == standardShippingPrice
          ? _value.standardShippingPrice
          : standardShippingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      flashShippingPrice: null == flashShippingPrice
          ? _value.flashShippingPrice
          : flashShippingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      contactEmail: null == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String,
      contactPhoneNumber: null == contactPhoneNumber
          ? _value.contactPhoneNumber
          : contactPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      categoryPaymentTypes: null == categoryPaymentTypes
          ? _value._categoryPaymentTypes
          : categoryPaymentTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      defaultStatus: null == defaultStatus
          ? _value._defaultStatus
          : defaultStatus // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      galleryGroups: null == galleryGroups
          ? _value._galleryGroups
          : galleryGroups // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      languages: null == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      orderPaymentTypes: null == orderPaymentTypes
          ? _value._orderPaymentTypes
          : orderPaymentTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      paymentStatus: null == paymentStatus
          ? _value._paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      productTypes: null == productTypes
          ? _value._productTypes
          : productTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      servicePaymentTypes: null == servicePaymentTypes
          ? _value._servicePaymentTypes
          : servicePaymentTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      serviceStatus: null == serviceStatus
          ? _value._serviceStatus
          : serviceStatus // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      shippingStatus: null == shippingStatus
          ? _value._shippingStatus
          : shippingStatus // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      shippingTypes: null == shippingTypes
          ? _value._shippingTypes
          : shippingTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      visitPaymentTypes: null == visitPaymentTypes
          ? _value._visitPaymentTypes
          : visitPaymentTypes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      typesResidence: null == typesResidence
          ? _value._typesResidence
          : typesResidence // ignore: cast_nullable_to_non_nullable
              as List<TypesResidence>,
      typesDemandeVisite: null == typesDemandeVisite
          ? _value._typesDemandeVisite
          : typesDemandeVisite // ignore: cast_nullable_to_non_nullable
              as List<TypesDemandeVisite>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfigDataImpl implements _ConfigData {
  _$ConfigDataImpl(
      {this.id = '',
      this.websiteUrl = '',
      this.normalVisitPrice = 0,
      this.expressVisitPrice = 0,
      this.pourcentageCommissionReservation = 0,
      this.projectName = '',
      this.projectUrl = '',
      this.smsSenderName = '',
      this.proximityRadius = 0.0,
      this.standardShippingPrice = 0.0,
      this.flashShippingPrice = 0.0,
      this.contactEmail = '',
      this.contactPhoneNumber = '',
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      final List<dynamic> categories = const [],
      final List<dynamic> categoryPaymentTypes = const [],
      final List<dynamic> defaultStatus = const [],
      final List<dynamic> galleryGroups = const [],
      final List<dynamic> languages = const [],
      final List<dynamic> orderPaymentTypes = const [],
      final List<dynamic> paymentStatus = const [],
      final List<dynamic> productTypes = const [],
      final List<dynamic> servicePaymentTypes = const [],
      final List<dynamic> serviceStatus = const [],
      final List<dynamic> shippingStatus = const [],
      final List<dynamic> shippingTypes = const [],
      final List<dynamic> visitPaymentTypes = const [],
      final List<TypesResidence> typesResidence = const [],
      final List<TypesDemandeVisite> typesDemandeVisite = const []})
      : _categories = categories,
        _categoryPaymentTypes = categoryPaymentTypes,
        _defaultStatus = defaultStatus,
        _galleryGroups = galleryGroups,
        _languages = languages,
        _orderPaymentTypes = orderPaymentTypes,
        _paymentStatus = paymentStatus,
        _productTypes = productTypes,
        _servicePaymentTypes = servicePaymentTypes,
        _serviceStatus = serviceStatus,
        _shippingStatus = shippingStatus,
        _shippingTypes = shippingTypes,
        _visitPaymentTypes = visitPaymentTypes,
        _typesResidence = typesResidence,
        _typesDemandeVisite = typesDemandeVisite;

  factory _$ConfigDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfigDataImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String websiteUrl;
  @override
  @JsonKey()
  final int normalVisitPrice;
  @override
  @JsonKey()
  final int expressVisitPrice;
  @override
  @JsonKey()
  final int pourcentageCommissionReservation;
  @override
  @JsonKey()
  final String projectName;
  @override
  @JsonKey()
  final String projectUrl;
  @override
  @JsonKey()
  final String smsSenderName;
  @override
  @JsonKey()
  final double proximityRadius;
  @override
  @JsonKey()
  final double standardShippingPrice;
  @override
  @JsonKey()
  final double flashShippingPrice;
  @override
  @JsonKey()
  final String contactEmail;
  @override
  @JsonKey()
  final String contactPhoneNumber;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;
  final List<dynamic> _categories;
  @override
  @JsonKey()
  List<dynamic> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<dynamic> _categoryPaymentTypes;
  @override
  @JsonKey()
  List<dynamic> get categoryPaymentTypes {
    if (_categoryPaymentTypes is EqualUnmodifiableListView)
      return _categoryPaymentTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryPaymentTypes);
  }

  final List<dynamic> _defaultStatus;
  @override
  @JsonKey()
  List<dynamic> get defaultStatus {
    if (_defaultStatus is EqualUnmodifiableListView) return _defaultStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defaultStatus);
  }

  final List<dynamic> _galleryGroups;
  @override
  @JsonKey()
  List<dynamic> get galleryGroups {
    if (_galleryGroups is EqualUnmodifiableListView) return _galleryGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_galleryGroups);
  }

  final List<dynamic> _languages;
  @override
  @JsonKey()
  List<dynamic> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

  final List<dynamic> _orderPaymentTypes;
  @override
  @JsonKey()
  List<dynamic> get orderPaymentTypes {
    if (_orderPaymentTypes is EqualUnmodifiableListView)
      return _orderPaymentTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderPaymentTypes);
  }

  final List<dynamic> _paymentStatus;
  @override
  @JsonKey()
  List<dynamic> get paymentStatus {
    if (_paymentStatus is EqualUnmodifiableListView) return _paymentStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paymentStatus);
  }

  final List<dynamic> _productTypes;
  @override
  @JsonKey()
  List<dynamic> get productTypes {
    if (_productTypes is EqualUnmodifiableListView) return _productTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productTypes);
  }

  final List<dynamic> _servicePaymentTypes;
  @override
  @JsonKey()
  List<dynamic> get servicePaymentTypes {
    if (_servicePaymentTypes is EqualUnmodifiableListView)
      return _servicePaymentTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_servicePaymentTypes);
  }

  final List<dynamic> _serviceStatus;
  @override
  @JsonKey()
  List<dynamic> get serviceStatus {
    if (_serviceStatus is EqualUnmodifiableListView) return _serviceStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serviceStatus);
  }

  final List<dynamic> _shippingStatus;
  @override
  @JsonKey()
  List<dynamic> get shippingStatus {
    if (_shippingStatus is EqualUnmodifiableListView) return _shippingStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shippingStatus);
  }

  final List<dynamic> _shippingTypes;
  @override
  @JsonKey()
  List<dynamic> get shippingTypes {
    if (_shippingTypes is EqualUnmodifiableListView) return _shippingTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shippingTypes);
  }

  final List<dynamic> _visitPaymentTypes;
  @override
  @JsonKey()
  List<dynamic> get visitPaymentTypes {
    if (_visitPaymentTypes is EqualUnmodifiableListView)
      return _visitPaymentTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_visitPaymentTypes);
  }

  final List<TypesResidence> _typesResidence;
  @override
  @JsonKey()
  List<TypesResidence> get typesResidence {
    if (_typesResidence is EqualUnmodifiableListView) return _typesResidence;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_typesResidence);
  }

  final List<TypesDemandeVisite> _typesDemandeVisite;
  @override
  @JsonKey()
  List<TypesDemandeVisite> get typesDemandeVisite {
    if (_typesDemandeVisite is EqualUnmodifiableListView)
      return _typesDemandeVisite;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_typesDemandeVisite);
  }

  @override
  String toString() {
    return 'ConfigData(id: $id, websiteUrl: $websiteUrl, normalVisitPrice: $normalVisitPrice, expressVisitPrice: $expressVisitPrice, pourcentageCommissionReservation: $pourcentageCommissionReservation, projectName: $projectName, projectUrl: $projectUrl, smsSenderName: $smsSenderName, proximityRadius: $proximityRadius, standardShippingPrice: $standardShippingPrice, flashShippingPrice: $flashShippingPrice, contactEmail: $contactEmail, contactPhoneNumber: $contactPhoneNumber, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, categories: $categories, categoryPaymentTypes: $categoryPaymentTypes, defaultStatus: $defaultStatus, galleryGroups: $galleryGroups, languages: $languages, orderPaymentTypes: $orderPaymentTypes, paymentStatus: $paymentStatus, productTypes: $productTypes, servicePaymentTypes: $servicePaymentTypes, serviceStatus: $serviceStatus, shippingStatus: $shippingStatus, shippingTypes: $shippingTypes, visitPaymentTypes: $visitPaymentTypes, typesResidence: $typesResidence, typesDemandeVisite: $typesDemandeVisite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.websiteUrl, websiteUrl) ||
                other.websiteUrl == websiteUrl) &&
            (identical(other.normalVisitPrice, normalVisitPrice) ||
                other.normalVisitPrice == normalVisitPrice) &&
            (identical(other.expressVisitPrice, expressVisitPrice) ||
                other.expressVisitPrice == expressVisitPrice) &&
            (identical(other.pourcentageCommissionReservation,
                    pourcentageCommissionReservation) ||
                other.pourcentageCommissionReservation ==
                    pourcentageCommissionReservation) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.projectUrl, projectUrl) ||
                other.projectUrl == projectUrl) &&
            (identical(other.smsSenderName, smsSenderName) ||
                other.smsSenderName == smsSenderName) &&
            (identical(other.proximityRadius, proximityRadius) ||
                other.proximityRadius == proximityRadius) &&
            (identical(other.standardShippingPrice, standardShippingPrice) ||
                other.standardShippingPrice == standardShippingPrice) &&
            (identical(other.flashShippingPrice, flashShippingPrice) ||
                other.flashShippingPrice == flashShippingPrice) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.contactPhoneNumber, contactPhoneNumber) ||
                other.contactPhoneNumber == contactPhoneNumber) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality()
                .equals(other._categoryPaymentTypes, _categoryPaymentTypes) &&
            const DeepCollectionEquality()
                .equals(other._defaultStatus, _defaultStatus) &&
            const DeepCollectionEquality()
                .equals(other._galleryGroups, _galleryGroups) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            const DeepCollectionEquality()
                .equals(other._orderPaymentTypes, _orderPaymentTypes) &&
            const DeepCollectionEquality()
                .equals(other._paymentStatus, _paymentStatus) &&
            const DeepCollectionEquality()
                .equals(other._productTypes, _productTypes) &&
            const DeepCollectionEquality()
                .equals(other._servicePaymentTypes, _servicePaymentTypes) &&
            const DeepCollectionEquality()
                .equals(other._serviceStatus, _serviceStatus) &&
            const DeepCollectionEquality()
                .equals(other._shippingStatus, _shippingStatus) &&
            const DeepCollectionEquality()
                .equals(other._shippingTypes, _shippingTypes) &&
            const DeepCollectionEquality()
                .equals(other._visitPaymentTypes, _visitPaymentTypes) &&
            const DeepCollectionEquality()
                .equals(other._typesResidence, _typesResidence) &&
            const DeepCollectionEquality()
                .equals(other._typesDemandeVisite, _typesDemandeVisite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        websiteUrl,
        normalVisitPrice,
        expressVisitPrice,
        pourcentageCommissionReservation,
        projectName,
        projectUrl,
        smsSenderName,
        proximityRadius,
        standardShippingPrice,
        flashShippingPrice,
        contactEmail,
        contactPhoneNumber,
        createdAt,
        updatedAt,
        deletedAt,
        const DeepCollectionEquality().hash(_categories),
        const DeepCollectionEquality().hash(_categoryPaymentTypes),
        const DeepCollectionEquality().hash(_defaultStatus),
        const DeepCollectionEquality().hash(_galleryGroups),
        const DeepCollectionEquality().hash(_languages),
        const DeepCollectionEquality().hash(_orderPaymentTypes),
        const DeepCollectionEquality().hash(_paymentStatus),
        const DeepCollectionEquality().hash(_productTypes),
        const DeepCollectionEquality().hash(_servicePaymentTypes),
        const DeepCollectionEquality().hash(_serviceStatus),
        const DeepCollectionEquality().hash(_shippingStatus),
        const DeepCollectionEquality().hash(_shippingTypes),
        const DeepCollectionEquality().hash(_visitPaymentTypes),
        const DeepCollectionEquality().hash(_typesResidence),
        const DeepCollectionEquality().hash(_typesDemandeVisite)
      ]);

  /// Create a copy of ConfigData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigDataImplCopyWith<_$ConfigDataImpl> get copyWith =>
      __$$ConfigDataImplCopyWithImpl<_$ConfigDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfigDataImplToJson(
      this,
    );
  }
}

abstract class _ConfigData implements ConfigData {
  factory _ConfigData(
      {final String id,
      final String websiteUrl,
      final int normalVisitPrice,
      final int expressVisitPrice,
      final int pourcentageCommissionReservation,
      final String projectName,
      final String projectUrl,
      final String smsSenderName,
      final double proximityRadius,
      final double standardShippingPrice,
      final double flashShippingPrice,
      final String contactEmail,
      final String contactPhoneNumber,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final DateTime? deletedAt,
      final List<dynamic> categories,
      final List<dynamic> categoryPaymentTypes,
      final List<dynamic> defaultStatus,
      final List<dynamic> galleryGroups,
      final List<dynamic> languages,
      final List<dynamic> orderPaymentTypes,
      final List<dynamic> paymentStatus,
      final List<dynamic> productTypes,
      final List<dynamic> servicePaymentTypes,
      final List<dynamic> serviceStatus,
      final List<dynamic> shippingStatus,
      final List<dynamic> shippingTypes,
      final List<dynamic> visitPaymentTypes,
      final List<TypesResidence> typesResidence,
      final List<TypesDemandeVisite> typesDemandeVisite}) = _$ConfigDataImpl;

  factory _ConfigData.fromJson(Map<String, dynamic> json) =
      _$ConfigDataImpl.fromJson;

  @override
  String get id;
  @override
  String get websiteUrl;
  @override
  int get normalVisitPrice;
  @override
  int get expressVisitPrice;
  @override
  int get pourcentageCommissionReservation;
  @override
  String get projectName;
  @override
  String get projectUrl;
  @override
  String get smsSenderName;
  @override
  double get proximityRadius;
  @override
  double get standardShippingPrice;
  @override
  double get flashShippingPrice;
  @override
  String get contactEmail;
  @override
  String get contactPhoneNumber;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get deletedAt;
  @override
  List<dynamic> get categories;
  @override
  List<dynamic> get categoryPaymentTypes;
  @override
  List<dynamic> get defaultStatus;
  @override
  List<dynamic> get galleryGroups;
  @override
  List<dynamic> get languages;
  @override
  List<dynamic> get orderPaymentTypes;
  @override
  List<dynamic> get paymentStatus;
  @override
  List<dynamic> get productTypes;
  @override
  List<dynamic> get servicePaymentTypes;
  @override
  List<dynamic> get serviceStatus;
  @override
  List<dynamic> get shippingStatus;
  @override
  List<dynamic> get shippingTypes;
  @override
  List<dynamic> get visitPaymentTypes;
  @override
  List<TypesResidence> get typesResidence;
  @override
  List<TypesDemandeVisite> get typesDemandeVisite;

  /// Create a copy of ConfigData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigDataImplCopyWith<_$ConfigDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TypesResidence _$TypesResidenceFromJson(Map<String, dynamic> json) {
  return _TypesResidence.fromJson(json);
}

/// @nodoc
mixin _$TypesResidence {
  String get text => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this TypesResidence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TypesResidence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TypesResidenceCopyWith<TypesResidence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TypesResidenceCopyWith<$Res> {
  factory $TypesResidenceCopyWith(
          TypesResidence value, $Res Function(TypesResidence) then) =
      _$TypesResidenceCopyWithImpl<$Res, TypesResidence>;
  @useResult
  $Res call({String text, String value});
}

/// @nodoc
class _$TypesResidenceCopyWithImpl<$Res, $Val extends TypesResidence>
    implements $TypesResidenceCopyWith<$Res> {
  _$TypesResidenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TypesResidence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TypesResidenceImplCopyWith<$Res>
    implements $TypesResidenceCopyWith<$Res> {
  factory _$$TypesResidenceImplCopyWith(_$TypesResidenceImpl value,
          $Res Function(_$TypesResidenceImpl) then) =
      __$$TypesResidenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, String value});
}

/// @nodoc
class __$$TypesResidenceImplCopyWithImpl<$Res>
    extends _$TypesResidenceCopyWithImpl<$Res, _$TypesResidenceImpl>
    implements _$$TypesResidenceImplCopyWith<$Res> {
  __$$TypesResidenceImplCopyWithImpl(
      _$TypesResidenceImpl _value, $Res Function(_$TypesResidenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of TypesResidence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? value = null,
  }) {
    return _then(_$TypesResidenceImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TypesResidenceImpl implements _TypesResidence {
  const _$TypesResidenceImpl({this.text = '', this.value = ''});

  factory _$TypesResidenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$TypesResidenceImplFromJson(json);

  @override
  @JsonKey()
  final String text;
  @override
  @JsonKey()
  final String value;

  @override
  String toString() {
    return 'TypesResidence(text: $text, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypesResidenceImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, value);

  /// Create a copy of TypesResidence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TypesResidenceImplCopyWith<_$TypesResidenceImpl> get copyWith =>
      __$$TypesResidenceImplCopyWithImpl<_$TypesResidenceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TypesResidenceImplToJson(
      this,
    );
  }
}

abstract class _TypesResidence implements TypesResidence {
  const factory _TypesResidence({final String text, final String value}) =
      _$TypesResidenceImpl;

  factory _TypesResidence.fromJson(Map<String, dynamic> json) =
      _$TypesResidenceImpl.fromJson;

  @override
  String get text;
  @override
  String get value;

  /// Create a copy of TypesResidence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TypesResidenceImplCopyWith<_$TypesResidenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TypesDemandeVisite _$TypesDemandeVisiteFromJson(Map<String, dynamic> json) {
  return _TypesDemandeVisite.fromJson(json);
}

/// @nodoc
mixin _$TypesDemandeVisite {
  String get text => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this TypesDemandeVisite to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TypesDemandeVisite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TypesDemandeVisiteCopyWith<TypesDemandeVisite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TypesDemandeVisiteCopyWith<$Res> {
  factory $TypesDemandeVisiteCopyWith(
          TypesDemandeVisite value, $Res Function(TypesDemandeVisite) then) =
      _$TypesDemandeVisiteCopyWithImpl<$Res, TypesDemandeVisite>;
  @useResult
  $Res call({String text, String value});
}

/// @nodoc
class _$TypesDemandeVisiteCopyWithImpl<$Res, $Val extends TypesDemandeVisite>
    implements $TypesDemandeVisiteCopyWith<$Res> {
  _$TypesDemandeVisiteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TypesDemandeVisite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TypesDemandeVisiteImplCopyWith<$Res>
    implements $TypesDemandeVisiteCopyWith<$Res> {
  factory _$$TypesDemandeVisiteImplCopyWith(_$TypesDemandeVisiteImpl value,
          $Res Function(_$TypesDemandeVisiteImpl) then) =
      __$$TypesDemandeVisiteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, String value});
}

/// @nodoc
class __$$TypesDemandeVisiteImplCopyWithImpl<$Res>
    extends _$TypesDemandeVisiteCopyWithImpl<$Res, _$TypesDemandeVisiteImpl>
    implements _$$TypesDemandeVisiteImplCopyWith<$Res> {
  __$$TypesDemandeVisiteImplCopyWithImpl(_$TypesDemandeVisiteImpl _value,
      $Res Function(_$TypesDemandeVisiteImpl) _then)
      : super(_value, _then);

  /// Create a copy of TypesDemandeVisite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? value = null,
  }) {
    return _then(_$TypesDemandeVisiteImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TypesDemandeVisiteImpl implements _TypesDemandeVisite {
  const _$TypesDemandeVisiteImpl({this.text = '', this.value = ''});

  factory _$TypesDemandeVisiteImpl.fromJson(Map<String, dynamic> json) =>
      _$$TypesDemandeVisiteImplFromJson(json);

  @override
  @JsonKey()
  final String text;
  @override
  @JsonKey()
  final String value;

  @override
  String toString() {
    return 'TypesDemandeVisite(text: $text, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypesDemandeVisiteImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, value);

  /// Create a copy of TypesDemandeVisite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TypesDemandeVisiteImplCopyWith<_$TypesDemandeVisiteImpl> get copyWith =>
      __$$TypesDemandeVisiteImplCopyWithImpl<_$TypesDemandeVisiteImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TypesDemandeVisiteImplToJson(
      this,
    );
  }
}

abstract class _TypesDemandeVisite implements TypesDemandeVisite {
  const factory _TypesDemandeVisite({final String text, final String value}) =
      _$TypesDemandeVisiteImpl;

  factory _TypesDemandeVisite.fromJson(Map<String, dynamic> json) =
      _$TypesDemandeVisiteImpl.fromJson;

  @override
  String get text;
  @override
  String get value;

  /// Create a copy of TypesDemandeVisite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TypesDemandeVisiteImplCopyWith<_$TypesDemandeVisiteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
