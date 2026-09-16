import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../constants/constantes.dart';
import '../../../core/network/utils/session_manager.dart';
import '../../../core/services/messaging_socket_service.dart';
import '../../../data/models/remote/messaging/conversation_model.dart';
import '../../../data/models/remote/messaging/conversation_type_count.dart';
import '../../../data/repositories/messaging_repository.dart';
import 'inbox_state.dart';

@injectable
class InboxCubit extends Cubit<InboxState> {
  final MessagingRepository _repository;
  final MessagingSocketService _socketService;
  final SessionManager _sessionManager;

  StreamSubscription? _messageNewSub;
  StreamSubscription? _notificationSub;

  /// Onglet actif mémorisé "pendant la session" (spec §4.1) : le Cubit est
  /// recréé à chaque visite de l'écran Inbox (route hors du Shell tant
  /// qu'on ne garde pas l'état des onglets), donc on le garde ici plutôt
  /// que sur l'instance pour survivre à cette recréation.
  static ConversationType? _rememberedType;

  InboxCubit(this._repository, this._socketService, this._sessionManager)
      : super(const InboxState.loading());

  Future<void> load() async {
    final wasLoaded = state is InboxLoaded;
    if (!wasLoaded) emit(const InboxState.loading());
    try {
      final results = await Future.wait([
        _repository.getConversations(type: _rememberedType),
        _repository.getConversationCounts(),
      ]);
      final conversations = results[0] as List<ConversationModel>;
      final counts = results[1] as List<ConversationTypeCount>;
      _emitLoaded(conversations, counts, _rememberedType);
      _startListening();
    } catch (e) {
      emit(InboxState.error(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> selectTab(ConversationType? type) async {
    _rememberedType = type;
    final current = state;
    if (current is! InboxLoaded) return;
    if (current.activeType == type) return;
    emit(current.copyWith(activeType: type, isSwitchingTab: true));
    try {
      final conversations = await _repository.getConversations(type: type);
      final stillCurrent = state;
      if (stillCurrent is InboxLoaded && stillCurrent.activeType == type) {
        emit(stillCurrent.copyWith(conversations: conversations, isSwitchingTab: false));
      }
    } catch (e) {
      final stillCurrent = state;
      if (stillCurrent is InboxLoaded) {
        emit(stillCurrent.copyWith(isSwitchingTab: false));
      }
    }
  }

  Future<void> refresh() async {
    final current = state;
    if (current is InboxLoaded) {
      emit(current.copyWith(isRefreshing: true));
    }
    try {
      final activeType = current is InboxLoaded ? current.activeType : _rememberedType;
      final results = await Future.wait([
        _repository.getConversations(type: activeType),
        _repository.getConversationCounts(),
      ]);
      final conversations = results[0] as List<ConversationModel>;
      final counts = results[1] as List<ConversationTypeCount>;
      _emitLoaded(conversations, counts, activeType);
    } catch (e) {
      // Sur un pull-to-refresh, on garde la liste déjà affichée plutôt que
      // de la remplacer par un état d'erreur plein écran.
      final stillCurrent = state;
      if (stillCurrent is InboxLoaded) {
        emit(stillCurrent.copyWith(isRefreshing: false));
      } else {
        emit(InboxState.error(e.toString().replaceAll('Exception: ', '')));
      }
    }
  }

  void _startListening() {
    _messageNewSub?.cancel();
    _messageNewSub = _socketService.onMessageNew.listen((_) {
      unawaited(refresh());
    });

    _notificationSub?.cancel();
    _notificationSub = _socketService.onNotificationNew.listen((_) {
      unawaited(refresh());
    });
  }

  void _emitLoaded(
    List<ConversationModel> conversations,
    List<ConversationTypeCount> counts,
    ConversationType? activeType,
  ) {
    final sorted = List<ConversationModel>.from(conversations)
      ..sort((a, b) {
        final aDate = a.lastMessageAt ?? a.createdAt ?? DateTime(1970);
        final bDate = b.lastMessageAt ?? b.createdAt ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });
    emit(InboxState.loaded(conversations: sorted, activeType: activeType, counts: counts));
    Constantes.unreadMessagesCount.value =
        counts.fold<int>(0, (t, c) => t + c.unread);
  }

  /// Rafraîchit uniquement le badge (utilisé au retour au premier plan de
  /// l'app, sans recharger tout l'écran Inbox).
  Future<void> refreshBadgeOnly() async {
    if (_sessionManager.currentUser == null) return;
    final total = await _repository.getTotalUnreadCount();
    Constantes.unreadMessagesCount.value = total;
  }

  @override
  Future<void> close() {
    _messageNewSub?.cancel();
    _notificationSub?.cancel();
    return super.close();
  }
}
