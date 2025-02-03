import 'package:freezed_annotation/freezed_annotation.dart';

import 'reservation_model.dart';

part 'reservation_response.freezed.dart';
part 'reservation_response.g.dart';

@freezed
class ReservationResponse with _$ReservationResponse {
  factory ReservationResponse({
    required ReservationModel data,
  }) = _ReservationResponse;

  factory ReservationResponse.fromJson(Map<String, dynamic> json) =>
      _$ReservationResponseFromJson(json);
}
