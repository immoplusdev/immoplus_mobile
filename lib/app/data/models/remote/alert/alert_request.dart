import 'package:freezed_annotation/freezed_annotation.dart';
import 'alert_model.dart';

part 'alert_request.freezed.dart';
part 'alert_request.g.dart';

@freezed
class AlertRequest with _$AlertRequest {
  const AlertRequest._();

  const factory AlertRequest({
    required String title,
    @Default('bien_immobilier') String targetType,
    String? descriptionClient,
    required AlertCriteriaModel criteria,
  }) = _AlertRequest;

  factory AlertRequest.fromJson(Map<String, dynamic> json) =>
      _$AlertRequestFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'targetType': targetType,
      if (descriptionClient != null) 'descriptionClient': descriptionClient,
      'criteria': criteria.toJson(),
    };
  }
}
