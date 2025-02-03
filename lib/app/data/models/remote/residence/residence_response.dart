import 'package:freezed_annotation/freezed_annotation.dart';

import 'residence_model.dart';

part 'residence_response.freezed.dart';
part 'residence_response.g.dart';

@freezed
class ResidenceResponse with _$ResidenceResponse {
  factory ResidenceResponse({
    required ResidenceModel data,
  }) = _ResidenceResponse;

  factory ResidenceResponse.fromJson(Map<String, dynamic> json) =>
      _$ResidenceResponseFromJson(json);
}
