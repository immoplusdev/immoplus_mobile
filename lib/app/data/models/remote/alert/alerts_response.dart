import 'package:freezed_annotation/freezed_annotation.dart';
import 'alert_model.dart';

part 'alerts_response.freezed.dart';
part 'alerts_response.g.dart';

@freezed
class AlertsResponse with _$AlertsResponse {
  const factory AlertsResponse({
    required List<AlertModel> data,
    required int? currentPage,
    required int? totalPages,
    required int? pageSize,
    required int? totalCount,
    required bool? hasPrevious,
    required bool? hasNext,
  }) = _AlertsResponse;

  factory AlertsResponse.fromJson(Map<String, dynamic> json) =>
      _$AlertsResponseFromJson(json);
}
