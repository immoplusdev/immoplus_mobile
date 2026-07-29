import 'package:freezed_annotation/freezed_annotation.dart';

part 'hotel_payment_request.freezed.dart';
part 'hotel_payment_request.g.dart';

@freezed
class HotelPaymentRequest with _$HotelPaymentRequest {
  const factory HotelPaymentRequest({
    required String paymentMethod,
    required String paymentCredentials,
  }) = _HotelPaymentRequest;

  factory HotelPaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$HotelPaymentRequestFromJson(json);
}
