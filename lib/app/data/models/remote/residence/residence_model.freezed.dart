// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'residence_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResidenceModel _$ResidenceModelFromJson(Map<String, dynamic> json) {
  return _ResidenceModel.fromJson(json);
}

/// @nodoc
mixin _$ResidenceModel {
  String get id => throw _privateConstructorUsedError;
  String get miniature => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  String get typeResidence => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get prixReservation => throw _privateConstructorUsedError;
  String get adresse => throw _privateConstructorUsedError;
  String get ville => throw _privateConstructorUsedError;
  String get commune => throw _privateConstructorUsedError;
  String get statusValidation => throw _privateConstructorUsedError;
  @JsonKey(name: 'ville_model')
  VilleModel? get villeModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'commune_model')
  CommuneModel? get communeModel => throw _privateConstructorUsedError;
  PositionModel get position => throw _privateConstructorUsedError;
  String get video => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  List<CommoditeModel> get commodites => throw _privateConstructorUsedError;
  List<PieceModel> get pieces => throw _privateConstructorUsedError;
  int get dureeMinSejour => throw _privateConstructorUsedError;
  int get dureeMaxSejour => throw _privateConstructorUsedError;
  String get heureEntree => throw _privateConstructorUsedError;
  String get heureDepart => throw _privateConstructorUsedError;
  int get nombreMaxOccupants => throw _privateConstructorUsedError;
  bool get animauxAutorises => throw _privateConstructorUsedError;
  bool get fetesAutorises => throw _privateConstructorUsedError;
  String get reglesSupplementaires => throw _privateConstructorUsedError;
  num? get score =>
      throw _privateConstructorUsedError; //ClientModel? proprietaire,
  bool get residenceDisponible => throw _privateConstructorUsedError;
  num get reduction => throw _privateConstructorUsedError;

  /// Serializes this ResidenceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResidenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResidenceModelCopyWith<ResidenceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResidenceModelCopyWith<$Res> {
  factory $ResidenceModelCopyWith(
          ResidenceModel value, $Res Function(ResidenceModel) then) =
      _$ResidenceModelCopyWithImpl<$Res, ResidenceModel>;
  @useResult
  $Res call(
      {String id,
      String miniature,
      String nom,
      String typeResidence,
      String description,
      int prixReservation,
      String adresse,
      String ville,
      String commune,
      String statusValidation,
      @JsonKey(name: 'ville_model') VilleModel? villeModel,
      @JsonKey(name: 'commune_model') CommuneModel? communeModel,
      PositionModel position,
      String video,
      List<String> images,
      List<CommoditeModel> commodites,
      List<PieceModel> pieces,
      int dureeMinSejour,
      int dureeMaxSejour,
      String heureEntree,
      String heureDepart,
      int nombreMaxOccupants,
      bool animauxAutorises,
      bool fetesAutorises,
      String reglesSupplementaires,
      num? score,
      bool residenceDisponible,
      num reduction});

  $VilleModelCopyWith<$Res>? get villeModel;
  $CommuneModelCopyWith<$Res>? get communeModel;
  $PositionModelCopyWith<$Res> get position;
}

/// @nodoc
class _$ResidenceModelCopyWithImpl<$Res, $Val extends ResidenceModel>
    implements $ResidenceModelCopyWith<$Res> {
  _$ResidenceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResidenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? miniature = null,
    Object? nom = null,
    Object? typeResidence = null,
    Object? description = null,
    Object? prixReservation = null,
    Object? adresse = null,
    Object? ville = null,
    Object? commune = null,
    Object? statusValidation = null,
    Object? villeModel = freezed,
    Object? communeModel = freezed,
    Object? position = null,
    Object? video = null,
    Object? images = null,
    Object? commodites = null,
    Object? pieces = null,
    Object? dureeMinSejour = null,
    Object? dureeMaxSejour = null,
    Object? heureEntree = null,
    Object? heureDepart = null,
    Object? nombreMaxOccupants = null,
    Object? animauxAutorises = null,
    Object? fetesAutorises = null,
    Object? reglesSupplementaires = null,
    Object? score = freezed,
    Object? residenceDisponible = null,
    Object? reduction = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      miniature: null == miniature
          ? _value.miniature
          : miniature // ignore: cast_nullable_to_non_nullable
              as String,
      nom: null == nom
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String,
      typeResidence: null == typeResidence
          ? _value.typeResidence
          : typeResidence // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      prixReservation: null == prixReservation
          ? _value.prixReservation
          : prixReservation // ignore: cast_nullable_to_non_nullable
              as int,
      adresse: null == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String,
      ville: null == ville
          ? _value.ville
          : ville // ignore: cast_nullable_to_non_nullable
              as String,
      commune: null == commune
          ? _value.commune
          : commune // ignore: cast_nullable_to_non_nullable
              as String,
      statusValidation: null == statusValidation
          ? _value.statusValidation
          : statusValidation // ignore: cast_nullable_to_non_nullable
              as String,
      villeModel: freezed == villeModel
          ? _value.villeModel
          : villeModel // ignore: cast_nullable_to_non_nullable
              as VilleModel?,
      communeModel: freezed == communeModel
          ? _value.communeModel
          : communeModel // ignore: cast_nullable_to_non_nullable
              as CommuneModel?,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PositionModel,
      video: null == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      commodites: null == commodites
          ? _value.commodites
          : commodites // ignore: cast_nullable_to_non_nullable
              as List<CommoditeModel>,
      pieces: null == pieces
          ? _value.pieces
          : pieces // ignore: cast_nullable_to_non_nullable
              as List<PieceModel>,
      dureeMinSejour: null == dureeMinSejour
          ? _value.dureeMinSejour
          : dureeMinSejour // ignore: cast_nullable_to_non_nullable
              as int,
      dureeMaxSejour: null == dureeMaxSejour
          ? _value.dureeMaxSejour
          : dureeMaxSejour // ignore: cast_nullable_to_non_nullable
              as int,
      heureEntree: null == heureEntree
          ? _value.heureEntree
          : heureEntree // ignore: cast_nullable_to_non_nullable
              as String,
      heureDepart: null == heureDepart
          ? _value.heureDepart
          : heureDepart // ignore: cast_nullable_to_non_nullable
              as String,
      nombreMaxOccupants: null == nombreMaxOccupants
          ? _value.nombreMaxOccupants
          : nombreMaxOccupants // ignore: cast_nullable_to_non_nullable
              as int,
      animauxAutorises: null == animauxAutorises
          ? _value.animauxAutorises
          : animauxAutorises // ignore: cast_nullable_to_non_nullable
              as bool,
      fetesAutorises: null == fetesAutorises
          ? _value.fetesAutorises
          : fetesAutorises // ignore: cast_nullable_to_non_nullable
              as bool,
      reglesSupplementaires: null == reglesSupplementaires
          ? _value.reglesSupplementaires
          : reglesSupplementaires // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as num?,
      residenceDisponible: null == residenceDisponible
          ? _value.residenceDisponible
          : residenceDisponible // ignore: cast_nullable_to_non_nullable
              as bool,
      reduction: null == reduction
          ? _value.reduction
          : reduction // ignore: cast_nullable_to_non_nullable
              as num,
    ) as $Val);
  }

  /// Create a copy of ResidenceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VilleModelCopyWith<$Res>? get villeModel {
    if (_value.villeModel == null) {
      return null;
    }

    return $VilleModelCopyWith<$Res>(_value.villeModel!, (value) {
      return _then(_value.copyWith(villeModel: value) as $Val);
    });
  }

  /// Create a copy of ResidenceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommuneModelCopyWith<$Res>? get communeModel {
    if (_value.communeModel == null) {
      return null;
    }

    return $CommuneModelCopyWith<$Res>(_value.communeModel!, (value) {
      return _then(_value.copyWith(communeModel: value) as $Val);
    });
  }

  /// Create a copy of ResidenceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionModelCopyWith<$Res> get position {
    return $PositionModelCopyWith<$Res>(_value.position, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResidenceModelImplCopyWith<$Res>
    implements $ResidenceModelCopyWith<$Res> {
  factory _$$ResidenceModelImplCopyWith(_$ResidenceModelImpl value,
          $Res Function(_$ResidenceModelImpl) then) =
      __$$ResidenceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String miniature,
      String nom,
      String typeResidence,
      String description,
      int prixReservation,
      String adresse,
      String ville,
      String commune,
      String statusValidation,
      @JsonKey(name: 'ville_model') VilleModel? villeModel,
      @JsonKey(name: 'commune_model') CommuneModel? communeModel,
      PositionModel position,
      String video,
      List<String> images,
      List<CommoditeModel> commodites,
      List<PieceModel> pieces,
      int dureeMinSejour,
      int dureeMaxSejour,
      String heureEntree,
      String heureDepart,
      int nombreMaxOccupants,
      bool animauxAutorises,
      bool fetesAutorises,
      String reglesSupplementaires,
      num? score,
      bool residenceDisponible,
      num reduction});

  @override
  $VilleModelCopyWith<$Res>? get villeModel;
  @override
  $CommuneModelCopyWith<$Res>? get communeModel;
  @override
  $PositionModelCopyWith<$Res> get position;
}

/// @nodoc
class __$$ResidenceModelImplCopyWithImpl<$Res>
    extends _$ResidenceModelCopyWithImpl<$Res, _$ResidenceModelImpl>
    implements _$$ResidenceModelImplCopyWith<$Res> {
  __$$ResidenceModelImplCopyWithImpl(
      _$ResidenceModelImpl _value, $Res Function(_$ResidenceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResidenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? miniature = null,
    Object? nom = null,
    Object? typeResidence = null,
    Object? description = null,
    Object? prixReservation = null,
    Object? adresse = null,
    Object? ville = null,
    Object? commune = null,
    Object? statusValidation = null,
    Object? villeModel = freezed,
    Object? communeModel = freezed,
    Object? position = null,
    Object? video = null,
    Object? images = null,
    Object? commodites = null,
    Object? pieces = null,
    Object? dureeMinSejour = null,
    Object? dureeMaxSejour = null,
    Object? heureEntree = null,
    Object? heureDepart = null,
    Object? nombreMaxOccupants = null,
    Object? animauxAutorises = null,
    Object? fetesAutorises = null,
    Object? reglesSupplementaires = null,
    Object? score = freezed,
    Object? residenceDisponible = null,
    Object? reduction = null,
  }) {
    return _then(_$ResidenceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      miniature: null == miniature
          ? _value.miniature
          : miniature // ignore: cast_nullable_to_non_nullable
              as String,
      nom: null == nom
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String,
      typeResidence: null == typeResidence
          ? _value.typeResidence
          : typeResidence // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      prixReservation: null == prixReservation
          ? _value.prixReservation
          : prixReservation // ignore: cast_nullable_to_non_nullable
              as int,
      adresse: null == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String,
      ville: null == ville
          ? _value.ville
          : ville // ignore: cast_nullable_to_non_nullable
              as String,
      commune: null == commune
          ? _value.commune
          : commune // ignore: cast_nullable_to_non_nullable
              as String,
      statusValidation: null == statusValidation
          ? _value.statusValidation
          : statusValidation // ignore: cast_nullable_to_non_nullable
              as String,
      villeModel: freezed == villeModel
          ? _value.villeModel
          : villeModel // ignore: cast_nullable_to_non_nullable
              as VilleModel?,
      communeModel: freezed == communeModel
          ? _value.communeModel
          : communeModel // ignore: cast_nullable_to_non_nullable
              as CommuneModel?,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PositionModel,
      video: null == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      commodites: null == commodites
          ? _value._commodites
          : commodites // ignore: cast_nullable_to_non_nullable
              as List<CommoditeModel>,
      pieces: null == pieces
          ? _value._pieces
          : pieces // ignore: cast_nullable_to_non_nullable
              as List<PieceModel>,
      dureeMinSejour: null == dureeMinSejour
          ? _value.dureeMinSejour
          : dureeMinSejour // ignore: cast_nullable_to_non_nullable
              as int,
      dureeMaxSejour: null == dureeMaxSejour
          ? _value.dureeMaxSejour
          : dureeMaxSejour // ignore: cast_nullable_to_non_nullable
              as int,
      heureEntree: null == heureEntree
          ? _value.heureEntree
          : heureEntree // ignore: cast_nullable_to_non_nullable
              as String,
      heureDepart: null == heureDepart
          ? _value.heureDepart
          : heureDepart // ignore: cast_nullable_to_non_nullable
              as String,
      nombreMaxOccupants: null == nombreMaxOccupants
          ? _value.nombreMaxOccupants
          : nombreMaxOccupants // ignore: cast_nullable_to_non_nullable
              as int,
      animauxAutorises: null == animauxAutorises
          ? _value.animauxAutorises
          : animauxAutorises // ignore: cast_nullable_to_non_nullable
              as bool,
      fetesAutorises: null == fetesAutorises
          ? _value.fetesAutorises
          : fetesAutorises // ignore: cast_nullable_to_non_nullable
              as bool,
      reglesSupplementaires: null == reglesSupplementaires
          ? _value.reglesSupplementaires
          : reglesSupplementaires // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as num?,
      residenceDisponible: null == residenceDisponible
          ? _value.residenceDisponible
          : residenceDisponible // ignore: cast_nullable_to_non_nullable
              as bool,
      reduction: null == reduction
          ? _value.reduction
          : reduction // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResidenceModelImpl implements _ResidenceModel {
  const _$ResidenceModelImpl(
      {this.id = '',
      this.miniature = '',
      this.nom = '',
      this.typeResidence = 'Appartement',
      this.description = '',
      this.prixReservation = 0,
      this.adresse = '',
      this.ville = '',
      this.commune = '',
      this.statusValidation = '',
      @JsonKey(name: 'ville_model') this.villeModel,
      @JsonKey(name: 'commune_model') this.communeModel,
      this.position = const PositionModel(),
      this.video = '',
      final List<String> images = const [],
      final List<CommoditeModel> commodites = const [],
      final List<PieceModel> pieces = const [],
      this.dureeMinSejour = 0,
      this.dureeMaxSejour = 0,
      this.heureEntree = '',
      this.heureDepart = '',
      this.nombreMaxOccupants = 0,
      this.animauxAutorises = false,
      this.fetesAutorises = false,
      this.reglesSupplementaires = '',
      this.score,
      this.residenceDisponible = true,
      this.reduction = 0})
      : _images = images,
        _commodites = commodites,
        _pieces = pieces;

  factory _$ResidenceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResidenceModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String miniature;
  @override
  @JsonKey()
  final String nom;
  @override
  @JsonKey()
  final String typeResidence;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final int prixReservation;
  @override
  @JsonKey()
  final String adresse;
  @override
  @JsonKey()
  final String ville;
  @override
  @JsonKey()
  final String commune;
  @override
  @JsonKey()
  final String statusValidation;
  @override
  @JsonKey(name: 'ville_model')
  final VilleModel? villeModel;
  @override
  @JsonKey(name: 'commune_model')
  final CommuneModel? communeModel;
  @override
  @JsonKey()
  final PositionModel position;
  @override
  @JsonKey()
  final String video;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<CommoditeModel> _commodites;
  @override
  @JsonKey()
  List<CommoditeModel> get commodites {
    if (_commodites is EqualUnmodifiableListView) return _commodites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commodites);
  }

  final List<PieceModel> _pieces;
  @override
  @JsonKey()
  List<PieceModel> get pieces {
    if (_pieces is EqualUnmodifiableListView) return _pieces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pieces);
  }

  @override
  @JsonKey()
  final int dureeMinSejour;
  @override
  @JsonKey()
  final int dureeMaxSejour;
  @override
  @JsonKey()
  final String heureEntree;
  @override
  @JsonKey()
  final String heureDepart;
  @override
  @JsonKey()
  final int nombreMaxOccupants;
  @override
  @JsonKey()
  final bool animauxAutorises;
  @override
  @JsonKey()
  final bool fetesAutorises;
  @override
  @JsonKey()
  final String reglesSupplementaires;
  @override
  final num? score;
//ClientModel? proprietaire,
  @override
  @JsonKey()
  final bool residenceDisponible;
  @override
  @JsonKey()
  final num reduction;

  @override
  String toString() {
    return 'ResidenceModel(id: $id, miniature: $miniature, nom: $nom, typeResidence: $typeResidence, description: $description, prixReservation: $prixReservation, adresse: $adresse, ville: $ville, commune: $commune, statusValidation: $statusValidation, villeModel: $villeModel, communeModel: $communeModel, position: $position, video: $video, images: $images, commodites: $commodites, pieces: $pieces, dureeMinSejour: $dureeMinSejour, dureeMaxSejour: $dureeMaxSejour, heureEntree: $heureEntree, heureDepart: $heureDepart, nombreMaxOccupants: $nombreMaxOccupants, animauxAutorises: $animauxAutorises, fetesAutorises: $fetesAutorises, reglesSupplementaires: $reglesSupplementaires, score: $score, residenceDisponible: $residenceDisponible, reduction: $reduction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResidenceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.miniature, miniature) ||
                other.miniature == miniature) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.typeResidence, typeResidence) ||
                other.typeResidence == typeResidence) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.prixReservation, prixReservation) ||
                other.prixReservation == prixReservation) &&
            (identical(other.adresse, adresse) || other.adresse == adresse) &&
            (identical(other.ville, ville) || other.ville == ville) &&
            (identical(other.commune, commune) || other.commune == commune) &&
            (identical(other.statusValidation, statusValidation) ||
                other.statusValidation == statusValidation) &&
            (identical(other.villeModel, villeModel) ||
                other.villeModel == villeModel) &&
            (identical(other.communeModel, communeModel) ||
                other.communeModel == communeModel) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.video, video) || other.video == video) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality()
                .equals(other._commodites, _commodites) &&
            const DeepCollectionEquality().equals(other._pieces, _pieces) &&
            (identical(other.dureeMinSejour, dureeMinSejour) ||
                other.dureeMinSejour == dureeMinSejour) &&
            (identical(other.dureeMaxSejour, dureeMaxSejour) ||
                other.dureeMaxSejour == dureeMaxSejour) &&
            (identical(other.heureEntree, heureEntree) ||
                other.heureEntree == heureEntree) &&
            (identical(other.heureDepart, heureDepart) ||
                other.heureDepart == heureDepart) &&
            (identical(other.nombreMaxOccupants, nombreMaxOccupants) ||
                other.nombreMaxOccupants == nombreMaxOccupants) &&
            (identical(other.animauxAutorises, animauxAutorises) ||
                other.animauxAutorises == animauxAutorises) &&
            (identical(other.fetesAutorises, fetesAutorises) ||
                other.fetesAutorises == fetesAutorises) &&
            (identical(other.reglesSupplementaires, reglesSupplementaires) ||
                other.reglesSupplementaires == reglesSupplementaires) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.residenceDisponible, residenceDisponible) ||
                other.residenceDisponible == residenceDisponible) &&
            (identical(other.reduction, reduction) ||
                other.reduction == reduction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        miniature,
        nom,
        typeResidence,
        description,
        prixReservation,
        adresse,
        ville,
        commune,
        statusValidation,
        villeModel,
        communeModel,
        position,
        video,
        const DeepCollectionEquality().hash(_images),
        const DeepCollectionEquality().hash(_commodites),
        const DeepCollectionEquality().hash(_pieces),
        dureeMinSejour,
        dureeMaxSejour,
        heureEntree,
        heureDepart,
        nombreMaxOccupants,
        animauxAutorises,
        fetesAutorises,
        reglesSupplementaires,
        score,
        residenceDisponible,
        reduction
      ]);

  /// Create a copy of ResidenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResidenceModelImplCopyWith<_$ResidenceModelImpl> get copyWith =>
      __$$ResidenceModelImplCopyWithImpl<_$ResidenceModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResidenceModelImplToJson(
      this,
    );
  }
}

abstract class _ResidenceModel implements ResidenceModel {
  const factory _ResidenceModel(
      {final String id,
      final String miniature,
      final String nom,
      final String typeResidence,
      final String description,
      final int prixReservation,
      final String adresse,
      final String ville,
      final String commune,
      final String statusValidation,
      @JsonKey(name: 'ville_model') final VilleModel? villeModel,
      @JsonKey(name: 'commune_model') final CommuneModel? communeModel,
      final PositionModel position,
      final String video,
      final List<String> images,
      final List<CommoditeModel> commodites,
      final List<PieceModel> pieces,
      final int dureeMinSejour,
      final int dureeMaxSejour,
      final String heureEntree,
      final String heureDepart,
      final int nombreMaxOccupants,
      final bool animauxAutorises,
      final bool fetesAutorises,
      final String reglesSupplementaires,
      final num? score,
      final bool residenceDisponible,
      final num reduction}) = _$ResidenceModelImpl;

  factory _ResidenceModel.fromJson(Map<String, dynamic> json) =
      _$ResidenceModelImpl.fromJson;

  @override
  String get id;
  @override
  String get miniature;
  @override
  String get nom;
  @override
  String get typeResidence;
  @override
  String get description;
  @override
  int get prixReservation;
  @override
  String get adresse;
  @override
  String get ville;
  @override
  String get commune;
  @override
  String get statusValidation;
  @override
  @JsonKey(name: 'ville_model')
  VilleModel? get villeModel;
  @override
  @JsonKey(name: 'commune_model')
  CommuneModel? get communeModel;
  @override
  PositionModel get position;
  @override
  String get video;
  @override
  List<String> get images;
  @override
  List<CommoditeModel> get commodites;
  @override
  List<PieceModel> get pieces;
  @override
  int get dureeMinSejour;
  @override
  int get dureeMaxSejour;
  @override
  String get heureEntree;
  @override
  String get heureDepart;
  @override
  int get nombreMaxOccupants;
  @override
  bool get animauxAutorises;
  @override
  bool get fetesAutorises;
  @override
  String get reglesSupplementaires;
  @override
  num? get score; //ClientModel? proprietaire,
  @override
  bool get residenceDisponible;
  @override
  num get reduction;

  /// Create a copy of ResidenceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResidenceModelImplCopyWith<_$ResidenceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
