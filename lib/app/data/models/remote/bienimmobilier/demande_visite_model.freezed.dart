// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'demande_visite_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DemandeVisiteModel _$DemandeVisiteModelFromJson(Map<String, dynamic> json) {
  return _DemandeVisiteModel.fromJson(json);
}

/// @nodoc
mixin _$DemandeVisiteModel {
  String get id => throw _privateConstructorUsedError;
  String? get statusDemandeVisite => throw _privateConstructorUsedError;
  String? get typeDemandeVisite => throw _privateConstructorUsedError;
  List<DateDemandeVisite> get datesDemandeVisite =>
      throw _privateConstructorUsedError;
  String? get statusFacture => throw _privateConstructorUsedError;
  bool get retraitProEffectue => throw _privateConstructorUsedError;
  int get montantTotalDemandeVisite => throw _privateConstructorUsedError;
  int get montantDemandeVisiteSansCommission =>
      throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get clientPhoneNumber => throw _privateConstructorUsedError;
  BienImmobilierModel? get bienImmobilier => throw _privateConstructorUsedError;
  String? get bienImmobilierId => throw _privateConstructorUsedError;
  ClientModel? get client => throw _privateConstructorUsedError;
  ClientModel? get proprietaire => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;

  /// Serializes this DemandeVisiteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DemandeVisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DemandeVisiteModelCopyWith<DemandeVisiteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DemandeVisiteModelCopyWith<$Res> {
  factory $DemandeVisiteModelCopyWith(
          DemandeVisiteModel value, $Res Function(DemandeVisiteModel) then) =
      _$DemandeVisiteModelCopyWithImpl<$Res, DemandeVisiteModel>;
  @useResult
  $Res call(
      {String id,
      String? statusDemandeVisite,
      String? typeDemandeVisite,
      List<DateDemandeVisite> datesDemandeVisite,
      String? statusFacture,
      bool retraitProEffectue,
      int montantTotalDemandeVisite,
      int montantDemandeVisiteSansCommission,
      String? notes,
      String? clientPhoneNumber,
      BienImmobilierModel? bienImmobilier,
      String? bienImmobilierId,
      ClientModel? client,
      ClientModel? proprietaire,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy});

  $BienImmobilierModelCopyWith<$Res>? get bienImmobilier;
  $ClientModelCopyWith<$Res>? get client;
  $ClientModelCopyWith<$Res>? get proprietaire;
}

/// @nodoc
class _$DemandeVisiteModelCopyWithImpl<$Res, $Val extends DemandeVisiteModel>
    implements $DemandeVisiteModelCopyWith<$Res> {
  _$DemandeVisiteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DemandeVisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? statusDemandeVisite = freezed,
    Object? typeDemandeVisite = freezed,
    Object? datesDemandeVisite = null,
    Object? statusFacture = freezed,
    Object? retraitProEffectue = null,
    Object? montantTotalDemandeVisite = null,
    Object? montantDemandeVisiteSansCommission = null,
    Object? notes = freezed,
    Object? clientPhoneNumber = freezed,
    Object? bienImmobilier = freezed,
    Object? bienImmobilierId = freezed,
    Object? client = freezed,
    Object? proprietaire = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      statusDemandeVisite: freezed == statusDemandeVisite
          ? _value.statusDemandeVisite
          : statusDemandeVisite // ignore: cast_nullable_to_non_nullable
              as String?,
      typeDemandeVisite: freezed == typeDemandeVisite
          ? _value.typeDemandeVisite
          : typeDemandeVisite // ignore: cast_nullable_to_non_nullable
              as String?,
      datesDemandeVisite: null == datesDemandeVisite
          ? _value.datesDemandeVisite
          : datesDemandeVisite // ignore: cast_nullable_to_non_nullable
              as List<DateDemandeVisite>,
      statusFacture: freezed == statusFacture
          ? _value.statusFacture
          : statusFacture // ignore: cast_nullable_to_non_nullable
              as String?,
      retraitProEffectue: null == retraitProEffectue
          ? _value.retraitProEffectue
          : retraitProEffectue // ignore: cast_nullable_to_non_nullable
              as bool,
      montantTotalDemandeVisite: null == montantTotalDemandeVisite
          ? _value.montantTotalDemandeVisite
          : montantTotalDemandeVisite // ignore: cast_nullable_to_non_nullable
              as int,
      montantDemandeVisiteSansCommission: null ==
              montantDemandeVisiteSansCommission
          ? _value.montantDemandeVisiteSansCommission
          : montantDemandeVisiteSansCommission // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      clientPhoneNumber: freezed == clientPhoneNumber
          ? _value.clientPhoneNumber
          : clientPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bienImmobilier: freezed == bienImmobilier
          ? _value.bienImmobilier
          : bienImmobilier // ignore: cast_nullable_to_non_nullable
              as BienImmobilierModel?,
      bienImmobilierId: freezed == bienImmobilierId
          ? _value.bienImmobilierId
          : bienImmobilierId // ignore: cast_nullable_to_non_nullable
              as String?,
      client: freezed == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as ClientModel?,
      proprietaire: freezed == proprietaire
          ? _value.proprietaire
          : proprietaire // ignore: cast_nullable_to_non_nullable
              as ClientModel?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of DemandeVisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BienImmobilierModelCopyWith<$Res>? get bienImmobilier {
    if (_value.bienImmobilier == null) {
      return null;
    }

    return $BienImmobilierModelCopyWith<$Res>(_value.bienImmobilier!, (value) {
      return _then(_value.copyWith(bienImmobilier: value) as $Val);
    });
  }

  /// Create a copy of DemandeVisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClientModelCopyWith<$Res>? get client {
    if (_value.client == null) {
      return null;
    }

    return $ClientModelCopyWith<$Res>(_value.client!, (value) {
      return _then(_value.copyWith(client: value) as $Val);
    });
  }

  /// Create a copy of DemandeVisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClientModelCopyWith<$Res>? get proprietaire {
    if (_value.proprietaire == null) {
      return null;
    }

    return $ClientModelCopyWith<$Res>(_value.proprietaire!, (value) {
      return _then(_value.copyWith(proprietaire: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DemandeVisiteModelImplCopyWith<$Res>
    implements $DemandeVisiteModelCopyWith<$Res> {
  factory _$$DemandeVisiteModelImplCopyWith(_$DemandeVisiteModelImpl value,
          $Res Function(_$DemandeVisiteModelImpl) then) =
      __$$DemandeVisiteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? statusDemandeVisite,
      String? typeDemandeVisite,
      List<DateDemandeVisite> datesDemandeVisite,
      String? statusFacture,
      bool retraitProEffectue,
      int montantTotalDemandeVisite,
      int montantDemandeVisiteSansCommission,
      String? notes,
      String? clientPhoneNumber,
      BienImmobilierModel? bienImmobilier,
      String? bienImmobilierId,
      ClientModel? client,
      ClientModel? proprietaire,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy});

  @override
  $BienImmobilierModelCopyWith<$Res>? get bienImmobilier;
  @override
  $ClientModelCopyWith<$Res>? get client;
  @override
  $ClientModelCopyWith<$Res>? get proprietaire;
}

/// @nodoc
class __$$DemandeVisiteModelImplCopyWithImpl<$Res>
    extends _$DemandeVisiteModelCopyWithImpl<$Res, _$DemandeVisiteModelImpl>
    implements _$$DemandeVisiteModelImplCopyWith<$Res> {
  __$$DemandeVisiteModelImplCopyWithImpl(_$DemandeVisiteModelImpl _value,
      $Res Function(_$DemandeVisiteModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DemandeVisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? statusDemandeVisite = freezed,
    Object? typeDemandeVisite = freezed,
    Object? datesDemandeVisite = null,
    Object? statusFacture = freezed,
    Object? retraitProEffectue = null,
    Object? montantTotalDemandeVisite = null,
    Object? montantDemandeVisiteSansCommission = null,
    Object? notes = freezed,
    Object? clientPhoneNumber = freezed,
    Object? bienImmobilier = freezed,
    Object? bienImmobilierId = freezed,
    Object? client = freezed,
    Object? proprietaire = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_$DemandeVisiteModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      statusDemandeVisite: freezed == statusDemandeVisite
          ? _value.statusDemandeVisite
          : statusDemandeVisite // ignore: cast_nullable_to_non_nullable
              as String?,
      typeDemandeVisite: freezed == typeDemandeVisite
          ? _value.typeDemandeVisite
          : typeDemandeVisite // ignore: cast_nullable_to_non_nullable
              as String?,
      datesDemandeVisite: null == datesDemandeVisite
          ? _value._datesDemandeVisite
          : datesDemandeVisite // ignore: cast_nullable_to_non_nullable
              as List<DateDemandeVisite>,
      statusFacture: freezed == statusFacture
          ? _value.statusFacture
          : statusFacture // ignore: cast_nullable_to_non_nullable
              as String?,
      retraitProEffectue: null == retraitProEffectue
          ? _value.retraitProEffectue
          : retraitProEffectue // ignore: cast_nullable_to_non_nullable
              as bool,
      montantTotalDemandeVisite: null == montantTotalDemandeVisite
          ? _value.montantTotalDemandeVisite
          : montantTotalDemandeVisite // ignore: cast_nullable_to_non_nullable
              as int,
      montantDemandeVisiteSansCommission: null ==
              montantDemandeVisiteSansCommission
          ? _value.montantDemandeVisiteSansCommission
          : montantDemandeVisiteSansCommission // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      clientPhoneNumber: freezed == clientPhoneNumber
          ? _value.clientPhoneNumber
          : clientPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bienImmobilier: freezed == bienImmobilier
          ? _value.bienImmobilier
          : bienImmobilier // ignore: cast_nullable_to_non_nullable
              as BienImmobilierModel?,
      bienImmobilierId: freezed == bienImmobilierId
          ? _value.bienImmobilierId
          : bienImmobilierId // ignore: cast_nullable_to_non_nullable
              as String?,
      client: freezed == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as ClientModel?,
      proprietaire: freezed == proprietaire
          ? _value.proprietaire
          : proprietaire // ignore: cast_nullable_to_non_nullable
              as ClientModel?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DemandeVisiteModelImpl implements _DemandeVisiteModel {
  _$DemandeVisiteModelImpl(
      {this.id = '',
      this.statusDemandeVisite,
      this.typeDemandeVisite,
      final List<DateDemandeVisite> datesDemandeVisite = const [],
      this.statusFacture,
      this.retraitProEffectue = false,
      this.montantTotalDemandeVisite = 0,
      this.montantDemandeVisiteSansCommission = 0,
      this.notes,
      this.clientPhoneNumber,
      this.bienImmobilier,
      this.bienImmobilierId,
      this.client,
      this.proprietaire,
      this.createdAt,
      this.updatedAt,
      this.createdBy})
      : _datesDemandeVisite = datesDemandeVisite;

  factory _$DemandeVisiteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DemandeVisiteModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  final String? statusDemandeVisite;
  @override
  final String? typeDemandeVisite;
  final List<DateDemandeVisite> _datesDemandeVisite;
  @override
  @JsonKey()
  List<DateDemandeVisite> get datesDemandeVisite {
    if (_datesDemandeVisite is EqualUnmodifiableListView)
      return _datesDemandeVisite;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_datesDemandeVisite);
  }

  @override
  final String? statusFacture;
  @override
  @JsonKey()
  final bool retraitProEffectue;
  @override
  @JsonKey()
  final int montantTotalDemandeVisite;
  @override
  @JsonKey()
  final int montantDemandeVisiteSansCommission;
  @override
  final String? notes;
  @override
  final String? clientPhoneNumber;
  @override
  final BienImmobilierModel? bienImmobilier;
  @override
  final String? bienImmobilierId;
  @override
  final ClientModel? client;
  @override
  final ClientModel? proprietaire;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? createdBy;

  @override
  String toString() {
    return 'DemandeVisiteModel(id: $id, statusDemandeVisite: $statusDemandeVisite, typeDemandeVisite: $typeDemandeVisite, datesDemandeVisite: $datesDemandeVisite, statusFacture: $statusFacture, retraitProEffectue: $retraitProEffectue, montantTotalDemandeVisite: $montantTotalDemandeVisite, montantDemandeVisiteSansCommission: $montantDemandeVisiteSansCommission, notes: $notes, clientPhoneNumber: $clientPhoneNumber, bienImmobilier: $bienImmobilier, bienImmobilierId: $bienImmobilierId, client: $client, proprietaire: $proprietaire, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DemandeVisiteModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.statusDemandeVisite, statusDemandeVisite) ||
                other.statusDemandeVisite == statusDemandeVisite) &&
            (identical(other.typeDemandeVisite, typeDemandeVisite) ||
                other.typeDemandeVisite == typeDemandeVisite) &&
            const DeepCollectionEquality()
                .equals(other._datesDemandeVisite, _datesDemandeVisite) &&
            (identical(other.statusFacture, statusFacture) ||
                other.statusFacture == statusFacture) &&
            (identical(other.retraitProEffectue, retraitProEffectue) ||
                other.retraitProEffectue == retraitProEffectue) &&
            (identical(other.montantTotalDemandeVisite,
                    montantTotalDemandeVisite) ||
                other.montantTotalDemandeVisite == montantTotalDemandeVisite) &&
            (identical(other.montantDemandeVisiteSansCommission,
                    montantDemandeVisiteSansCommission) ||
                other.montantDemandeVisiteSansCommission ==
                    montantDemandeVisiteSansCommission) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.clientPhoneNumber, clientPhoneNumber) ||
                other.clientPhoneNumber == clientPhoneNumber) &&
            (identical(other.bienImmobilier, bienImmobilier) ||
                other.bienImmobilier == bienImmobilier) &&
            (identical(other.bienImmobilierId, bienImmobilierId) ||
                other.bienImmobilierId == bienImmobilierId) &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.proprietaire, proprietaire) ||
                other.proprietaire == proprietaire) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      statusDemandeVisite,
      typeDemandeVisite,
      const DeepCollectionEquality().hash(_datesDemandeVisite),
      statusFacture,
      retraitProEffectue,
      montantTotalDemandeVisite,
      montantDemandeVisiteSansCommission,
      notes,
      clientPhoneNumber,
      bienImmobilier,
      bienImmobilierId,
      client,
      proprietaire,
      createdAt,
      updatedAt,
      createdBy);

  /// Create a copy of DemandeVisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DemandeVisiteModelImplCopyWith<_$DemandeVisiteModelImpl> get copyWith =>
      __$$DemandeVisiteModelImplCopyWithImpl<_$DemandeVisiteModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DemandeVisiteModelImplToJson(
      this,
    );
  }
}

abstract class _DemandeVisiteModel implements DemandeVisiteModel {
  factory _DemandeVisiteModel(
      {final String id,
      final String? statusDemandeVisite,
      final String? typeDemandeVisite,
      final List<DateDemandeVisite> datesDemandeVisite,
      final String? statusFacture,
      final bool retraitProEffectue,
      final int montantTotalDemandeVisite,
      final int montantDemandeVisiteSansCommission,
      final String? notes,
      final String? clientPhoneNumber,
      final BienImmobilierModel? bienImmobilier,
      final String? bienImmobilierId,
      final ClientModel? client,
      final ClientModel? proprietaire,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? createdBy}) = _$DemandeVisiteModelImpl;

  factory _DemandeVisiteModel.fromJson(Map<String, dynamic> json) =
      _$DemandeVisiteModelImpl.fromJson;

  @override
  String get id;
  @override
  String? get statusDemandeVisite;
  @override
  String? get typeDemandeVisite;
  @override
  List<DateDemandeVisite> get datesDemandeVisite;
  @override
  String? get statusFacture;
  @override
  bool get retraitProEffectue;
  @override
  int get montantTotalDemandeVisite;
  @override
  int get montantDemandeVisiteSansCommission;
  @override
  String? get notes;
  @override
  String? get clientPhoneNumber;
  @override
  BienImmobilierModel? get bienImmobilier;
  @override
  String? get bienImmobilierId;
  @override
  ClientModel? get client;
  @override
  ClientModel? get proprietaire;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;

  /// Create a copy of DemandeVisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DemandeVisiteModelImplCopyWith<_$DemandeVisiteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
