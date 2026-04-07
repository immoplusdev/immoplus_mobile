// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservationModelImpl _$$ReservationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReservationModelImpl(
      id: json['id'] as String? ?? '',
      statusReservation: json['statusReservation'] as String? ?? '',
      datesReservation: (json['datesReservation'] as List<dynamic>?)
              ?.map((e) =>
                  DatesReservationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dateDebut: json['dateDebut'] as String? ?? '',
      dateFin: json['dateFin'] as String? ?? '',
      statusFacture: json['statusFacture'] as String? ?? '',
      retraitProEffectue: json['retraitProEffectue'] as bool? ?? false,
      montantTotalReservation:
          (json['montantTotalReservation'] as num?)?.toDouble() ?? 0,
      montantReservationSansCommission:
          (json['montantReservationSansCommission'] as num?)?.toDouble() ?? 0,
      montantPaye: (json['montantPaye'] as num?)?.toInt() ?? 0,
      codeReservation: json['codeReservation'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      clientPhoneNumber: json['clientPhoneNumber'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      delaisProprietaireReponse:
          json['delaisProprietaireReponse'] as String? ?? null,
      delaisPaiementClient: json['delaisPaiementClient'] as String? ?? null,
      residence: json['residence'] == null
          ? const ResidenceModel()
          : ResidenceModel.fromJson(json['residence'] as Map<String, dynamic>),
      client: json['client'] == null
          ? const ClientModel()
          : ClientModel.fromJson(json['client'] as Map<String, dynamic>),
      proprietaire: json['proprietaire'] == null
          ? const ProprietaireModel()
          : ProprietaireModel.fromJson(
              json['proprietaire'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ReservationModelImplToJson(
        _$ReservationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'statusReservation': instance.statusReservation,
      'datesReservation': instance.datesReservation,
      'dateDebut': instance.dateDebut,
      'dateFin': instance.dateFin,
      'statusFacture': instance.statusFacture,
      'retraitProEffectue': instance.retraitProEffectue,
      'montantTotalReservation': instance.montantTotalReservation,
      'montantReservationSansCommission':
          instance.montantReservationSansCommission,
      'montantPaye': instance.montantPaye,
      'codeReservation': instance.codeReservation,
      'notes': instance.notes,
      'clientPhoneNumber': instance.clientPhoneNumber,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'delaisProprietaireReponse': instance.delaisProprietaireReponse,
      'delaisPaiementClient': instance.delaisPaiementClient,
      'residence': instance.residence,
      'client': instance.client,
      'proprietaire': instance.proprietaire,
    };
