import 'package:freezed_annotation/freezed_annotation.dart';
import 'alert_matches_response.dart';

part 'alert_matches_api_response.freezed.dart';
part 'alert_matches_api_response.g.dart';

@freezed
class AlertMatchesApiResponse with _$AlertMatchesApiResponse {
  const factory AlertMatchesApiResponse({
    required AlertMatchesResponse data,
  }) = _AlertMatchesApiResponse;

  factory AlertMatchesApiResponse.fromJson(Map<String, dynamic> json) =>
      _$AlertMatchesApiResponseFromJson(json);
}
