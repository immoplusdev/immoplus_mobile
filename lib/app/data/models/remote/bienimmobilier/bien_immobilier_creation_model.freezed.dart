// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bien_immobilier_creation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BienImmobilierCreationModel _$BienImmobilierCreationModelFromJson(
    Map<String, dynamic> json) {
  return _BienImmobilierCreationModel.fromJson(json);
}

/// @nodoc
mixin _$BienImmobilierCreationModel {
  String get miniature => throw _privateConstructorUsedError;
  String get typeLocation => throw _privateConstructorUsedError;
  String? get nom => throw _privateConstructorUsedError;
  String? get typeBienImmobilier => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<CommoditeModel>? get amentities => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  String? get video => throw _privateConstructorUsedError;
  String? get ville => throw _privateConstructorUsedError;
  String? get commune => throw _privateConstructorUsedError;
  String? get adresse => throw _privateConstructorUsedError;
  PositionModel? get position => throw _privateConstructorUsedError;
  int? get prix => throw _privateConstructorUsedError;
  bool? get bienImmobilierDisponible => throw _privateConstructorUsedError;
  List<PieceModel> get pieces => throw _privateConstructorUsedError;

  /// Serializes this BienImmobilierCreationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BienImmobilierCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BienImmobilierCreationModelCopyWith<BienImmobilierCreationModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BienImmobilierCreationModelCopyWith<$Res> {
  factory $BienImmobilierCreationModelCopyWith(
          BienImmobilierCreationModel value,
          $Res Function(BienImmobilierCreationModel) then) =
      _$BienImmobilierCreationModelCopyWithImpl<$Res,
          BienImmobilierCreationModel>;
  @useResult
  $Res call(
      {String miniature,
      String typeLocation,
      String? nom,
      String? typeBienImmobilier,
      String? description,
      List<CommoditeModel>? amentities,
      List<String>? tags,
      List<String>? images,
      String? video,
      String? ville,
      String? commune,
      String? adresse,
      PositionModel? position,
      int? prix,
      bool? bienImmobilierDisponible,
      List<PieceModel> pieces});

  $PositionModelCopyWith<$Res>? get position;
}

/// @nodoc
class _$BienImmobilierCreationModelCopyWithImpl<$Res,
        $Val extends BienImmobilierCreationModel>
    implements $BienImmobilierCreationModelCopyWith<$Res> {
  _$BienImmobilierCreationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BienImmobilierCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? miniature = null,
    Object? typeLocation = null,
    Object? nom = freezed,
    Object? typeBienImmobilier = freezed,
    Object? description = freezed,
    Object? amentities = freezed,
    Object? tags = freezed,
    Object? images = freezed,
    Object? video = freezed,
    Object? ville = freezed,
    Object? commune = freezed,
    Object? adresse = freezed,
    Object? position = freezed,
    Object? prix = freezed,
    Object? bienImmobilierDisponible = freezed,
    Object? pieces = null,
  }) {
    return _then(_value.copyWith(
      miniature: null == miniature
          ? _value.miniature
          : miniature // ignore: cast_nullable_to_non_nullable
              as String,
      typeLocation: null == typeLocation
          ? _value.typeLocation
          : typeLocation // ignore: cast_nullable_to_non_nullable
              as String,
      nom: freezed == nom
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String?,
      typeBienImmobilier: freezed == typeBienImmobilier
          ? _value.typeBienImmobilier
          : typeBienImmobilier // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      amentities: freezed == amentities
          ? _value.amentities
          : amentities // ignore: cast_nullable_to_non_nullable
              as List<CommoditeModel>?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      video: freezed == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as String?,
      ville: freezed == ville
          ? _value.ville
          : ville // ignore: cast_nullable_to_non_nullable
              as String?,
      commune: freezed == commune
          ? _value.commune
          : commune // ignore: cast_nullable_to_non_nullable
              as String?,
      adresse: freezed == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PositionModel?,
      prix: freezed == prix
          ? _value.prix
          : prix // ignore: cast_nullable_to_non_nullable
              as int?,
      bienImmobilierDisponible: freezed == bienImmobilierDisponible
          ? _value.bienImmobilierDisponible
          : bienImmobilierDisponible // ignore: cast_nullable_to_non_nullable
              as bool?,
      pieces: null == pieces
          ? _value.pieces
          : pieces // ignore: cast_nullable_to_non_nullable
              as List<PieceModel>,
    ) as $Val);
  }

  /// Create a copy of BienImmobilierCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionModelCopyWith<$Res>? get position {
    if (_value.position == null) {
      return null;
    }

    return $PositionModelCopyWith<$Res>(_value.position!, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BienImmobilierCreationModelImplCopyWith<$Res>
    implements $BienImmobilierCreationModelCopyWith<$Res> {
  factory _$$BienImmobilierCreationModelImplCopyWith(
          _$BienImmobilierCreationModelImpl value,
          $Res Function(_$BienImmobilierCreationModelImpl) then) =
      __$$BienImmobilierCreationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String miniature,
      String typeLocation,
      String? nom,
      String? typeBienImmobilier,
      String? description,
      List<CommoditeModel>? amentities,
      List<String>? tags,
      List<String>? images,
      String? video,
      String? ville,
      String? commune,
      String? adresse,
      PositionModel? position,
      int? prix,
      bool? bienImmobilierDisponible,
      List<PieceModel> pieces});

  @override
  $PositionModelCopyWith<$Res>? get position;
}

/// @nodoc
class __$$BienImmobilierCreationModelImplCopyWithImpl<$Res>
    extends _$BienImmobilierCreationModelCopyWithImpl<$Res,
        _$BienImmobilierCreationModelImpl>
    implements _$$BienImmobilierCreationModelImplCopyWith<$Res> {
  __$$BienImmobilierCreationModelImplCopyWithImpl(
      _$BienImmobilierCreationModelImpl _value,
      $Res Function(_$BienImmobilierCreationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BienImmobilierCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? miniature = null,
    Object? typeLocation = null,
    Object? nom = freezed,
    Object? typeBienImmobilier = freezed,
    Object? description = freezed,
    Object? amentities = freezed,
    Object? tags = freezed,
    Object? images = freezed,
    Object? video = freezed,
    Object? ville = freezed,
    Object? commune = freezed,
    Object? adresse = freezed,
    Object? position = freezed,
    Object? prix = freezed,
    Object? bienImmobilierDisponible = freezed,
    Object? pieces = null,
  }) {
    return _then(_$BienImmobilierCreationModelImpl(
      miniature: null == miniature
          ? _value.miniature
          : miniature // ignore: cast_nullable_to_non_nullable
              as String,
      typeLocation: null == typeLocation
          ? _value.typeLocation
          : typeLocation // ignore: cast_nullable_to_non_nullable
              as String,
      nom: freezed == nom
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String?,
      typeBienImmobilier: freezed == typeBienImmobilier
          ? _value.typeBienImmobilier
          : typeBienImmobilier // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      amentities: freezed == amentities
          ? _value._amentities
          : amentities // ignore: cast_nullable_to_non_nullable
              as List<CommoditeModel>?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      video: freezed == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as String?,
      ville: freezed == ville
          ? _value.ville
          : ville // ignore: cast_nullable_to_non_nullable
              as String?,
      commune: freezed == commune
          ? _value.commune
          : commune // ignore: cast_nullable_to_non_nullable
              as String?,
      adresse: freezed == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PositionModel?,
      prix: freezed == prix
          ? _value.prix
          : prix // ignore: cast_nullable_to_non_nullable
              as int?,
      bienImmobilierDisponible: freezed == bienImmobilierDisponible
          ? _value.bienImmobilierDisponible
          : bienImmobilierDisponible // ignore: cast_nullable_to_non_nullable
              as bool?,
      pieces: null == pieces
          ? _value._pieces
          : pieces // ignore: cast_nullable_to_non_nullable
              as List<PieceModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BienImmobilierCreationModelImpl
    implements _BienImmobilierCreationModel {
  const _$BienImmobilierCreationModelImpl(
      {this.miniature = '',
      this.typeLocation = '',
      this.nom = '',
      this.typeBienImmobilier = 'Unknown Type',
      this.description = 'No Description',
      final List<CommoditeModel>? amentities = const [],
      final List<String>? tags = const [],
      final List<String>? images = const [],
      this.video = '',
      this.ville = '',
      this.commune = '',
      this.adresse = '',
      this.position = const PositionModel(),
      this.prix = 0,
      this.bienImmobilierDisponible = true,
      final List<PieceModel> pieces = const []})
      : _amentities = amentities,
        _tags = tags,
        _images = images,
        _pieces = pieces;

  factory _$BienImmobilierCreationModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$BienImmobilierCreationModelImplFromJson(json);

  @override
  @JsonKey()
  final String miniature;
  @override
  @JsonKey()
  final String typeLocation;
  @override
  @JsonKey()
  final String? nom;
  @override
  @JsonKey()
  final String? typeBienImmobilier;
  @override
  @JsonKey()
  final String? description;
  final List<CommoditeModel>? _amentities;
  @override
  @JsonKey()
  List<CommoditeModel>? get amentities {
    final value = _amentities;
    if (value == null) return null;
    if (_amentities is EqualUnmodifiableListView) return _amentities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _tags;
  @override
  @JsonKey()
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _images;
  @override
  @JsonKey()
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final String? video;
  @override
  @JsonKey()
  final String? ville;
  @override
  @JsonKey()
  final String? commune;
  @override
  @JsonKey()
  final String? adresse;
  @override
  @JsonKey()
  final PositionModel? position;
  @override
  @JsonKey()
  final int? prix;
  @override
  @JsonKey()
  final bool? bienImmobilierDisponible;
  final List<PieceModel> _pieces;
  @override
  @JsonKey()
  List<PieceModel> get pieces {
    if (_pieces is EqualUnmodifiableListView) return _pieces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pieces);
  }

  @override
  String toString() {
    return 'BienImmobilierCreationModel(miniature: $miniature, typeLocation: $typeLocation, nom: $nom, typeBienImmobilier: $typeBienImmobilier, description: $description, amentities: $amentities, tags: $tags, images: $images, video: $video, ville: $ville, commune: $commune, adresse: $adresse, position: $position, prix: $prix, bienImmobilierDisponible: $bienImmobilierDisponible, pieces: $pieces)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BienImmobilierCreationModelImpl &&
            (identical(other.miniature, miniature) ||
                other.miniature == miniature) &&
            (identical(other.typeLocation, typeLocation) ||
                other.typeLocation == typeLocation) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.typeBienImmobilier, typeBienImmobilier) ||
                other.typeBienImmobilier == typeBienImmobilier) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._amentities, _amentities) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.video, video) || other.video == video) &&
            (identical(other.ville, ville) || other.ville == ville) &&
            (identical(other.commune, commune) || other.commune == commune) &&
            (identical(other.adresse, adresse) || other.adresse == adresse) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.prix, prix) || other.prix == prix) &&
            (identical(
                    other.bienImmobilierDisponible, bienImmobilierDisponible) ||
                other.bienImmobilierDisponible == bienImmobilierDisponible) &&
            const DeepCollectionEquality().equals(other._pieces, _pieces));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      miniature,
      typeLocation,
      nom,
      typeBienImmobilier,
      description,
      const DeepCollectionEquality().hash(_amentities),
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_images),
      video,
      ville,
      commune,
      adresse,
      position,
      prix,
      bienImmobilierDisponible,
      const DeepCollectionEquality().hash(_pieces));

  /// Create a copy of BienImmobilierCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BienImmobilierCreationModelImplCopyWith<_$BienImmobilierCreationModelImpl>
      get copyWith => __$$BienImmobilierCreationModelImplCopyWithImpl<
          _$BienImmobilierCreationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BienImmobilierCreationModelImplToJson(
      this,
    );
  }
}

abstract class _BienImmobilierCreationModel
    implements BienImmobilierCreationModel {
  const factory _BienImmobilierCreationModel(
      {final String miniature,
      final String typeLocation,
      final String? nom,
      final String? typeBienImmobilier,
      final String? description,
      final List<CommoditeModel>? amentities,
      final List<String>? tags,
      final List<String>? images,
      final String? video,
      final String? ville,
      final String? commune,
      final String? adresse,
      final PositionModel? position,
      final int? prix,
      final bool? bienImmobilierDisponible,
      final List<PieceModel> pieces}) = _$BienImmobilierCreationModelImpl;

  factory _BienImmobilierCreationModel.fromJson(Map<String, dynamic> json) =
      _$BienImmobilierCreationModelImpl.fromJson;

  @override
  String get miniature;
  @override
  String get typeLocation;
  @override
  String? get nom;
  @override
  String? get typeBienImmobilier;
  @override
  String? get description;
  @override
  List<CommoditeModel>? get amentities;
  @override
  List<String>? get tags;
  @override
  List<String>? get images;
  @override
  String? get video;
  @override
  String? get ville;
  @override
  String? get commune;
  @override
  String? get adresse;
  @override
  PositionModel? get position;
  @override
  int? get prix;
  @override
  bool? get bienImmobilierDisponible;
  @override
  List<PieceModel> get pieces;

  /// Create a copy of BienImmobilierCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BienImmobilierCreationModelImplCopyWith<_$BienImmobilierCreationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
