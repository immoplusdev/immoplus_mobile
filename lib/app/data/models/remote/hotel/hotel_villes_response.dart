import 'package:freezed_annotation/freezed_annotation.dart';

part 'hotel_villes_response.freezed.dart';
part 'hotel_villes_response.g.dart';

@freezed
class HotelVillesResponse with _$HotelVillesResponse {
  factory HotelVillesResponse({
    @Default('') String villeId,
    @Default('') String nombreHotels,
  }) = _HotelVillesResponse;

  factory HotelVillesResponse.fromJson(Map<String, dynamic> json) =>
      _$HotelVillesResponseFromJson(json);
}
