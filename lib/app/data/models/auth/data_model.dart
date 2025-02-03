import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'data_model.freezed.dart';
part 'data_model.g.dart';

@freezed
class DataModel with _$DataModel {
  const factory DataModel({
    required UserModel user,
    String? accessToken,
    String? expires,
    String? refreshToken,
  }) = _DataModel;

  factory DataModel.fromJson(Map<String, dynamic> json) =>
      _$DataModelFromJson(json);
}
