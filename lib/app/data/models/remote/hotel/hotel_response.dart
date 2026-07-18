import 'package:freezed_annotation/freezed_annotation.dart';
import 'hotel_model.dart';

part 'hotel_response.freezed.dart';
part 'hotel_response.g.dart';

@freezed
class HotelResponse with _$HotelResponse {
  factory HotelResponse({
    required HotelModel data,
  }) = _HotelResponse;

  factory HotelResponse.fromJson(Map<String, dynamic> json) =>
      _$HotelResponseFromJson(json);
}
