import 'package:freezed_annotation/freezed_annotation.dart';
part 'operator_provider_model.freezed.dart';
part 'operator_provider_model.g.dart';

@freezed
class OperatorProviderModel with _$OperatorProviderModel {
  const factory OperatorProviderModel({
    @Default('') String id,
    @Default('') String name,
    @Default('') String country,
    @Default('') String method,
    @Default('') String currency,
  }) = _OperatorProviderModel;

  factory OperatorProviderModel.fromJson(Map<String, dynamic> json) =>
      _$OperatorProviderModelFromJson(json);
}
