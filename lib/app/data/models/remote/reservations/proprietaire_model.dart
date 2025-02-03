import 'package:freezed_annotation/freezed_annotation.dart';

part 'proprietaire_model.freezed.dart';
part 'proprietaire_model.g.dart';

@freezed
class ProprietaireModel with _$ProprietaireModel {
  const factory ProprietaireModel({
    @Default('') String id,
    @Default('') String email,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String phoneNumber,
  }) = _ProprietaireModel;

  factory ProprietaireModel.fromJson(Map<String, dynamic> json) =>
      _$ProprietaireModelFromJson(json);
}
