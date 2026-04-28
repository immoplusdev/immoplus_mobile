import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_match_model.freezed.dart';
part 'alert_match_model.g.dart';

@freezed
class AlertMatchModel with _$AlertMatchModel {
  const factory AlertMatchModel({
    @Default('') String id,
    @Default('') String nom,
    @Default(0) num prix,
    @Default('') String location,
    @Default('') String type,
    @Default(0) int pieces,
    @Default(0) num score,
    String? miniature,
    DateTime? notifiedAt,
  }) = _AlertMatchModel;

  factory AlertMatchModel.fromJson(Map<String, dynamic> json) =>
      _$AlertMatchModelFromJson(json);
}
