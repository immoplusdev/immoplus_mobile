import 'package:freezed_annotation/freezed_annotation.dart';

part 'poll_model.freezed.dart';
part 'poll_model.g.dart';

/// Un sondage (`poll_banner`). Deux sources renvoient cette même entité
/// avec des conventions de clés différentes :
/// - `GET /me/home` (poll embarqué dans une section) : camelCase
///   (`pollId`, `totalVotes`, `userHasVoted`, `voteCount`, `expiresAt`) —
///   voir HOME FEED AGREGATOR.MD § 4.
/// - `GET /polls/{pollId}` (détail dédié, utilisé pour rafraîchir après un
///   vote) : snake_case (`id`, `total_votes`, `has_voted`, `vote_count`,
///   `expires_at`).
/// `fromJson` normalise les deux avant de déléguer au parsing généré, pour
/// que le reste du code n'ait jamais à se soucier de la source.
@freezed
class PollModel with _$PollModel {
  const factory PollModel({
    required String pollId,
    required String question,
    String? description,
    @Default('ACTIVE') String status,
    @Default([]) List<PollOption> options,
    @Default(0) int totalVotes,
    @Default(false) bool userHasVoted,

    /// Id de l'option votée par l'utilisateur/device courant — présent dès
    /// que `userHasVoted` est vrai (`GET`, `PATCH`, `DELETE`), permet de
    /// surligner le bon choix sans avoir à retenir l'état en mémoire côté
    /// front (ex: sondage déjà voté lors d'une session précédente).
    String? votedOptionId,
    DateTime? expiresAt,
  }) = _PollModel;

  factory PollModel.fromJson(Map<String, dynamic> json) =>
      _$PollModelFromJson(_normalizeKeys(json));

  static Map<String, dynamic> _normalizeKeys(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['pollId'] ??= normalized['id'];
    normalized['totalVotes'] ??= normalized['total_votes'];
    normalized['userHasVoted'] ??= normalized['has_voted'];
    normalized['votedOptionId'] ??= normalized['voted_option_id'];
    normalized['expiresAt'] ??= normalized['expires_at'];
    return normalized;
  }
}

@freezed
class PollOption with _$PollOption {
  const factory PollOption({
    required String id,
    required String label,
    @Default(0) int voteCount,
    @Default(0) int percentage,
  }) = _PollOption;

  factory PollOption.fromJson(Map<String, dynamic> json) =>
      _$PollOptionFromJson(_normalizeKeys(json));

  static Map<String, dynamic> _normalizeKeys(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['voteCount'] ??= normalized['vote_count'];
    return normalized;
  }
}
