// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConfigModelImpl _$$ConfigModelImplFromJson(Map<String, dynamic> json) =>
    _$ConfigModelImpl(
      data: json['data'] == null
          ? null
          : ConfigData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ConfigModelImplToJson(_$ConfigModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$ConfigDataImpl _$$ConfigDataImplFromJson(Map<String, dynamic> json) =>
    _$ConfigDataImpl(
      id: json['id'] as String? ?? '',
      websiteUrl: json['websiteUrl'] as String? ?? '',
      normalVisitPrice: (json['normalVisitPrice'] as num?)?.toInt() ?? 0,
      expressVisitPrice: (json['expressVisitPrice'] as num?)?.toInt() ?? 0,
      pourcentageCommissionReservation:
          (json['pourcentageCommissionReservation'] as num?)?.toInt() ?? 0,
      projectName: json['projectName'] as String? ?? '',
      projectUrl: json['projectUrl'] as String? ?? '',
      smsSenderName: json['smsSenderName'] as String? ?? '',
      proximityRadius: (json['proximityRadius'] as num?)?.toDouble() ?? 0.0,
      standardShippingPrice:
          (json['standardShippingPrice'] as num?)?.toDouble() ?? 0.0,
      flashShippingPrice:
          (json['flashShippingPrice'] as num?)?.toDouble() ?? 0.0,
      contactEmail: json['contactEmail'] as String? ?? '',
      contactPhoneNumber: json['contactPhoneNumber'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      categories: json['categories'] as List<dynamic>? ?? const [],
      categoryPaymentTypes:
          json['categoryPaymentTypes'] as List<dynamic>? ?? const [],
      defaultStatus: json['defaultStatus'] as List<dynamic>? ?? const [],
      galleryGroups: json['galleryGroups'] as List<dynamic>? ?? const [],
      languages: json['languages'] as List<dynamic>? ?? const [],
      orderPaymentTypes:
          json['orderPaymentTypes'] as List<dynamic>? ?? const [],
      paymentStatus: json['paymentStatus'] as List<dynamic>? ?? const [],
      productTypes: json['productTypes'] as List<dynamic>? ?? const [],
      servicePaymentTypes:
          json['servicePaymentTypes'] as List<dynamic>? ?? const [],
      serviceStatus: json['serviceStatus'] as List<dynamic>? ?? const [],
      shippingStatus: json['shippingStatus'] as List<dynamic>? ?? const [],
      shippingTypes: json['shippingTypes'] as List<dynamic>? ?? const [],
      visitPaymentTypes:
          json['visitPaymentTypes'] as List<dynamic>? ?? const [],
      typesResidence: (json['typesResidence'] as List<dynamic>?)
              ?.map((e) => TypesResidence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      typesDemandeVisite: (json['typesDemandeVisite'] as List<dynamic>?)
              ?.map(
                  (e) => TypesDemandeVisite.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ConfigDataImplToJson(_$ConfigDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'websiteUrl': instance.websiteUrl,
      'normalVisitPrice': instance.normalVisitPrice,
      'expressVisitPrice': instance.expressVisitPrice,
      'pourcentageCommissionReservation':
          instance.pourcentageCommissionReservation,
      'projectName': instance.projectName,
      'projectUrl': instance.projectUrl,
      'smsSenderName': instance.smsSenderName,
      'proximityRadius': instance.proximityRadius,
      'standardShippingPrice': instance.standardShippingPrice,
      'flashShippingPrice': instance.flashShippingPrice,
      'contactEmail': instance.contactEmail,
      'contactPhoneNumber': instance.contactPhoneNumber,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'categories': instance.categories,
      'categoryPaymentTypes': instance.categoryPaymentTypes,
      'defaultStatus': instance.defaultStatus,
      'galleryGroups': instance.galleryGroups,
      'languages': instance.languages,
      'orderPaymentTypes': instance.orderPaymentTypes,
      'paymentStatus': instance.paymentStatus,
      'productTypes': instance.productTypes,
      'servicePaymentTypes': instance.servicePaymentTypes,
      'serviceStatus': instance.serviceStatus,
      'shippingStatus': instance.shippingStatus,
      'shippingTypes': instance.shippingTypes,
      'visitPaymentTypes': instance.visitPaymentTypes,
      'typesResidence': instance.typesResidence,
      'typesDemandeVisite': instance.typesDemandeVisite,
    };

_$TypesResidenceImpl _$$TypesResidenceImplFromJson(Map<String, dynamic> json) =>
    _$TypesResidenceImpl(
      text: json['text'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );

Map<String, dynamic> _$$TypesResidenceImplToJson(
        _$TypesResidenceImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
    };

_$TypesDemandeVisiteImpl _$$TypesDemandeVisiteImplFromJson(
        Map<String, dynamic> json) =>
    _$TypesDemandeVisiteImpl(
      text: json['text'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );

Map<String, dynamic> _$$TypesDemandeVisiteImplToJson(
        _$TypesDemandeVisiteImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
    };
