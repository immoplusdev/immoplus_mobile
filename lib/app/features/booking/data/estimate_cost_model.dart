// app/features/booking/data/estimate_cost_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'estimate_cost_model.freezed.dart';
part 'estimate_cost_model.g.dart';

@freezed
class EstimateCostModel with _$EstimateCostModel {
  const factory EstimateCostModel({
    EstimateCostData? data,
  }) = _EstimateCostModel;

  factory EstimateCostModel.fromJson(Map<String, dynamic> json) =>
      _$EstimateCostModelFromJson(json);
}

@freezed
class EstimateCostData with _$EstimateCostData {
  const factory EstimateCostData({
    @Default(0.0) double pourcentage,
    @Default(0.0) double montant,
    @Default(0.0) double frais,
    @Default(0.0) double total,
  }) = _EstimateCostData;

  factory EstimateCostData.fromJson(Map<String, dynamic> json) =>
      _$EstimateCostDataFromJson(json);
}
