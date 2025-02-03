import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_model.freezed.dart';
part 'config_model.g.dart';

@freezed
class ConfigModel with _$ConfigModel {
  factory ConfigModel({
    ConfigData? data,
  }) = _ConfigModel;

  factory ConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ConfigModelFromJson(json);
}

@freezed
class ConfigData with _$ConfigData {
  factory ConfigData({
    @Default('') String id,
    @Default('') String websiteUrl,
    @Default(0) int normalVisitPrice,
    @Default(0) int expressVisitPrice,
    @Default(0) int pourcentageCommissionReservation,
    @Default('') String projectName,
    @Default('') String projectUrl,
    @Default('') String smsSenderName,
    @Default(0.0) double proximityRadius,
    @Default(0.0) double standardShippingPrice,
    @Default(0.0) double flashShippingPrice,
    @Default('') String contactEmail,
    @Default('') String contactPhoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    @Default([]) List<dynamic> categories,
    @Default([]) List<dynamic> categoryPaymentTypes,
    @Default([]) List<dynamic> defaultStatus,
    @Default([]) List<dynamic> galleryGroups,
    @Default([]) List<dynamic> languages,
    @Default([]) List<dynamic> orderPaymentTypes,
    @Default([]) List<dynamic> paymentStatus,
    @Default([]) List<dynamic> productTypes,
    @Default([]) List<dynamic> servicePaymentTypes,
    @Default([]) List<dynamic> serviceStatus,
    @Default([]) List<dynamic> shippingStatus,
    @Default([]) List<dynamic> shippingTypes,
    @Default([]) List<dynamic> visitPaymentTypes,
    @Default([]) List<TypesResidence> typesResidence,
    @Default([]) List<TypesDemandeVisite> typesDemandeVisite,
  }) = _ConfigData;

  factory ConfigData.fromJson(Map<String, dynamic> json) =>
      _$ConfigDataFromJson(json);
}

@freezed
class TypesResidence with _$TypesResidence {
  const factory TypesResidence({
    @Default('') String text,
    @Default('') String value,
  }) = _TypesResidence;

  factory TypesResidence.fromJson(Map<String, dynamic> json) =>
      _$TypesResidenceFromJson(json);
}

@freezed
class TypesDemandeVisite with _$TypesDemandeVisite {
  const factory TypesDemandeVisite({
    @Default('') String text,
    @Default('') String value,
  }) = _TypesDemandeVisite;

  factory TypesDemandeVisite.fromJson(Map<String, dynamic> json) =>
      _$TypesDemandeVisiteFromJson(json);
}
