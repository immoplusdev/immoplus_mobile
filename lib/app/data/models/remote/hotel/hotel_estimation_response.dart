import 'package:freezed_annotation/freezed_annotation.dart';

part 'hotel_estimation_response.freezed.dart';
part 'hotel_estimation_response.g.dart';

@freezed
class HotelEstimationResponse with _$HotelEstimationResponse {
  factory HotelEstimationResponse({
    @Default('') String hotelId,
    @Default('') String hotelName,
    @Default('') String roomTypeId,
    @Default('') String roomTypeName,
    @Default('') String checkInDate,
    @Default('') String checkOutDate,
    @Default(0) int nightCount,
    @Default(0) int adults,
    @Default(0) int children,
    required TarificationDetail tarification,
    required AcompteDetail acompte,
    @Default(0) int montantRestant,
  }) = _HotelEstimationResponse;

  factory HotelEstimationResponse.fromJson(Map<String, dynamic> json) =>
      _$HotelEstimationResponseFromJson(json);
}

@freezed
class TarificationDetail with _$TarificationDetail {
  factory TarificationDetail({
    @Default(0) int prixParNuit,
    @Default(0) int prixChambre,
    required PetitDejeunerDetail petitDejeuner,
    required TaxeSejourDetail taxeSejourPerNuit,
    @Default(0) int prixTotal,
    @Default('XOF') String devise,
  }) = _TarificationDetail;

  factory TarificationDetail.fromJson(Map<String, dynamic> json) =>
      _$TarificationDetailFromJson(json);
}

@freezed
class PetitDejeunerDetail with _$PetitDejeunerDetail {
  factory PetitDejeunerDetail({
    @Default(false) bool inclus,
    @Default(0) int prixParNuit,
    @Default(0) int prixTotal,
  }) = _PetitDejeunerDetail;

  factory PetitDejeunerDetail.fromJson(Map<String, dynamic> json) =>
      _$PetitDejeunerDetailFromJson(json);
}

@freezed
class TaxeSejourDetail with _$TaxeSejourDetail {
  factory TaxeSejourDetail({
    @Default(0) int prixParNuit,
    @Default(0) int prixParPersonne,
    @Default(0) int prixTotal,
  }) = _TaxeSejourDetail;

  factory TaxeSejourDetail.fromJson(Map<String, dynamic> json) =>
      _$TaxeSejourDetailFromJson(json);
}

@freezed
class AcompteDetail with _$AcompteDetail {
  factory AcompteDetail({
    @Default(0) int montant,
    @Default(0) int pourcentage,
    @Default('XOF') String devise,
  }) = _AcompteDetail;

  factory AcompteDetail.fromJson(Map<String, dynamic> json) =>
      _$AcompteDetailFromJson(json);
}
