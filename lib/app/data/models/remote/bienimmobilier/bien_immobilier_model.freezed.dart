// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bien_immobilier_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BienImmobilierModel _$BienImmobilierModelFromJson(Map<String, dynamic> json) {
  return _BienImmobilierModel.fromJson(json);
}

/// @nodoc
mixin _$BienImmobilierModel {
  String get id => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  String get typeBienImmobilier => throw _privateConstructorUsedError;
  String get typeLocation => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<CommoditeModel> get amentities => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  String get adresse => throw _privateConstructorUsedError;
  PositionModel get position => throw _privateConstructorUsedError;
  String get statusValidation => throw _privateConstructorUsedError;
  int get prix => throw _privateConstructorUsedError;
  bool get featured => throw _privateConstructorUsedError;
  bool get bienImmobilierDisponible => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String get miniatureId => throw _privateConstructorUsedError;
  List<PieceModel> get pieces => throw _privateConstructorUsedError;
  String? get ville => throw _privateConstructorUsedError;
  String? get commune => throw _privateConstructorUsedError;
  @JsonKey(name: 'ville_model')
  VilleModel? get villeModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'commune_model')
  CommuneModel? get communeModel => throw _privateConstructorUsedError;
  String? get video => throw _privateConstructorUsedError;
  bool get aLouer =>
      throw _privateConstructorUsedError; // 🔥 Ces champs manquants
  @JsonKey(fromJson: toDouble)
  double? get latitude => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toDouble)
  double? get longitude => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toInt)
  int? get nombreMaxOccupants => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: false)
  bool? get fetesAutorises => throw _privateConstructorUsedError;
  num? get score => throw _privateConstructorUsedError;

  /// Serializes this BienImmobilierModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BienImmobilierModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BienImmobilierModelCopyWith<BienImmobilierModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BienImmobilierModelCopyWith<$Res> {
  factory $BienImmobilierModelCopyWith(
          BienImmobilierModel value, $Res Function(BienImmobilierModel) then) =
      _$BienImmobilierModelCopyWithImpl<$Res, BienImmobilierModel>;
  @useResult
  $Res call(
      {String id,
      String nom,
      String typeBienImmobilier,
      String typeLocation,
      String description,
      List<CommoditeModel> amentities,
      List<String> tags,
      List<String> images,
      String adresse,
      PositionModel position,
      String statusValidation,
      int prix,
      bool featured,
      bool bienImmobilierDisponible,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      String miniatureId,
      List<PieceModel> pieces,
      String? ville,
      String? commune,
      @JsonKey(name: 'ville_model') VilleModel? villeModel,
      @JsonKey(name: 'commune_model') CommuneModel? communeModel,
      String? video,
      bool aLouer,
      @JsonKey(fromJson: toDouble) double? latitude,
      @JsonKey(fromJson: toDouble) double? longitude,
      @JsonKey(fromJson: toInt) int? nombreMaxOccupants,
      @JsonKey(defaultValue: false) bool? fetesAutorises,
      num? score});

  $PositionModelCopyWith<$Res> get position;
  $VilleModelCopyWith<$Res>? get villeModel;
  $CommuneModelCopyWith<$Res>? get communeModel;
}

/// @nodoc
class _$BienImmobilierModelCopyWithImpl<$Res, $Val extends BienImmobilierModel>
    implements $BienImmobilierModelCopyWith<$Res> {
  _$BienImmobilierModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BienImmobilierModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? typeBienImmobilier = null,
    Object? typeLocation = null,
    Object? description = null,
    Object? amentities = null,
    Object? tags = null,
    Object? images = null,
    Object? adresse = null,
    Object? position = null,
    Object? statusValidation = null,
    Object? prix = null,
    Object? featured = null,
    Object? bienImmobilierDisponible = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? miniatureId = null,
    Object? pieces = null,
    Object? ville = freezed,
    Object? commune = freezed,
    Object? villeModel = freezed,
    Object? communeModel = freezed,
    Object? video = freezed,
    Object? aLouer = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? nombreMaxOccupants = freezed,
    Object? fetesAutorises = freezed,
    Object? score = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nom: null == nom
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String,
      typeBienImmobilier: null == typeBienImmobilier
          ? _value.typeBienImmobilier
          : typeBienImmobilier // ignore: cast_nullable_to_non_nullable
              as String,
      typeLocation: null == typeLocation
          ? _value.typeLocation
          : typeLocation // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amentities: null == amentities
          ? _value.amentities
          : amentities // ignore: cast_nullable_to_non_nullable
              as List<CommoditeModel>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adresse: null == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PositionModel,
      statusValidation: null == statusValidation
          ? _value.statusValidation
          : statusValidation // ignore: cast_nullable_to_non_nullable
              as String,
      prix: null == prix
          ? _value.prix
          : prix // ignore: cast_nullable_to_non_nullable
              as int,
      featured: null == featured
          ? _value.featured
          : featured // ignore: cast_nullable_to_non_nullable
              as bool,
      bienImmobilierDisponible: null == bienImmobilierDisponible
          ? _value.bienImmobilierDisponible
          : bienImmobilierDisponible // ignore: cast_nullable_to_non_nullable
              as bool,
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
      miniatureId: null == miniatureId
          ? _value.miniatureId
          : miniatureId // ignore: cast_nullable_to_non_nullable
              as String,
      pieces: null == pieces
          ? _value.pieces
          : pieces // ignore: cast_nullable_to_non_nullable
              as List<PieceModel>,
      ville: freezed == ville
          ? _value.ville
          : ville // ignore: cast_nullable_to_non_nullable
              as String?,
      commune: freezed == commune
          ? _value.commune
          : commune // ignore: cast_nullable_to_non_nullable
              as String?,
      villeModel: freezed == villeModel
          ? _value.villeModel
          : villeModel // ignore: cast_nullable_to_non_nullable
              as VilleModel?,
      communeModel: freezed == communeModel
          ? _value.communeModel
          : communeModel // ignore: cast_nullable_to_non_nullable
              as CommuneModel?,
      video: freezed == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as String?,
      aLouer: null == aLouer
          ? _value.aLouer
          : aLouer // ignore: cast_nullable_to_non_nullable
              as bool,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      nombreMaxOccupants: freezed == nombreMaxOccupants
          ? _value.nombreMaxOccupants
          : nombreMaxOccupants // ignore: cast_nullable_to_non_nullable
              as int?,
      fetesAutorises: freezed == fetesAutorises
          ? _value.fetesAutorises
          : fetesAutorises // ignore: cast_nullable_to_non_nullable
              as bool?,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as num?,
    ) as $Val);
  }

  /// Create a copy of BienImmobilierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionModelCopyWith<$Res> get position {
    return $PositionModelCopyWith<$Res>(_value.position, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }

  /// Create a copy of BienImmobilierModel
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

  /// Create a copy of BienImmobilierModel
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
}

/// @nodoc
abstract class _$$BienImmobilierModelImplCopyWith<$Res>
    implements $BienImmobilierModelCopyWith<$Res> {
  factory _$$BienImmobilierModelImplCopyWith(_$BienImmobilierModelImpl value,
          $Res Function(_$BienImmobilierModelImpl) then) =
      __$$BienImmobilierModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nom,
      String typeBienImmobilier,
      String typeLocation,
      String description,
      List<CommoditeModel> amentities,
      List<String> tags,
      List<String> images,
      String adresse,
      PositionModel position,
      String statusValidation,
      int prix,
      bool featured,
      bool bienImmobilierDisponible,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      String miniatureId,
      List<PieceModel> pieces,
      String? ville,
      String? commune,
      @JsonKey(name: 'ville_model') VilleModel? villeModel,
      @JsonKey(name: 'commune_model') CommuneModel? communeModel,
      String? video,
      bool aLouer,
      @JsonKey(fromJson: toDouble) double? latitude,
      @JsonKey(fromJson: toDouble) double? longitude,
      @JsonKey(fromJson: toInt) int? nombreMaxOccupants,
      @JsonKey(defaultValue: false) bool? fetesAutorises,
      num? score});

  @override
  $PositionModelCopyWith<$Res> get position;
  @override
  $VilleModelCopyWith<$Res>? get villeModel;
  @override
  $CommuneModelCopyWith<$Res>? get communeModel;
}

/// @nodoc
class __$$BienImmobilierModelImplCopyWithImpl<$Res>
    extends _$BienImmobilierModelCopyWithImpl<$Res, _$BienImmobilierModelImpl>
    implements _$$BienImmobilierModelImplCopyWith<$Res> {
  __$$BienImmobilierModelImplCopyWithImpl(_$BienImmobilierModelImpl _value,
      $Res Function(_$BienImmobilierModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BienImmobilierModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? typeBienImmobilier = null,
    Object? typeLocation = null,
    Object? description = null,
    Object? amentities = null,
    Object? tags = null,
    Object? images = null,
    Object? adresse = null,
    Object? position = null,
    Object? statusValidation = null,
    Object? prix = null,
    Object? featured = null,
    Object? bienImmobilierDisponible = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? miniatureId = null,
    Object? pieces = null,
    Object? ville = freezed,
    Object? commune = freezed,
    Object? villeModel = freezed,
    Object? communeModel = freezed,
    Object? video = freezed,
    Object? aLouer = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? nombreMaxOccupants = freezed,
    Object? fetesAutorises = freezed,
    Object? score = freezed,
  }) {
    return _then(_$BienImmobilierModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nom: null == nom
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String,
      typeBienImmobilier: null == typeBienImmobilier
          ? _value.typeBienImmobilier
          : typeBienImmobilier // ignore: cast_nullable_to_non_nullable
              as String,
      typeLocation: null == typeLocation
          ? _value.typeLocation
          : typeLocation // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amentities: null == amentities
          ? _value._amentities
          : amentities // ignore: cast_nullable_to_non_nullable
              as List<CommoditeModel>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adresse: null == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PositionModel,
      statusValidation: null == statusValidation
          ? _value.statusValidation
          : statusValidation // ignore: cast_nullable_to_non_nullable
              as String,
      prix: null == prix
          ? _value.prix
          : prix // ignore: cast_nullable_to_non_nullable
              as int,
      featured: null == featured
          ? _value.featured
          : featured // ignore: cast_nullable_to_non_nullable
              as bool,
      bienImmobilierDisponible: null == bienImmobilierDisponible
          ? _value.bienImmobilierDisponible
          : bienImmobilierDisponible // ignore: cast_nullable_to_non_nullable
              as bool,
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
      miniatureId: null == miniatureId
          ? _value.miniatureId
          : miniatureId // ignore: cast_nullable_to_non_nullable
              as String,
      pieces: null == pieces
          ? _value._pieces
          : pieces // ignore: cast_nullable_to_non_nullable
              as List<PieceModel>,
      ville: freezed == ville
          ? _value.ville
          : ville // ignore: cast_nullable_to_non_nullable
              as String?,
      commune: freezed == commune
          ? _value.commune
          : commune // ignore: cast_nullable_to_non_nullable
              as String?,
      villeModel: freezed == villeModel
          ? _value.villeModel
          : villeModel // ignore: cast_nullable_to_non_nullable
              as VilleModel?,
      communeModel: freezed == communeModel
          ? _value.communeModel
          : communeModel // ignore: cast_nullable_to_non_nullable
              as CommuneModel?,
      video: freezed == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as String?,
      aLouer: null == aLouer
          ? _value.aLouer
          : aLouer // ignore: cast_nullable_to_non_nullable
              as bool,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      nombreMaxOccupants: freezed == nombreMaxOccupants
          ? _value.nombreMaxOccupants
          : nombreMaxOccupants // ignore: cast_nullable_to_non_nullable
              as int?,
      fetesAutorises: freezed == fetesAutorises
          ? _value.fetesAutorises
          : fetesAutorises // ignore: cast_nullable_to_non_nullable
              as bool?,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as num?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BienImmobilierModelImpl implements _BienImmobilierModel {
  _$BienImmobilierModelImpl(
      {this.id = '',
      this.nom = '',
      this.typeBienImmobilier = '',
      this.typeLocation = '',
      this.description = '',
      final List<CommoditeModel> amentities = const [],
      final List<String> tags = const [],
      final List<String> images = const [],
      this.adresse = '',
      this.position = const PositionModel(),
      this.statusValidation = '',
      this.prix = 0,
      this.featured = false,
      this.bienImmobilierDisponible = true,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.miniatureId = '',
      final List<PieceModel> pieces = const [],
      this.ville = '',
      this.commune = '',
      @JsonKey(name: 'ville_model') this.villeModel,
      @JsonKey(name: 'commune_model') this.communeModel,
      this.video = '',
      this.aLouer = false,
      @JsonKey(fromJson: toDouble) this.latitude,
      @JsonKey(fromJson: toDouble) this.longitude,
      @JsonKey(fromJson: toInt) this.nombreMaxOccupants,
      @JsonKey(defaultValue: false) this.fetesAutorises,
      this.score})
      : _amentities = amentities,
        _tags = tags,
        _images = images,
        _pieces = pieces;

  factory _$BienImmobilierModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BienImmobilierModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String nom;
  @override
  @JsonKey()
  final String typeBienImmobilier;
  @override
  @JsonKey()
  final String typeLocation;
  @override
  @JsonKey()
  final String description;
  final List<CommoditeModel> _amentities;
  @override
  @JsonKey()
  List<CommoditeModel> get amentities {
    if (_amentities is EqualUnmodifiableListView) return _amentities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amentities);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey()
  final String adresse;
  @override
  @JsonKey()
  final PositionModel position;
  @override
  @JsonKey()
  final String statusValidation;
  @override
  @JsonKey()
  final int prix;
  @override
  @JsonKey()
  final bool featured;
  @override
  @JsonKey()
  final bool bienImmobilierDisponible;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  @JsonKey()
  final String miniatureId;
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
  final String? ville;
  @override
  @JsonKey()
  final String? commune;
  @override
  @JsonKey(name: 'ville_model')
  final VilleModel? villeModel;
  @override
  @JsonKey(name: 'commune_model')
  final CommuneModel? communeModel;
  @override
  @JsonKey()
  final String? video;
  @override
  @JsonKey()
  final bool aLouer;
// 🔥 Ces champs manquants
  @override
  @JsonKey(fromJson: toDouble)
  final double? latitude;
  @override
  @JsonKey(fromJson: toDouble)
  final double? longitude;
  @override
  @JsonKey(fromJson: toInt)
  final int? nombreMaxOccupants;
  @override
  @JsonKey(defaultValue: false)
  final bool? fetesAutorises;
  @override
  final num? score;

  @override
  String toString() {
    return 'BienImmobilierModel(id: $id, nom: $nom, typeBienImmobilier: $typeBienImmobilier, typeLocation: $typeLocation, description: $description, amentities: $amentities, tags: $tags, images: $images, adresse: $adresse, position: $position, statusValidation: $statusValidation, prix: $prix, featured: $featured, bienImmobilierDisponible: $bienImmobilierDisponible, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, miniatureId: $miniatureId, pieces: $pieces, ville: $ville, commune: $commune, villeModel: $villeModel, communeModel: $communeModel, video: $video, aLouer: $aLouer, latitude: $latitude, longitude: $longitude, nombreMaxOccupants: $nombreMaxOccupants, fetesAutorises: $fetesAutorises, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BienImmobilierModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.typeBienImmobilier, typeBienImmobilier) ||
                other.typeBienImmobilier == typeBienImmobilier) &&
            (identical(other.typeLocation, typeLocation) ||
                other.typeLocation == typeLocation) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._amentities, _amentities) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.adresse, adresse) || other.adresse == adresse) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.statusValidation, statusValidation) ||
                other.statusValidation == statusValidation) &&
            (identical(other.prix, prix) || other.prix == prix) &&
            (identical(other.featured, featured) ||
                other.featured == featured) &&
            (identical(
                    other.bienImmobilierDisponible, bienImmobilierDisponible) ||
                other.bienImmobilierDisponible == bienImmobilierDisponible) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.miniatureId, miniatureId) ||
                other.miniatureId == miniatureId) &&
            const DeepCollectionEquality().equals(other._pieces, _pieces) &&
            (identical(other.ville, ville) || other.ville == ville) &&
            (identical(other.commune, commune) || other.commune == commune) &&
            (identical(other.villeModel, villeModel) ||
                other.villeModel == villeModel) &&
            (identical(other.communeModel, communeModel) ||
                other.communeModel == communeModel) &&
            (identical(other.video, video) || other.video == video) &&
            (identical(other.aLouer, aLouer) || other.aLouer == aLouer) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.nombreMaxOccupants, nombreMaxOccupants) ||
                other.nombreMaxOccupants == nombreMaxOccupants) &&
            (identical(other.fetesAutorises, fetesAutorises) ||
                other.fetesAutorises == fetesAutorises) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        nom,
        typeBienImmobilier,
        typeLocation,
        description,
        const DeepCollectionEquality().hash(_amentities),
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_images),
        adresse,
        position,
        statusValidation,
        prix,
        featured,
        bienImmobilierDisponible,
        createdAt,
        updatedAt,
        deletedAt,
        miniatureId,
        const DeepCollectionEquality().hash(_pieces),
        ville,
        commune,
        villeModel,
        communeModel,
        video,
        aLouer,
        latitude,
        longitude,
        nombreMaxOccupants,
        fetesAutorises,
        score
      ]);

  /// Create a copy of BienImmobilierModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BienImmobilierModelImplCopyWith<_$BienImmobilierModelImpl> get copyWith =>
      __$$BienImmobilierModelImplCopyWithImpl<_$BienImmobilierModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BienImmobilierModelImplToJson(
      this,
    );
  }
}

abstract class _BienImmobilierModel implements BienImmobilierModel {
  factory _BienImmobilierModel(
      {final String id,
      final String nom,
      final String typeBienImmobilier,
      final String typeLocation,
      final String description,
      final List<CommoditeModel> amentities,
      final List<String> tags,
      final List<String> images,
      final String adresse,
      final PositionModel position,
      final String statusValidation,
      final int prix,
      final bool featured,
      final bool bienImmobilierDisponible,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final DateTime? deletedAt,
      final String miniatureId,
      final List<PieceModel> pieces,
      final String? ville,
      final String? commune,
      @JsonKey(name: 'ville_model') final VilleModel? villeModel,
      @JsonKey(name: 'commune_model') final CommuneModel? communeModel,
      final String? video,
      final bool aLouer,
      @JsonKey(fromJson: toDouble) final double? latitude,
      @JsonKey(fromJson: toDouble) final double? longitude,
      @JsonKey(fromJson: toInt) final int? nombreMaxOccupants,
      @JsonKey(defaultValue: false) final bool? fetesAutorises,
      final num? score}) = _$BienImmobilierModelImpl;

  factory _BienImmobilierModel.fromJson(Map<String, dynamic> json) =
      _$BienImmobilierModelImpl.fromJson;

  @override
  String get id;
  @override
  String get nom;
  @override
  String get typeBienImmobilier;
  @override
  String get typeLocation;
  @override
  String get description;
  @override
  List<CommoditeModel> get amentities;
  @override
  List<String> get tags;
  @override
  List<String> get images;
  @override
  String get adresse;
  @override
  PositionModel get position;
  @override
  String get statusValidation;
  @override
  int get prix;
  @override
  bool get featured;
  @override
  bool get bienImmobilierDisponible;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get deletedAt;
  @override
  String get miniatureId;
  @override
  List<PieceModel> get pieces;
  @override
  String? get ville;
  @override
  String? get commune;
  @override
  @JsonKey(name: 'ville_model')
  VilleModel? get villeModel;
  @override
  @JsonKey(name: 'commune_model')
  CommuneModel? get communeModel;
  @override
  String? get video;
  @override
  bool get aLouer; // 🔥 Ces champs manquants
  @override
  @JsonKey(fromJson: toDouble)
  double? get latitude;
  @override
  @JsonKey(fromJson: toDouble)
  double? get longitude;
  @override
  @JsonKey(fromJson: toInt)
  int? get nombreMaxOccupants;
  @override
  @JsonKey(defaultValue: false)
  bool? get fetesAutorises;
  @override
  num? get score;

  /// Create a copy of BienImmobilierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BienImmobilierModelImplCopyWith<_$BienImmobilierModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
