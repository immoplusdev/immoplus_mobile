import 'package:freezed_annotation/freezed_annotation.dart';
part 'operator_model.freezed.dart';
part 'operator_model.g.dart';

@freezed
class OperatorModel with _$OperatorModel {
  const factory OperatorModel({
    @Default(0) int id,
    @Default('') String name,
    @Default('') String value,
    @Default('') String logo,
    @Default('') String prefix,
    @Default(0) int fee,
  }) = _OperatorModel;

  factory OperatorModel.fromJson(Map<String, dynamic> json) =>
      _$OperatorModelFromJson(json);
}
