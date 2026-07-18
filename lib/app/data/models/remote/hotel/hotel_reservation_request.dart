import 'package:freezed_annotation/freezed_annotation.dart';

part 'hotel_reservation_request.freezed.dart';
part 'hotel_reservation_request.g.dart';

@freezed
class HotelReservationRequest with _$HotelReservationRequest {
  const factory HotelReservationRequest({
    required String roomTypeId,
    required String checkInDate,
    required String checkOutDate,
    required int adults,
    required int children,
    required bool avecPetitDejeuner,
    required String demandesSpeciales,
    required HotelVoyageur voyageur,
  }) = _HotelReservationRequest;

  factory HotelReservationRequest.fromJson(Map<String, dynamic> json) =>
      _$HotelReservationRequestFromJson(json);
}

@freezed
class HotelVoyageur with _$HotelVoyageur {
  const factory HotelVoyageur({
    required String prenom,
    required String nom,
    required String telephone,
    required String email,
  }) = _HotelVoyageur;

  factory HotelVoyageur.fromJson(Map<String, dynamic> json) =>
      _$HotelVoyageurFromJson(json);
}
