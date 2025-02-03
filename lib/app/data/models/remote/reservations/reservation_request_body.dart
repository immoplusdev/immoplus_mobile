import 'package:freezed_annotation/freezed_annotation.dart';

import 'dates_reservation_model.dart';

part 'reservation_request_body.freezed.dart';
part 'reservation_request_body.g.dart';

@freezed
class ReservationRequestBody with _$ReservationRequestBody {
  const factory ReservationRequestBody({
    required String residence,
    required List<DatesReservationModel> datesReservation,
    required String clientPhoneNumber,
    String? notes,
  }) = _ReservationRequestBody;

  factory ReservationRequestBody.fromJson(Map<String, dynamic> json) =>
      _$ReservationRequestBodyFromJson(json);
}
