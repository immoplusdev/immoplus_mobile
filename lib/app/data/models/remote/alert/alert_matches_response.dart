import 'package:freezed_annotation/freezed_annotation.dart';
import 'alert_match_model.dart';

part 'alert_matches_response.freezed.dart';
part 'alert_matches_response.g.dart';

@freezed
class AlertMatchesResponse with _$AlertMatchesResponse {
  const factory AlertMatchesResponse({
    String? alertId,
    @Default([]) List<AlertMatchModel> matches,
    @Default(false) bool fromCache,
  }) = _AlertMatchesResponse;

  factory AlertMatchesResponse.fromJson(Map<String, dynamic> json) =>
      _$AlertMatchesResponseFromJson(json);
}
