import 'package:freezed_annotation/freezed_annotation.dart';

part 'residence_review_model.freezed.dart';
part 'residence_review_model.g.dart';

@freezed
class ResidenceReviewModel with _$ResidenceReviewModel {
  const factory ResidenceReviewModel({
    @Default('') String reservationId,
    @Default('') String residenceId,
    @Default('') String reviewerId,
    @Default('') String reviewerName,
    String? reviewerAvatarId,
    String? ratedAt,
    @Default(0) int propertyRating,
    @Default(0) int hostRating,
    String? propertyFeedback,
    String? hostFeedback,
    @Default([]) List<String> tags,
  }) = _ResidenceReviewModel;

  factory ResidenceReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ResidenceReviewModelFromJson(json);
}
