import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_body_model.freezed.dart';
part 'login_body_model.g.dart';

@freezed
class LoginBodyModel with _$LoginBodyModel {
  factory LoginBodyModel({
    String? username,
    String? password,
    required String source,
  }) = _LoginBodyModel;

  factory LoginBodyModel.fromJson(Map<String, dynamic> json) =>
      _$LoginBodyModelFromJson(json);
}
