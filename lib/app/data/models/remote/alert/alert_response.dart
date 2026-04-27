import 'package:freezed_annotation/freezed_annotation.dart';
import 'alert_model.dart';

part 'alert_response.freezed.dart';
part 'alert_response.g.dart';

@freezed
class AlertResponse with _$AlertResponse {
  const factory AlertResponse({
    required AlertModel data,
  }) = _AlertResponse;

  factory AlertResponse.fromJson(Map<String, dynamic> json) =>
      _$AlertResponseFromJson(json);
}
