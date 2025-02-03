import 'package:freezed_annotation/freezed_annotation.dart';

part 'additional_data_model.freezed.dart';
part 'additional_data_model.g.dart';

@freezed
class AdditionalDataModel with _$AdditionalDataModel {
  const factory AdditionalDataModel({
    String? id,
    String? user,
    String? lieuNaissance,
    String? activite,
    String? photoIdentiteId,
    String? pieceIdentiteId,
    String? nomEntreprise,
    String? registreCommerceId,
    String? emailEntreprise,
    String? numeroContribuable,
    String? typeEntreprise,
  }) = _AdditionalDataModel;

  factory AdditionalDataModel.fromJson(Map<String, dynamic> json) =>
      _$AdditionalDataModelFromJson(json);
}
