import 'package:freezed_annotation/freezed_annotation.dart';

part 'motif_echec_reponse_model.freezed.dart';
part 'motif_echec_reponse_model.g.dart';

@freezed
class MotifEchecReponseData with _$MotifEchecReponseData {
  const factory MotifEchecReponseData({
    @Default('') String actor,
    @Default('') String status,
    @Default('') String reasonCode,
    String? comment,
    String? respondedAt,
  }) = _MotifEchecReponseData;

  factory MotifEchecReponseData.fromJson(Map<String, dynamic> json) =>
      _$MotifEchecReponseDataFromJson(json);
}

@freezed
class MotifEchecReponseModel with _$MotifEchecReponseModel {
  const factory MotifEchecReponseModel({
    @Default(MotifEchecReponseData()) MotifEchecReponseData data,
  }) = _MotifEchecReponseModel;

  factory MotifEchecReponseModel.fromJson(Map<String, dynamic> json) =>
      _$MotifEchecReponseModelFromJson(json);
}
