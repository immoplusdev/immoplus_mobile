import 'package:freezed_annotation/freezed_annotation.dart';
import 'rating_model.dart';

part 'rating_history_response.freezed.dart';
part 'rating_history_response.g.dart';

@freezed
class RatingHistoryResponse with _$RatingHistoryResponse {
  const factory RatingHistoryResponse({
    @Default([]) List<RatingModel> data,
    @Default(0) int currentPage,
    @Default(0) int totalPages,
    @Default(0) int pageSize,
    @Default(0) int totalCount,
    @Default(false) bool hasPrevious,
    @Default(false) bool hasNext,
  }) = _RatingHistoryResponse;

  factory RatingHistoryResponse.fromJson(Map<String, dynamic> json) => _$RatingHistoryResponseFromJson(json);
}
