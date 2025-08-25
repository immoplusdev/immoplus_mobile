import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/constants/constantes.dart';

part 'position_model.freezed.dart';
part 'position_model.g.dart';

@freezed
class PositionModel with _$PositionModel {
  const factory PositionModel({
    @Default('Point') String type,
    @Default([]) @JsonKey(fromJson: listToDouble) List<double>? coordinates,
  }) = _PositionModel;

  factory PositionModel.fromJson(Map<String, dynamic> json) =>
      _$PositionModelFromJson(json);
}
