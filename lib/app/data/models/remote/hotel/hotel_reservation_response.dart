import 'package:freezed_annotation/freezed_annotation.dart';

part 'hotel_reservation_response.freezed.dart';
part 'hotel_reservation_response.g.dart';

@freezed
class HotelReservationResponse with _$HotelReservationResponse {
  const factory HotelReservationResponse({
    required String reservationId,
    required String reference,
    required String statut,
    @Default(null) String? lienPaiement,
    @Default(null) HotelAcompte? acompte,
  }) = _HotelReservationResponse;

  factory HotelReservationResponse.fromJson(Map<String, dynamic> json) =>
      _$HotelReservationResponseFromJson(json);
}

@freezed
class HotelAcompte with _$HotelAcompte {
  const factory HotelAcompte({
    required int montant,
    required int pourcentage,
    required String devise,
  }) = _HotelAcompte;

  factory HotelAcompte.fromJson(Map<String, dynamic> json) =>
      _$HotelAcompteFromJson(json);
}
