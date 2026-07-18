import 'package:freezed_annotation/freezed_annotation.dart';

part 'hotel_payment_methods_response.freezed.dart';
part 'hotel_payment_methods_response.g.dart';

@freezed
class HotelPaymentMethodsResponse with _$HotelPaymentMethodsResponse {
  const factory HotelPaymentMethodsResponse({
    required String hotelId,
    required String hotelNom,
    required List<HotelPaymentMethod> availableMethods,
  }) = _HotelPaymentMethodsResponse;

  factory HotelPaymentMethodsResponse.fromJson(Map<String, dynamic> json) =>
      _$HotelPaymentMethodsResponseFromJson(json);
}

@freezed
class HotelPaymentMethod with _$HotelPaymentMethod {
  const factory HotelPaymentMethod({
    required String id,
    required String nom,
    required String description,
    required int fees,
    required int minAmount,
    required int maxAmount,
    @JsonKey(name: 'estimated_time') required String estimatedTime,
  }) = _HotelPaymentMethod;

  factory HotelPaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$HotelPaymentMethodFromJson(json);
}
