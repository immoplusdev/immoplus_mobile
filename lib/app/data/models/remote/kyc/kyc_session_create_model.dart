import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_session_create_model.freezed.dart';
part 'kyc_session_create_model.g.dart';

@freezed
class KycSessionCreateModel with _$KycSessionCreateModel {
  const factory KycSessionCreateModel({
    @Default('') String url,
    @Default('') String sessionId,
  }) = _KycSessionCreateModel;

  factory KycSessionCreateModel.fromJson(Map<String, dynamic> json) =>
      _$KycSessionCreateModelFromJson(json);
}

extension KycSessionCreateModelX on KycSessionCreateModel {
  String get token {
    if (url.isEmpty) return '';
    return url.split('/').last;
  }
}
