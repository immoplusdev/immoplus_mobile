import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating_model.freezed.dart';
part 'rating_model.g.dart';

@freezed
class RatingModel with _$RatingModel {
  const factory RatingModel({
    @Default('') String reservationId,
    @Default('') String propertyId,
    @Default('') String perspective,
    @Default('') String ratedAt,
    @Default(0) int propertyRating,
    @Default(0) int hostRating,
    @Default('') String propertyFeedback,
    @Default('') String hostFeedback,
    @Default([]) List<String> tags,
    @Default(0) int clientRating,
    @Default('') String clientFeedback,
    @Default('') String guestBehavior,
    @Default('') String propertyCondition,
    @Default(false) bool wouldRecommend,
  }) = _RatingModel;

  factory RatingModel.fromJson(Map<String, dynamic> json) => _$RatingModelFromJson(json);
}
