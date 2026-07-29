import 'package:freezed_annotation/freezed_annotation.dart';
import '../payment/payment_itent_data.dart';
import '../payment/next_action_model.dart';

part 'hotel_payment_response.freezed.dart';
part 'hotel_payment_response.g.dart';

@freezed
class HotelPaymentResponse with _$HotelPaymentResponse {
  const HotelPaymentResponse._();

  const factory HotelPaymentResponse({
    required String paiementId,
    required String reservationId,
    required String statut,
    required int montant,
    required String devise,
    required String paymentMethod,
    @Default(null) Hub2NextAction? nextAction,
    @Default(null) String? lienPaiement,
  }) = _HotelPaymentResponse;

  factory HotelPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$HotelPaymentResponseFromJson(json);

  PaymentItentData toPaymentIntentData() {
    return PaymentItentData(
      id: paiementId,
      amount: montant,
      paymentStatus: statut,
      paymentMethod: paymentMethod,
      itemId: reservationId,
      hub2NextAction: nextAction,
      hub2PaymentId: paiementId,
    );
  }
}
