// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'residence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResidenceModelImpl _$$ResidenceModelImplFromJson(Map<String, dynamic> json) =>
    _$ResidenceModelImpl(
      id: json['id'] as String? ?? '',
      miniature: json['miniature'] as String? ?? '',
      nom: json['nom'] as String? ?? '',
      typeResidence: json['typeResidence'] as String? ?? 'Appartement',
      description: json['description'] as String? ?? '',
      prixReservation: (json['prixReservation'] as num?)?.toInt() ?? 0,
      adresse: json['adresse'] as String? ?? '',
      ville: json['ville'] as String? ?? '',
      commune: json['commune'] as String? ?? '',
      position: json['position'] == null
          ? const PositionModel()
          : PositionModel.fromJson(json['position'] as Map<String, dynamic>),
      video: json['video'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      commodites: (json['commodites'] as List<dynamic>?)
              ?.map((e) => CommoditeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pieces: (json['pieces'] as List<dynamic>?)
              ?.map((e) => PieceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dureeMinSejour: (json['dureeMinSejour'] as num?)?.toInt() ?? 0,
      dureeMaxSejour: (json['dureeMaxSejour'] as num?)?.toInt() ?? 0,
      heureEntree: json['heureEntree'] as String? ?? '',
      heureDepart: json['heureDepart'] as String? ?? '',
      nombreMaxOccupants: (json['nombreMaxOccupants'] as num?)?.toInt() ?? 0,
      animauxAutorises: json['animauxAutorises'] as bool? ?? false,
      fetesAutorises: json['fetesAutorises'] as bool? ?? false,
      reglesSupplementaires: json['reglesSupplementaires'] as String? ?? '',
      residenceDisponible: json['residenceDisponible'] as bool? ?? true,
    );

Map<String, dynamic> _$$ResidenceModelImplToJson(
        _$ResidenceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'miniature': instance.miniature,
      'nom': instance.nom,
      'typeResidence': instance.typeResidence,
      'description': instance.description,
      'prixReservation': instance.prixReservation,
      'adresse': instance.adresse,
      'ville': instance.ville,
      'commune': instance.commune,
      'position': instance.position,
      'video': instance.video,
      'images': instance.images,
      'commodites': instance.commodites,
      'pieces': instance.pieces,
      'dureeMinSejour': instance.dureeMinSejour,
      'dureeMaxSejour': instance.dureeMaxSejour,
      'heureEntree': instance.heureEntree,
      'heureDepart': instance.heureDepart,
      'nombreMaxOccupants': instance.nombreMaxOccupants,
      'animauxAutorises': instance.animauxAutorises,
      'fetesAutorises': instance.fetesAutorises,
      'reglesSupplementaires': instance.reglesSupplementaires,
      'residenceDisponible': instance.residenceDisponible,
    };
