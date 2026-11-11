import 'package:freezed_annotation/freezed_annotation.dart';

import 'dates_reservation_model.dart';

part 'payment_requirement_body.freezed.dart';
part 'payment_requirement_body.g.dart';

/// Corps de `POST /reservations/action/payment-requirement`.
@freezed
class PaymentRequirementBody with _$PaymentRequirementBody {
  const factory PaymentRequirementBody({
    required String residence,
    required List<DatesReservationModel> datesReservation,
  }) = _PaymentRequirementBody;

  factory PaymentRequirementBody.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequirementBodyFromJson(json);
}
