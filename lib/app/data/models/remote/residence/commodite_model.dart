import 'package:freezed_annotation/freezed_annotation.dart';

part 'commodite_model.freezed.dart';
part 'commodite_model.g.dart';

@freezed
class CommoditeModel with _$CommoditeModel {
  const factory CommoditeModel({
    @Default('') String text,
    @Default('') String icon,
  }) = _CommoditeModel;

  factory CommoditeModel.fromJson(Map<String, dynamic> json) =>
      _$CommoditeModelFromJson(json);
}
