import 'package:freezed_annotation/freezed_annotation.dart';

part 'hotel_estimation_request.freezed.dart';
part 'hotel_estimation_request.g.dart';

@freezed
class HotelEstimationRequest with _$HotelEstimationRequest {
  factory HotelEstimationRequest({
    required String roomTypeId,
    required String checkInDate,
    required String checkOutDate,
    required int adults,
    required int children,
    required bool avecPetitDejeuner,
  }) = _HotelEstimationRequest;

  factory HotelEstimationRequest.fromJson(Map<String, dynamic> json) =>
      _$HotelEstimationRequestFromJson(json);
}
