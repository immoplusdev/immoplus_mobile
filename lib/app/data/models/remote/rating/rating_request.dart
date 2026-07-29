import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating_request.freezed.dart';
part 'rating_request.g.dart';

@freezed
class RatingRequest with _$RatingRequest {
  const factory RatingRequest({
    required String reservationId,
    required int propertyRating,
    required String propertyFeedback,
    required int hostRating,
    required String hostFeedback,
    required List<String> propertyTags,
  }) = _RatingRequest;

  factory RatingRequest.fromJson(Map<String, dynamic> json) => _$RatingRequestFromJson(json);
}
