import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/polls/poll_model.dart';

part 'poll_detail_response.freezed.dart';
part 'poll_detail_response.g.dart';

/// Réponse de `GET /polls/{pollId}` — détail + résultats complets d'un
/// sondage, utilisée pour rafraîchir l'affichage après un vote.
@freezed
class PollDetailResponse with _$PollDetailResponse {
  const factory PollDetailResponse({
    required PollModel data,
  }) = _PollDetailResponse;

  factory PollDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PollDetailResponseFromJson(json);
}
