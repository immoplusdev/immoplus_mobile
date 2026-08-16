import 'package:freezed_annotation/freezed_annotation.dart';
import 'residence_review_model.dart';

part 'residence_reviews_response.freezed.dart';
part 'residence_reviews_response.g.dart';

@freezed
class ResidenceReviewsSummary with _$ResidenceReviewsSummary {
  const factory ResidenceReviewsSummary({
    @Default(0) int totalReviews,
  }) = _ResidenceReviewsSummary;

  factory ResidenceReviewsSummary.fromJson(Map<String, dynamic> json) =>
      _$ResidenceReviewsSummaryFromJson(json);
}

@freezed
class ResidenceReviewsResponse with _$ResidenceReviewsResponse {
  const factory ResidenceReviewsResponse({
    @Default([]) List<ResidenceReviewModel> data,
    @Default(0) int currentPage,
    @Default(0) int totalPages,
    @Default(0) int pageSize,
    @Default(0) int totalCount,
    @Default(false) bool hasPrevious,
    @Default(false) bool hasNext,
    ResidenceReviewsSummary? summary,
  }) = _ResidenceReviewsResponse;

  factory ResidenceReviewsResponse.fromJson(Map<String, dynamic> json) =>
      _$ResidenceReviewsResponseFromJson(json);
}
