import 'package:freezed_annotation/freezed_annotation.dart';
import 'relais_model.dart';

part 'relais_list_response.freezed.dart';
part 'relais_list_response.g.dart';

/// Réponse de `GET /relais` — pagination imbriquée dans `pagination`,
/// contrairement à `AlertsResponse` (champs à plat).
@freezed
class RelaisListResponse with _$RelaisListResponse {
  const factory RelaisListResponse({
    @Default([]) List<RelaisModel> data,
    RelaisPagination? pagination,
  }) = _RelaisListResponse;

  factory RelaisListResponse.fromJson(Map<String, dynamic> json) =>
      _$RelaisListResponseFromJson(json);
}

@freezed
class RelaisPagination with _$RelaisPagination {
  const factory RelaisPagination({
    @Default(1) int page,
    @Default(10) int limit,
    @Default(0) int total,
    @Default(1) int totalPages,
  }) = _RelaisPagination;

  factory RelaisPagination.fromJson(Map<String, dynamic> json) =>
      _$RelaisPaginationFromJson(json);
}
