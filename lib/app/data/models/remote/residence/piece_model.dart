import 'package:freezed_annotation/freezed_annotation.dart';

part 'piece_model.freezed.dart';
part 'piece_model.g.dart';

@freezed
class PieceModel with _$PieceModel {
  const factory PieceModel({
    @Default('') String nom,
    @Default(0) int nombre,
  }) = _PieceModel;

  factory PieceModel.fromJson(Map<String, dynamic> json) =>
      _$PieceModelFromJson(json);
}
