import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_opt_model.freezed.dart';
part 'send_opt_model.g.dart';

@freezed
class SendOptModel with _$SendOptModel {
  const factory SendOptModel({
    required String phoneNumber,
  }) = _SendOptModel;

  factory SendOptModel.fromJson(Map<String, dynamic> json) =>
      _$SendOptModelFromJson(json);
}
