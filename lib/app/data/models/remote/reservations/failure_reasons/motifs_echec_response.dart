import 'package:freezed_annotation/freezed_annotation.dart';
import 'motif_item.dart';

part 'motifs_echec_response.freezed.dart';
part 'motifs_echec_response.g.dart';

@freezed
class MotifsEchecData with _$MotifsEchecData {
  const factory MotifsEchecData({
    @Default('') String reservationId,
    @Default('') String status,
    @Default('') String actorInterroge,
    @Default(false) bool dejaRepondu,
    @Default([]) List<MotifItem> motifs,
  }) = _MotifsEchecData;

  factory MotifsEchecData.fromJson(Map<String, dynamic> json) =>
      _$MotifsEchecDataFromJson(json);
}

@freezed
class MotifsEchecResponse with _$MotifsEchecResponse {
  const factory MotifsEchecResponse({
    @Default(MotifsEchecData()) MotifsEchecData data,
  }) = _MotifsEchecResponse;

  factory MotifsEchecResponse.fromJson(Map<String, dynamic> json) =>
      _$MotifsEchecResponseFromJson(json);
}
