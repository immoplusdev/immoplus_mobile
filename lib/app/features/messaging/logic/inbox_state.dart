import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/remote/messaging/conversation_model.dart';
import '../../../data/models/remote/messaging/conversation_type_count.dart';

part 'inbox_state.freezed.dart';

@freezed
class InboxState with _$InboxState {
  const factory InboxState.loading() = InboxLoading;

  const factory InboxState.loaded({
    required List<ConversationModel> conversations,

    /// `null` = onglet "Toutes".
    ConversationType? activeType,
    @Default([]) List<ConversationTypeCount> counts,
    @Default(false) bool isRefreshing,

    /// Distinct de [isRefreshing] : bascule d'onglet en cours (spec §4.3 —
    /// seule la liste se recharge en skeleton, pas les onglets déjà
    /// affichés, qui restent visibles avec leurs compteurs).
    @Default(false) bool isSwitchingTab,
  }) = InboxLoaded;

  const factory InboxState.error(String message) = InboxError;
}
