import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/constants/constantes.dart';

part 'hotel_model.freezed.dart';
part 'hotel_model.g.dart';

@freezed
class HotelModel with _$HotelModel {
  factory HotelModel({
    @Default('') String id,
    @Default('') String ownerUserId,
    @Default('') String name,
    @Default('') String type,
    @Default(0) int stars,
    @Default('') String status,
    @Default('') String villeId,
    @Default('') String communeId,
    @Default('') String address,
    @JsonKey(fromJson: toDouble) double? lat,
    @JsonKey(fromJson: toDouble) double? lng,
    @Default('') String descriptionShort,
    @Default('') String descriptionLong,
    @Default('') String coverFileId,
    @Default([]) List<String> images,
    @Default('') String videoFileId,
    @Default('') String droneVideoFileId,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String website,
    @Default(HotelAmenities()) HotelAmenities amenities,
    @Default([]) List<String> paymentMethods,
    @Default(0) int depositPercent,
    @Default('') String cancellationPolicy,
    @Default(0) int touristTax,
    @Default('') String checkInTime,
    @Default('') String checkOutTime,
    @Default(0) int capacityRooms,
    @Default(0) int completionScore,
    @Default('') String badge,
    PayoutAccount? payoutAccount,
    @Default('') String managerFullName,
    @Default('') String managerPhone,
    @Default('') String rccm,
    @Default('') String idCardFrontFileId,
    @Default('') String idCardBackFileId,
    String? rejectionReason,
    String? submittedAt,
    String? publishedAt,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    @Default(0) int isSponsored,
    String? sponsorshipTier,
    String? sponsoredUntil,
    @Default([]) List<ChambreDisponible> chambresDisponibles,
  }) = _HotelModel;

  const HotelModel._();

  double get firstRoomPrice {
    if (chambresDisponibles.isNotEmpty) {
      return chambresDisponibles.first.basePrice.toDouble();
    }
    return touristTax.toDouble();
  }

  factory HotelModel.fromJson(Map<String, dynamic> json) =>
      _$HotelModelFromJson(json);
}

@freezed
class PayoutAccount with _$PayoutAccount {
  factory PayoutAccount({
    @Default('') String type,
    @Default('') String phone,
    @Default('') String accountName,
  }) = _PayoutAccount;

  factory PayoutAccount.fromJson(Map<String, dynamic> json) =>
      _$PayoutAccountFromJson(json);
}

@freezed
class ChambreDisponible with _$ChambreDisponible {
  factory ChambreDisponible({
    @Default('') String id,
    @Default('') String name,
    @Default(0) int bedCount,
    @Default(0) int maxOccupancy,
    @Default('') String bedType,
    String? view,
    @Default(0) int basePrice,
    @Default([]) List<String> images,
    @Default([]) List<String> amenities,
  }) = _ChambreDisponible;

  factory ChambreDisponible.fromJson(Map<String, dynamic> json) =>
      _$ChambreDisponibleFromJson(json);
}

@freezed
class HotelAmenities with _$HotelAmenities {
  const factory HotelAmenities({
    @Default(ChambreAmenities()) ChambreAmenities chambre,
    @Default(GeneralAmenities()) GeneralAmenities general,
    @Default(ServicesAmenities()) ServicesAmenities services,
    @Default(BienEtreAmenities()) BienEtreAmenities bienEtre,
    @Default(RestaurationAmenities()) RestaurationAmenities restauration,
  }) = _HotelAmenities;

  factory HotelAmenities.fromJson(Map<String, dynamic> json) =>
      _$HotelAmenitiesFromJson(json);
}

@freezed
class ChambreAmenities with _$ChambreAmenities {
  const factory ChambreAmenities({
    @Default(false) bool balcon,
    @Default(false) bool minibar,
    @JsonKey(name: 'vue_mer') @Default(false) bool vueMer,
    @JsonKey(name: 'tv_cable') @Default(false) bool tvCable,
    @Default(false) bool baignoire,
    @JsonKey(name: 'coffre_fort_chambre')
    @Default(false)
    bool coffreFortChambre,
  }) = _ChambreAmenities;

  factory ChambreAmenities.fromJson(Map<String, dynamic> json) =>
      _$ChambreAmenitiesFromJson(json);
}

@freezed
class GeneralAmenities with _$GeneralAmenities {
  const factory GeneralAmenities({
    @Default(false) bool wifi,
    @Default(false) bool parking,
    @Default(false) bool ascenseur,
    @Default(false) bool generateur,
    @Default(false) bool climatisation,
    @JsonKey(name: 'reception_24h') @Default(false) bool reception24h,
  }) = _GeneralAmenities;

  factory GeneralAmenities.fromJson(Map<String, dynamic> json) =>
      _$GeneralAmenitiesFromJson(json);
}

@freezed
class ServicesAmenities with _$ServicesAmenities {
  const factory ServicesAmenities({
    @JsonKey(name: 'coffre_fort') @Default(false) bool coffreFort,
    @Default(false) bool conciergerie,
    @Default(false) bool blanchisserie,
    @JsonKey(name: 'navette_aeroport') @Default(false) bool navetteAeroport,
    @JsonKey(name: 'salle_conference') @Default(false) bool salleConference,
  }) = _ServicesAmenities;

  factory ServicesAmenities.fromJson(Map<String, dynamic> json) =>
      _$ServicesAmenitiesFromJson(json);
}

@freezed
class BienEtreAmenities with _$BienEtreAmenities {
  const factory BienEtreAmenities({
    @Default(false) bool spa,
    @Default(false) bool hammam,
    @Default(false) bool jacuzzi,
    @Default(false) bool piscine,
    @JsonKey(name: 'salle_de_sport') @Default(false) bool salleDeSport,
  }) = _BienEtreAmenities;

  factory BienEtreAmenities.fromJson(Map<String, dynamic> json) =>
      _$BienEtreAmenitiesFromJson(json);
}

@freezed
class RestaurationAmenities with _$RestaurationAmenities {
  const factory RestaurationAmenities({
    @Default(false) bool bar,
    @Default(false) bool terrasse,
    @Default(false) bool restaurant,
    @JsonKey(name: 'room_service') @Default(false) bool roomService,
    @JsonKey(name: 'petit_dejeuner') @Default(false) bool petitDejeuner,
  }) = _RestaurationAmenities;

  factory RestaurationAmenities.fromJson(Map<String, dynamic> json) =>
      _$RestaurationAmenitiesFromJson(json);
}
