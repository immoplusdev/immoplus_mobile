// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReservationModel _$ReservationModelFromJson(Map<String, dynamic> json) {
  return _ReservationModel.fromJson(json);
}

/// @nodoc
mixin _$ReservationModel {
  String get id => throw _privateConstructorUsedError;
  String get statusReservation => throw _privateConstructorUsedError;
  List<DatesReservationModel> get datesReservation =>
      throw _privateConstructorUsedError;
  String get dateDebut => throw _privateConstructorUsedError;
  String get dateFin => throw _privateConstructorUsedError;
  String get statusFacture => throw _privateConstructorUsedError;
  bool get retraitProEffectue => throw _privateConstructorUsedError;
  double get montantTotalReservation => throw _privateConstructorUsedError;
  double get montantReservationSansCommission =>
      throw _privateConstructorUsedError;
  int get montantPaye => throw _privateConstructorUsedError;
  String get codeReservation => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  String get clientPhoneNumber => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  String? get delaisProprietaireReponse => throw _privateConstructorUsedError;
  String? get delaisPaiementClient => throw _privateConstructorUsedError;
  bool? get ratingsNotified => throw _privateConstructorUsedError;
  RatingStatus? get ratingStatus => throw _privateConstructorUsedError;
  bool? get checkinValide => throw _privateConstructorUsedError;
  String? get checkinValideAt => throw _privateConstructorUsedError;
  ResidenceModel get residence => throw _privateConstructorUsedError;
  ClientModel get client => throw _privateConstructorUsedError;
  ProprietaireModel get proprietaire => throw _privateConstructorUsedError;

  /// Serializes this ReservationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationModelCopyWith<ReservationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationModelCopyWith<$Res> {
  factory $ReservationModelCopyWith(
          ReservationModel value, $Res Function(ReservationModel) then) =
      _$ReservationModelCopyWithImpl<$Res, ReservationModel>;
  @useResult
  $Res call(
      {String id,
      String statusReservation,
      List<DatesReservationModel> datesReservation,
      String dateDebut,
      String dateFin,
      String statusFacture,
      bool retraitProEffectue,
      double montantTotalReservation,
      double montantReservationSansCommission,
      int montantPaye,
      String codeReservation,
      String notes,
      String clientPhoneNumber,
      String createdAt,
      String updatedAt,
      String? delaisProprietaireReponse,
      String? delaisPaiementClient,
      bool? ratingsNotified,
      RatingStatus? ratingStatus,
      bool? checkinValide,
      String? checkinValideAt,
      ResidenceModel residence,
      ClientModel client,
      ProprietaireModel proprietaire});

  $ResidenceModelCopyWith<$Res> get residence;
  $ClientModelCopyWith<$Res> get client;
  $ProprietaireModelCopyWith<$Res> get proprietaire;
}

/// @nodoc
class _$ReservationModelCopyWithImpl<$Res, $Val extends ReservationModel>
    implements $ReservationModelCopyWith<$Res> {
  _$ReservationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? statusReservation = null,
    Object? datesReservation = null,
    Object? dateDebut = null,
    Object? dateFin = null,
    Object? statusFacture = null,
    Object? retraitProEffectue = null,
    Object? montantTotalReservation = null,
    Object? montantReservationSansCommission = null,
    Object? montantPaye = null,
    Object? codeReservation = null,
    Object? notes = null,
    Object? clientPhoneNumber = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? delaisProprietaireReponse = freezed,
    Object? delaisPaiementClient = freezed,
    Object? ratingsNotified = freezed,
    Object? ratingStatus = freezed,
    Object? checkinValide = freezed,
    Object? checkinValideAt = freezed,
    Object? residence = null,
    Object? client = null,
    Object? proprietaire = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      statusReservation: null == statusReservation
          ? _value.statusReservation
          : statusReservation // ignore: cast_nullable_to_non_nullable
              as String,
      datesReservation: null == datesReservation
          ? _value.datesReservation
          : datesReservation // ignore: cast_nullable_to_non_nullable
              as List<DatesReservationModel>,
      dateDebut: null == dateDebut
          ? _value.dateDebut
          : dateDebut // ignore: cast_nullable_to_non_nullable
              as String,
      dateFin: null == dateFin
          ? _value.dateFin
          : dateFin // ignore: cast_nullable_to_non_nullable
              as String,
      statusFacture: null == statusFacture
          ? _value.statusFacture
          : statusFacture // ignore: cast_nullable_to_non_nullable
              as String,
      retraitProEffectue: null == retraitProEffectue
          ? _value.retraitProEffectue
          : retraitProEffectue // ignore: cast_nullable_to_non_nullable
              as bool,
      montantTotalReservation: null == montantTotalReservation
          ? _value.montantTotalReservation
          : montantTotalReservation // ignore: cast_nullable_to_non_nullable
              as double,
      montantReservationSansCommission: null == montantReservationSansCommission
          ? _value.montantReservationSansCommission
          : montantReservationSansCommission // ignore: cast_nullable_to_non_nullable
              as double,
      montantPaye: null == montantPaye
          ? _value.montantPaye
          : montantPaye // ignore: cast_nullable_to_non_nullable
              as int,
      codeReservation: null == codeReservation
          ? _value.codeReservation
          : codeReservation // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      clientPhoneNumber: null == clientPhoneNumber
          ? _value.clientPhoneNumber
          : clientPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      delaisProprietaireReponse: freezed == delaisProprietaireReponse
          ? _value.delaisProprietaireReponse
          : delaisProprietaireReponse // ignore: cast_nullable_to_non_nullable
              as String?,
      delaisPaiementClient: freezed == delaisPaiementClient
          ? _value.delaisPaiementClient
          : delaisPaiementClient // ignore: cast_nullable_to_non_nullable
              as String?,
      ratingsNotified: freezed == ratingsNotified
          ? _value.ratingsNotified
          : ratingsNotified // ignore: cast_nullable_to_non_nullable
              as bool?,
      ratingStatus: freezed == ratingStatus
          ? _value.ratingStatus
          : ratingStatus // ignore: cast_nullable_to_non_nullable
              as RatingStatus?,
      checkinValide: freezed == checkinValide
          ? _value.checkinValide
          : checkinValide // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkinValideAt: freezed == checkinValideAt
          ? _value.checkinValideAt
          : checkinValideAt // ignore: cast_nullable_to_non_nullable
              as String?,
      residence: null == residence
          ? _value.residence
          : residence // ignore: cast_nullable_to_non_nullable
              as ResidenceModel,
      client: null == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as ClientModel,
      proprietaire: null == proprietaire
          ? _value.proprietaire
          : proprietaire // ignore: cast_nullable_to_non_nullable
              as ProprietaireModel,
    ) as $Val);
  }

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResidenceModelCopyWith<$Res> get residence {
    return $ResidenceModelCopyWith<$Res>(_value.residence, (value) {
      return _then(_value.copyWith(residence: value) as $Val);
    });
  }

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClientModelCopyWith<$Res> get client {
    return $ClientModelCopyWith<$Res>(_value.client, (value) {
      return _then(_value.copyWith(client: value) as $Val);
    });
  }

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProprietaireModelCopyWith<$Res> get proprietaire {
    return $ProprietaireModelCopyWith<$Res>(_value.proprietaire, (value) {
      return _then(_value.copyWith(proprietaire: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReservationModelImplCopyWith<$Res>
    implements $ReservationModelCopyWith<$Res> {
  factory _$$ReservationModelImplCopyWith(_$ReservationModelImpl value,
          $Res Function(_$ReservationModelImpl) then) =
      __$$ReservationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String statusReservation,
      List<DatesReservationModel> datesReservation,
      String dateDebut,
      String dateFin,
      String statusFacture,
      bool retraitProEffectue,
      double montantTotalReservation,
      double montantReservationSansCommission,
      int montantPaye,
      String codeReservation,
      String notes,
      String clientPhoneNumber,
      String createdAt,
      String updatedAt,
      String? delaisProprietaireReponse,
      String? delaisPaiementClient,
      bool? ratingsNotified,
      RatingStatus? ratingStatus,
      bool? checkinValide,
      String? checkinValideAt,
      ResidenceModel residence,
      ClientModel client,
      ProprietaireModel proprietaire});

  @override
  $ResidenceModelCopyWith<$Res> get residence;
  @override
  $ClientModelCopyWith<$Res> get client;
  @override
  $ProprietaireModelCopyWith<$Res> get proprietaire;
}

/// @nodoc
class __$$ReservationModelImplCopyWithImpl<$Res>
    extends _$ReservationModelCopyWithImpl<$Res, _$ReservationModelImpl>
    implements _$$ReservationModelImplCopyWith<$Res> {
  __$$ReservationModelImplCopyWithImpl(_$ReservationModelImpl _value,
      $Res Function(_$ReservationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? statusReservation = null,
    Object? datesReservation = null,
    Object? dateDebut = null,
    Object? dateFin = null,
    Object? statusFacture = null,
    Object? retraitProEffectue = null,
    Object? montantTotalReservation = null,
    Object? montantReservationSansCommission = null,
    Object? montantPaye = null,
    Object? codeReservation = null,
    Object? notes = null,
    Object? clientPhoneNumber = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? delaisProprietaireReponse = freezed,
    Object? delaisPaiementClient = freezed,
    Object? ratingsNotified = freezed,
    Object? ratingStatus = freezed,
    Object? checkinValide = freezed,
    Object? checkinValideAt = freezed,
    Object? residence = null,
    Object? client = null,
    Object? proprietaire = null,
  }) {
    return _then(_$ReservationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      statusReservation: null == statusReservation
          ? _value.statusReservation
          : statusReservation // ignore: cast_nullable_to_non_nullable
              as String,
      datesReservation: null == datesReservation
          ? _value._datesReservation
          : datesReservation // ignore: cast_nullable_to_non_nullable
              as List<DatesReservationModel>,
      dateDebut: null == dateDebut
          ? _value.dateDebut
          : dateDebut // ignore: cast_nullable_to_non_nullable
              as String,
      dateFin: null == dateFin
          ? _value.dateFin
          : dateFin // ignore: cast_nullable_to_non_nullable
              as String,
      statusFacture: null == statusFacture
          ? _value.statusFacture
          : statusFacture // ignore: cast_nullable_to_non_nullable
              as String,
      retraitProEffectue: null == retraitProEffectue
          ? _value.retraitProEffectue
          : retraitProEffectue // ignore: cast_nullable_to_non_nullable
              as bool,
      montantTotalReservation: null == montantTotalReservation
          ? _value.montantTotalReservation
          : montantTotalReservation // ignore: cast_nullable_to_non_nullable
              as double,
      montantReservationSansCommission: null == montantReservationSansCommission
          ? _value.montantReservationSansCommission
          : montantReservationSansCommission // ignore: cast_nullable_to_non_nullable
              as double,
      montantPaye: null == montantPaye
          ? _value.montantPaye
          : montantPaye // ignore: cast_nullable_to_non_nullable
              as int,
      codeReservation: null == codeReservation
          ? _value.codeReservation
          : codeReservation // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      clientPhoneNumber: null == clientPhoneNumber
          ? _value.clientPhoneNumber
          : clientPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      delaisProprietaireReponse: freezed == delaisProprietaireReponse
          ? _value.delaisProprietaireReponse
          : delaisProprietaireReponse // ignore: cast_nullable_to_non_nullable
              as String?,
      delaisPaiementClient: freezed == delaisPaiementClient
          ? _value.delaisPaiementClient
          : delaisPaiementClient // ignore: cast_nullable_to_non_nullable
              as String?,
      ratingsNotified: freezed == ratingsNotified
          ? _value.ratingsNotified
          : ratingsNotified // ignore: cast_nullable_to_non_nullable
              as bool?,
      ratingStatus: freezed == ratingStatus
          ? _value.ratingStatus
          : ratingStatus // ignore: cast_nullable_to_non_nullable
              as RatingStatus?,
      checkinValide: freezed == checkinValide
          ? _value.checkinValide
          : checkinValide // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkinValideAt: freezed == checkinValideAt
          ? _value.checkinValideAt
          : checkinValideAt // ignore: cast_nullable_to_non_nullable
              as String?,
      residence: null == residence
          ? _value.residence
          : residence // ignore: cast_nullable_to_non_nullable
              as ResidenceModel,
      client: null == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as ClientModel,
      proprietaire: null == proprietaire
          ? _value.proprietaire
          : proprietaire // ignore: cast_nullable_to_non_nullable
              as ProprietaireModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationModelImpl implements _ReservationModel {
  const _$ReservationModelImpl(
      {this.id = '',
      this.statusReservation = '',
      final List<DatesReservationModel> datesReservation = const [],
      this.dateDebut = '',
      this.dateFin = '',
      this.statusFacture = '',
      this.retraitProEffectue = false,
      this.montantTotalReservation = 0,
      this.montantReservationSansCommission = 0,
      this.montantPaye = 0,
      this.codeReservation = '',
      this.notes = '',
      this.clientPhoneNumber = '',
      this.createdAt = '',
      this.updatedAt = '',
      this.delaisProprietaireReponse = null,
      this.delaisPaiementClient = null,
      this.ratingsNotified = null,
      this.ratingStatus = null,
      this.checkinValide = null,
      this.checkinValideAt = null,
      this.residence = const ResidenceModel(),
      this.client = const ClientModel(),
      this.proprietaire = const ProprietaireModel()})
      : _datesReservation = datesReservation;

  factory _$ReservationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String statusReservation;
  final List<DatesReservationModel> _datesReservation;
  @override
  @JsonKey()
  List<DatesReservationModel> get datesReservation {
    if (_datesReservation is EqualUnmodifiableListView)
      return _datesReservation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_datesReservation);
  }

  @override
  @JsonKey()
  final String dateDebut;
  @override
  @JsonKey()
  final String dateFin;
  @override
  @JsonKey()
  final String statusFacture;
  @override
  @JsonKey()
  final bool retraitProEffectue;
  @override
  @JsonKey()
  final double montantTotalReservation;
  @override
  @JsonKey()
  final double montantReservationSansCommission;
  @override
  @JsonKey()
  final int montantPaye;
  @override
  @JsonKey()
  final String codeReservation;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final String clientPhoneNumber;
  @override
  @JsonKey()
  final String createdAt;
  @override
  @JsonKey()
  final String updatedAt;
  @override
  @JsonKey()
  final String? delaisProprietaireReponse;
  @override
  @JsonKey()
  final String? delaisPaiementClient;
  @override
  @JsonKey()
  final bool? ratingsNotified;
  @override
  @JsonKey()
  final RatingStatus? ratingStatus;
  @override
  @JsonKey()
  final bool? checkinValide;
  @override
  @JsonKey()
  final String? checkinValideAt;
  @override
  @JsonKey()
  final ResidenceModel residence;
  @override
  @JsonKey()
  final ClientModel client;
  @override
  @JsonKey()
  final ProprietaireModel proprietaire;

  @override
  String toString() {
    return 'ReservationModel(id: $id, statusReservation: $statusReservation, datesReservation: $datesReservation, dateDebut: $dateDebut, dateFin: $dateFin, statusFacture: $statusFacture, retraitProEffectue: $retraitProEffectue, montantTotalReservation: $montantTotalReservation, montantReservationSansCommission: $montantReservationSansCommission, montantPaye: $montantPaye, codeReservation: $codeReservation, notes: $notes, clientPhoneNumber: $clientPhoneNumber, createdAt: $createdAt, updatedAt: $updatedAt, delaisProprietaireReponse: $delaisProprietaireReponse, delaisPaiementClient: $delaisPaiementClient, ratingsNotified: $ratingsNotified, ratingStatus: $ratingStatus, checkinValide: $checkinValide, checkinValideAt: $checkinValideAt, residence: $residence, client: $client, proprietaire: $proprietaire)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.statusReservation, statusReservation) ||
                other.statusReservation == statusReservation) &&
            const DeepCollectionEquality()
                .equals(other._datesReservation, _datesReservation) &&
            (identical(other.dateDebut, dateDebut) ||
                other.dateDebut == dateDebut) &&
            (identical(other.dateFin, dateFin) || other.dateFin == dateFin) &&
            (identical(other.statusFacture, statusFacture) ||
                other.statusFacture == statusFacture) &&
            (identical(other.retraitProEffectue, retraitProEffectue) ||
                other.retraitProEffectue == retraitProEffectue) &&
            (identical(other.montantTotalReservation, montantTotalReservation) ||
                other.montantTotalReservation == montantTotalReservation) &&
            (identical(other.montantReservationSansCommission,
                    montantReservationSansCommission) ||
                other.montantReservationSansCommission ==
                    montantReservationSansCommission) &&
            (identical(other.montantPaye, montantPaye) ||
                other.montantPaye == montantPaye) &&
            (identical(other.codeReservation, codeReservation) ||
                other.codeReservation == codeReservation) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.clientPhoneNumber, clientPhoneNumber) ||
                other.clientPhoneNumber == clientPhoneNumber) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.delaisProprietaireReponse,
                    delaisProprietaireReponse) ||
                other.delaisProprietaireReponse == delaisProprietaireReponse) &&
            (identical(other.delaisPaiementClient, delaisPaiementClient) ||
                other.delaisPaiementClient == delaisPaiementClient) &&
            (identical(other.ratingsNotified, ratingsNotified) ||
                other.ratingsNotified == ratingsNotified) &&
            (identical(other.ratingStatus, ratingStatus) ||
                other.ratingStatus == ratingStatus) &&
            (identical(other.checkinValide, checkinValide) ||
                other.checkinValide == checkinValide) &&
            (identical(other.checkinValideAt, checkinValideAt) ||
                other.checkinValideAt == checkinValideAt) &&
            (identical(other.residence, residence) ||
                other.residence == residence) &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.proprietaire, proprietaire) ||
                other.proprietaire == proprietaire));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        statusReservation,
        const DeepCollectionEquality().hash(_datesReservation),
        dateDebut,
        dateFin,
        statusFacture,
        retraitProEffectue,
        montantTotalReservation,
        montantReservationSansCommission,
        montantPaye,
        codeReservation,
        notes,
        clientPhoneNumber,
        createdAt,
        updatedAt,
        delaisProprietaireReponse,
        delaisPaiementClient,
        ratingsNotified,
        ratingStatus,
        checkinValide,
        checkinValideAt,
        residence,
        client,
        proprietaire
      ]);

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationModelImplCopyWith<_$ReservationModelImpl> get copyWith =>
      __$$ReservationModelImplCopyWithImpl<_$ReservationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationModelImplToJson(
      this,
    );
  }
}

abstract class _ReservationModel implements ReservationModel {
  const factory _ReservationModel(
      {final String id,
      final String statusReservation,
      final List<DatesReservationModel> datesReservation,
      final String dateDebut,
      final String dateFin,
      final String statusFacture,
      final bool retraitProEffectue,
      final double montantTotalReservation,
      final double montantReservationSansCommission,
      final int montantPaye,
      final String codeReservation,
      final String notes,
      final String clientPhoneNumber,
      final String createdAt,
      final String updatedAt,
      final String? delaisProprietaireReponse,
      final String? delaisPaiementClient,
      final bool? ratingsNotified,
      final RatingStatus? ratingStatus,
      final bool? checkinValide,
      final String? checkinValideAt,
      final ResidenceModel residence,
      final ClientModel client,
      final ProprietaireModel proprietaire}) = _$ReservationModelImpl;

  factory _ReservationModel.fromJson(Map<String, dynamic> json) =
      _$ReservationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get statusReservation;
  @override
  List<DatesReservationModel> get datesReservation;
  @override
  String get dateDebut;
  @override
  String get dateFin;
  @override
  String get statusFacture;
  @override
  bool get retraitProEffectue;
  @override
  double get montantTotalReservation;
  @override
  double get montantReservationSansCommission;
  @override
  int get montantPaye;
  @override
  String get codeReservation;
  @override
  String get notes;
  @override
  String get clientPhoneNumber;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  String? get delaisProprietaireReponse;
  @override
  String? get delaisPaiementClient;
  @override
  bool? get ratingsNotified;
  @override
  RatingStatus? get ratingStatus;
  @override
  bool? get checkinValide;
  @override
  String? get checkinValideAt;
  @override
  ResidenceModel get residence;
  @override
  ClientModel get client;
  @override
  ProprietaireModel get proprietaire;

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationModelImplCopyWith<_$ReservationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
