import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../core/config/injection.dart';
import '../../../core/network/utils/session_manager.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/messaging_socket_service.dart';
import '../../../data/models/remote/bienimmobilier/demande_visite_model.dart';
import '../../../data/models/remote/messaging/conversation_model.dart';
import '../../../data/models/remote/messaging/client_guidance_model.dart';
import '../../../data/models/remote/messaging/message_model.dart';
import '../../../data/models/remote/residence/residence_model.dart';
import '../../../data/models/remote/reverse_search/reverse_search_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/bien_immobilier_repository.dart';
import '../../../data/repositories/messaging_repository.dart';
import '../../../data/repositories/residence_repository.dart';
import '../../../data/repositories/reverse_search_repository.dart';
import '../../../features/authentification/authentification_page.dart';
import '../../../features/booking/booking_formular_action.dart';
import '../../../features/estate_detail/estate_page.dart';
import '../../../features/residence_detail/residence_page.dart';
import '../../../features/suggest/logic/reverse_search_navigation.dart';
import '../../../features/visits/visit_pending_page.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import '../../../utils/utils.dart';
import '../logic/conversation_thread_cubit.dart';
import '../logic/conversation_thread_state.dart';
import '../utils/messaging_time_format.dart';
import '../widgets/block_conversation_dialog.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer_bar.dart';
import '../widgets/message_composer_sheet.dart';
import '../widgets/report_conversation_sheet.dart';
import '../widgets/thread_typing_indicator.dart';

class MessageThreadPage extends StatelessWidget {
  const MessageThreadPage({super.key, required this.conversationId});

  final String conversationId;

  static const String routePath = '/messages/:conversationId';
  static const String name = 'message_thread';

  static String route(String conversationId) => '/messages/$conversationId';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ConversationThreadCubit>()..load(conversationId),
      child: const _ThreadView(),
    );
  }
}

class _ThreadView extends StatefulWidget {
  const _ThreadView();

  @override
  State<_ThreadView> createState() => _ThreadViewState();
}

class _ThreadViewState extends State<_ThreadView> with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  ResidenceModel? _residence;
  DemandeVisiteModel? _visitData;
  String? _peerName;
  bool _sideEffectsLoaded = false;
  int _lastMessageCount = 0;
  final _guidanceShows = <String, int>{};
  final _dismissedGuidance = <String>{};
  StreamSubscription<void>? _guidanceUpdatedSubscription;
  Timer? _guidanceDebounce;
  List<ClientGuidanceRule> _guidanceRules = const [];
  ClientGuidanceRule? _activeGuidance;
  String _draft = '';
  String _lastActionSignature = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _guidanceUpdatedSubscription = getIt<MessagingSocketService>()
        .onClientGuidanceUpdated
        .listen((_) => _refreshGuidance());
    unawaited(_loadGuidance());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _guidanceDebounce?.cancel();
    _guidanceUpdatedSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      unawaited(context.read<ConversationThreadCubit>().refreshConversation());
      unawaited(_refreshGuidance());
    }
  }

  Future<void> _loadGuidance() async {
    final repository = getIt<MessagingRepository>();
    final cached = await repository.loadCachedClientGuidance();
    if (mounted && cached != null) {
      setState(() => _guidanceRules = cached.rules);
      _reevaluateGuidance();
    }
    await _refreshGuidance();
  }

  Future<void> _refreshGuidance() async {
    try {
      final guidance = await getIt<MessagingRepository>().getClientGuidance();
      if (!mounted) return;
      setState(() => _guidanceRules = guidance.rules);
      _reevaluateGuidance();
    } catch (_) {
      // Le dernier dictionnaire valide en cache reste actif.
    }
  }

  ConversationThreadLoaded? get _loadedState {
    final current = context.read<ConversationThreadCubit>().state;
    return current is ConversationThreadLoaded ? current : null;
  }

  List<MessagingAction> _currentActions(ConversationThreadLoaded state) {
    if (state.conversation.isReadOnly) return const [];
    final byId = <String, MessagingAction>{};
    for (final action in state.conversation.actions) {
      if (isMessagingActionVisible(action)) byId[action.id] = action;
    }
    for (final message in state.messages.reversed) {
      for (final action in message.actions) {
        if (isMessagingActionVisible(action)) {
          byId.putIfAbsent(action.id, () => action);
        }
      }
    }
    return byId.values.toList(growable: false);
  }

  void _onDraftChanged(String value, ConversationThreadLoaded state) {
    context.read<ConversationThreadCubit>().onComposerTextChanged();
    _draft = value;
    _guidanceDebounce?.cancel();
    _guidanceDebounce = Timer(const Duration(milliseconds: 180), () {
      _evaluateGuidance(state);
    });
  }

  void _reevaluateGuidance() {
    final state = _loadedState;
    if (state != null) _evaluateGuidance(state);
  }

  void _evaluateGuidance(ConversationThreadLoaded state) {
    if (!mounted || _draft.trim().isEmpty || state.conversation.isReadOnly) {
      if (_activeGuidance != null && mounted) {
        setState(() => _activeGuidance = null);
      }
      return;
    }

    final normalizedDraft = _normalizeDraft(_draft);
    final actionIds = _currentActions(state).map((action) => action.id).toSet();
    ClientGuidanceRule? match;
    for (final rule in _guidanceRules) {
      if (_dismissedGuidance.contains(rule.id)) continue;
      if ((_guidanceShows[rule.id] ?? 0) >= rule.maxShowsPerConversation) {
        continue;
      }
      if (rule.conversationTypes.isNotEmpty &&
          !rule.conversationTypes.contains(state.conversation.type)) {
        continue;
      }
      if (rule.intent != 'open_support' &&
          rule.requiresAnyAction.isNotEmpty &&
          !rule.requiresAnyAction.any(actionIds.contains)) {
        continue;
      }
      final matchesPhrase = rule.phrases.any((phrase) {
        final normalizedPhrase = _normalizeDraft(phrase);
        return normalizedPhrase.isNotEmpty &&
            ' $normalizedDraft '.contains(' $normalizedPhrase ');
      });
      if (matchesPhrase) {
        match = rule;
        break;
      }
    }

    if (match?.id == _activeGuidance?.id) return;
    setState(() => _activeGuidance = match);
    if (match != null) {
      _guidanceShows[match.id] = (_guidanceShows[match.id] ?? 0) + 1;
      unawaited(_logGuidance('chat_intent_suggested', match, state));
    }
  }

  String _normalizeDraft(String value) {
    var normalized = value.toLowerCase().replaceAll(
          RegExp(r'https?://\S+|www\.\S+', caseSensitive: false),
          ' ',
        );
    const accents = {
      'à': 'a',
      'â': 'a',
      'ä': 'a',
      'á': 'a',
      'ã': 'a',
      'ç': 'c',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'î': 'i',
      'ï': 'i',
      'í': 'i',
      'ô': 'o',
      'ö': 'o',
      'ó': 'o',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ú': 'u',
      'ÿ': 'y',
    };
    accents.forEach((source, replacement) {
      normalized = normalized.replaceAll(source, replacement);
    });
    return normalized
        .replaceAll(RegExp(r'\b\d+\b'), ' ')
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  Future<void> _logGuidance(
    String eventName,
    ClientGuidanceRule rule,
    ConversationThreadLoaded state,
  ) {
    final reservation = state.conversation.context['currentReservation'];
    final reservationStatus =
        reservation is Map ? reservation['status']?.toString() : null;
    return getIt<AnalyticsService>().logChatGuidanceEvent(
      eventName: eventName,
      ruleId: rule.id,
      intent: rule.intent,
      conversationType: state.conversation.type,
      reservationStatus: reservationStatus,
    );
  }

  void _dismissGuidance(ConversationThreadLoaded state) {
    final rule = _activeGuidance;
    if (rule == null) return;
    _dismissedGuidance.add(rule.id);
    setState(() => _activeGuidance = null);
    unawaited(_logGuidance('chat_intent_dismissed', rule, state));
  }

  Future<void> _acceptGuidance(ConversationThreadLoaded state) async {
    final rule = _activeGuidance;
    if (rule == null) return;
    unawaited(_logGuidance('chat_intent_accepted', rule, state));
    if (rule.intent == 'open_support') {
      await MessageComposerSheet.showForSupport(context);
      return;
    }
    final action = _currentActions(state).cast<MessagingAction?>().firstWhere(
          (candidate) => candidate?.id == rule.intent,
          orElse: () => null,
        );
    if (action == null || !mounted) return;
    if (action.id == 'pick_dates') {
      await _showAvailabilityRequest(state, action);
    } else {
      await handleMessagingAction(context, action);
    }
    if (!mounted) return;
    unawaited(_logGuidance('chat_intent_completed', rule, state));
    setState(() => _activeGuidance = null);
  }

  void _afterMessageSent() {
    _draft = '';
    _dismissedGuidance.clear();
    if (_activeGuidance != null) setState(() => _activeGuidance = null);
  }

  Future<void> _showAvailabilityRequest(
    ConversationThreadLoaded state,
    MessagingAction action,
  ) async {
    final targetId = action.target['id']?.toString();
    final residenceId = action.target['residenceId']?.toString() ??
        (action.target['collection'] == 'residences' ? targetId : null) ??
        state.conversation.residenceId;
    if (residenceId == null || residenceId.isEmpty || !mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => _AvailabilityRequestSheet(
        onSubmit: (dates, guests) =>
            context.read<ConversationThreadCubit>().sendAvailabilityRequest(
                  residenceId: residenceId,
                  checkIn: dates.start,
                  checkOut: dates.end,
                  guests: guests,
                ),
      ),
    );
  }

  Future<void> _dispatchAction(
    ConversationThreadLoaded state,
    MessagingAction action,
  ) async {
    final targetId = action.target['id']?.toString();
    if (action.id == 'share_residence_card') {
      final residenceId = action.target['residenceId']?.toString() ??
          (action.target['collection'] == 'residences' ? targetId : null);
      if (residenceId != null && residenceId.isNotEmpty) {
        await context
            .read<ConversationThreadCubit>()
            .sendResidenceCard(residenceId: residenceId);
      }
    } else if (action.id == 'share_reservation_card') {
      final reservationId = action.target['reservationId']?.toString() ??
          (action.target['collection'] == 'reservations' ? targetId : null);
      if (state.conversation.typeEnum == ConversationType.support &&
          reservationId != null &&
          reservationId.isNotEmpty) {
        await context
            .read<ConversationThreadCubit>()
            .sendReservationCard(reservationId: reservationId);
      }
    } else if (action.id == 'open_support') {
      await MessageComposerSheet.showForSupport(context);
    } else if (action.id == 'pick_dates') {
      await _showAvailabilityRequest(state, action);
    } else {
      await handleMessagingAction(context, action);
    }
  }

  /// Libellé par défaut de l'interlocuteur selon le type, tant que le
  /// vrai nom n'est pas résolu (ou pour `support`, qui n'en a pas).
  String _defaultPeerLabel(ConversationType type) {
    switch (type) {
      case ConversationType.support:
        return 'Support ImmoPlus';
      case ConversationType.visite:
      case ConversationType.reservation:
      case ConversationType.relais:
        return 'Propriétaire';
    }
  }

  Future<void> _loadSideEffects(ConversationModel conversation) async {
    if (_sideEffectsLoaded) return;
    _sideEffectsLoaded = true;

    switch (conversation.typeEnum) {
      case ConversationType.reservation:
        final residenceId = conversation.residenceId;
        final proId = conversation.proId;
        if (residenceId != null) {
          try {
            final residence =
                await getIt<ResidenceRepository>().getResidence(residenceId);
            if (mounted) setState(() => _residence = residence.data);
          } catch (_) {}
        }
        if (proId != null) {
          try {
            final user =
                await getIt<AuthRepository>().getUserById(userId: proId);
            final firstName = user.data.firstName;
            if (mounted && firstName != null && firstName.isNotEmpty) {
              setState(() => _peerName = firstName);
            }
          } catch (_) {}
        }
        break;

      case ConversationType.visite:
        final visiteId = conversation.visiteId;
        if (visiteId != null) {
          try {
            final response =
                await getIt<BienImmobilierRepository>().getVisit(id: visiteId);
            if (!mounted) return;
            setState(() {
              _visitData = response.data;
              final firstName = response.data.proprietaire?.firstName;
              if (firstName != null && firstName.isNotEmpty)
                _peerName = firstName;
            });
          } catch (_) {}
        }
        break;

      case ConversationType.support:
        // Pas d'identité individuelle — libellé fixe (spec §5.1).
        break;

      case ConversationType.relais:
        // Pas de carte de contexte dédiée pour l'instant — le libellé
        // générique "Propriétaire" (`_defaultPeerLabel`) suffit.
        break;
    }
  }

  void _scrollToBottomIfNeeded(int messageCount) {
    if (messageCount == _lastMessageCount) return;
    if (context.read<ConversationThreadCubit>().isLoadingOlder) {
      _lastMessageCount = messageCount;
      return;
    }
    // Premier lot chargé (0 → N) : atterrissage instantané, pas d'animation
    // qui ferait défiler tout l'historique sous les yeux de l'utilisateur.
    // Nouveau message pendant que le fil est déjà ouvert : petit défilement
    // animé, plus fluide qu'un saut brut.
    final isInitialLoad = _lastMessageCount == 0;
    _lastMessageCount = messageCount;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final target = _scrollController.position.maxScrollExtent;
      if (isInitialLoad) {
        _scrollController.jumpTo(target);
      } else {
        _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _presenceLabel(ConversationThreadLoaded state) {
    final peer = state.peerPresence;
    if (peer == null) return '';
    if (state.conversation.typeEnum == ConversationType.support) {
      return peer.online ? 'Équipe disponible' : '';
    }
    if (peer.online) return 'En ligne';
    if (peer.lastSeenAt != null) return formatLastSeen(peer.lastSeenAt!);
    return '';
  }

  void _openMenu(BuildContext context, ConversationThreadLoaded state) {
    final conversation = state.conversation;
    final isBlocked = conversation.isReadOnly;
    final type = conversation.typeEnum;
    final peerLabel = _peerName ?? _defaultPeerLabel(type);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.whiteBackground,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (type == ConversationType.reservation &&
                conversation.residenceId != null)
              ListTile(
                leading: const Icon(Iconsax.home_1),
                title: Text('Voir la résidence'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.pushNamed(
                    ResidencePage.name,
                    pathParameters: {'idProduct': conversation.residenceId!},
                  );
                },
              ),
            if (type == ConversationType.visite &&
                _visitData?.bienImmobilier != null) ...[
              ListTile(
                leading: const Icon(Iconsax.home_1),
                title: Text('Voir le bien'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.pushNamed(
                    EstatePage.name,
                    pathParameters: {
                      'idProduct': _visitData!.bienImmobilier!.id
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.calendar_1),
                title: Text('Voir la demande de visite'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.pushNamed(
                    VisitPendingPage.name,
                    extra: VisitPendingPage(
                      bienImmo: _visitData!.bienImmobilier!,
                      visitType: _visitData!.typeDemandeVisite ?? '',
                      visitId: _visitData!.id,
                      fromHistory: true,
                    ),
                  );
                },
              ),
            ],
            ListTile(
              leading: const Icon(Iconsax.warning_2),
              title: Text('Signaler'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                ReportConversationSheet.show(
                  context,
                  onSubmit: ({required reason, details}) => context
                      .read<ConversationThreadCubit>()
                      .report(reason: reason, details: details),
                );
              },
            ),
            // "Bloquer" n'a pas de sens pour le support : boîte partagée,
            // pas d'interlocuteur unique à bloquer (spec §5.1).
            if (!isBlocked && type != ConversationType.support)
              ListTile(
                leading: Icon(Iconsax.shield_cross,
                    color: AppColors.immoFeedbackError),
                title: Text('Bloquer',
                    style:
                        AppTypography.font(color: AppColors.immoFeedbackError)),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  final cubit = context.read<ConversationThreadCubit>();
                  showBlockConversationDialog(
                    context,
                    hostLabel: peerLabel,
                    onConfirm: () async {
                      final ok = await cubit.block();
                      if (!ok && context.mounted) {
                        ToastUtils.showError(
                            description: 'Le blocage a échoué. Réessayer.');
                      }
                      return ok;
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openChatActions(
    BuildContext context,
    ConversationThreadLoaded state,
  ) {
    final actions = _currentActions(state);
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (sheetContext) => _ChatActionsSheet(
        actions: actions,
        showSupport: state.conversation.typeEnum != ConversationType.support,
        canBlock: !state.conversation.isReadOnly &&
            state.conversation.typeEnum != ConversationType.support,
        onAction: (action) async {
          Navigator.of(sheetContext).pop();
          await _dispatchAction(state, action);
        },
        onSupport: () {
          Navigator.of(sheetContext).pop();
          MessageComposerSheet.showForSupport(context);
        },
        onReport: () {
          Navigator.of(sheetContext).pop();
          ReportConversationSheet.show(
            context,
            onSubmit: ({required reason, details}) => context
                .read<ConversationThreadCubit>()
                .report(reason: reason, details: details),
          );
        },
        onBlock: () {
          Navigator.of(sheetContext).pop();
          final cubit = context.read<ConversationThreadCubit>();
          showBlockConversationDialog(
            context,
            hostLabel:
                _peerName ?? _defaultPeerLabel(state.conversation.typeEnum),
            onConfirm: () async {
              final success = await cubit.block();
              if (!success && context.mounted) {
                ToastUtils.showError(
                  description: 'Le blocage a échoué. Réessayer.',
                );
              }
              return success;
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<ConversationThreadCubit, ConversationThreadState>(
          listener: (context, state) {
            if (state is ConversationThreadLoaded) {
              _loadSideEffects(state.conversation);
              _scrollToBottomIfNeeded(state.messages.length);
              final actionSignature = _currentActions(state)
                  .map((action) => action.id)
                  .toList()
                ..sort();
              final serializedSignature = actionSignature.join('|');
              if (_lastActionSignature.isNotEmpty &&
                  serializedSignature != _lastActionSignature) {
                _dismissedGuidance.clear();
              }
              _lastActionSignature = serializedSignature;
              if (_draft.trim().isNotEmpty) {
                _evaluateGuidance(state);
              }
            }
          },
          builder: (context, state) {
            if (state is ConversationThreadLoading) {
              // Toujours un moyen de sortir même si le chargement traîne
              // (réseau lent) — jamais un écran figé sans retour possible.
              return Column(
                children: [
                  _MinimalHeader(
                      onBack: () => Navigator.of(context).maybePop()),
                  const Expanded(child: _ThreadLoadingSkeleton()),
                ],
              );
            }
            if (state is ConversationThreadError) {
              return Column(
                children: [
                  _MinimalHeader(
                      onBack: () => Navigator.of(context).maybePop()),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Iconsax.warning_2,
                                size: 40, color: AppColors.immoTextDisabled),
                            SizedBox(height: 12),
                            Text(state.message, textAlign: TextAlign.center),
                            SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: () => context
                                  .read<ConversationThreadCubit>()
                                  .retry(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: BorderSide(color: AppColors.primary),
                              ),
                              child: Text('Réessayer'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            final loaded = state as ConversationThreadLoaded;
            final isBlocked = loaded.conversation.isReadOnly;
            final type = loaded.conversation.typeEnum;
            final peerLabel = _peerName ?? _defaultPeerLabel(type);

            // Carte de contexte façon Airbnb : premier élément du fil, pas
            // un bandeau figé — elle défile avec la conversation.
            Widget? topCard;
            if (type == ConversationType.reservation) {
              topCard = _ReservationContextSummary(
                conversation: loaded.conversation,
                residence: _residence,
                onAction: (action) => _dispatchAction(loaded, action),
              );
            } else if (type == ConversationType.visite &&
                _visitData?.bienImmobilier != null) {
              topCard = _VisiteContextCard(visitData: _visitData!);
            } else if (type == ConversationType.support) {
              topCard = const _SupportContextBanner();
            }

            return Column(
              children: [
                _Header(
                  peerLabel: peerLabel,
                  isSupport: type == ConversationType.support,
                  presenceLabel: _presenceLabel(loaded),
                  onMenuTap: () => _openMenu(context, loaded),
                ),
                Expanded(
                  child: _MessageList(
                    scrollController: _scrollController,
                    state: loaded,
                    peerName: peerLabel,
                    isSupport: type == ConversationType.support,
                    topCard: topCard,
                    onAction: (action) => _dispatchAction(loaded, action),
                  ),
                ),
                if (loaded.moderationBannerMessage != null)
                  _ModerationBanner(
                    message: loaded.moderationBannerMessage!,
                  ),
                if (isBlocked)
                  const _ReadOnlyComposer()
                else
                  MessageComposerBar(
                    onChanged: (value) => _onDraftChanged(value, loaded),
                    onSend: (text) async {
                      context
                          .read<ConversationThreadCubit>()
                          .dismissModerationBanner();
                      final sent = await context
                          .read<ConversationThreadCubit>()
                          .sendText(text);
                      if (sent) _afterMessageSent();
                      return sent;
                    },
                    onOpenActions: () => _openChatActions(context, loaded),
                    topAccessory: _activeGuidance == null
                        ? null
                        : _GuidanceSuggestionCard(
                            rule: _activeGuidance!,
                            onAccept: () => _acceptGuidance(loaded),
                            onDismiss: () => _dismissGuidance(loaded),
                          ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ReadOnlyComposer extends StatelessWidget {
  const _ReadOnlyComposer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.immoBgSurfaceMuted,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Iconsax.lock, size: 19, color: AppColors.immoTextSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Cette conversation est en lecture seule.',
              style: AppTypography.font(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.immoTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidanceSuggestionCard extends StatelessWidget {
  const _GuidanceSuggestionCard({
    required this.rule,
    required this.onAccept,
    required this.onDismiss,
  });

  final ClientGuidanceRule rule;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 8 * (1 - value)),
          child: child,
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        decoration: BoxDecoration(
          color: AppColors.primaryLite,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(11),
              ),
              child:
                  Icon(Iconsax.lamp_charge, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rule.title,
                    style: AppTypography.font(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    rule.body,
                    style: AppTypography.font(
                      fontSize: 12,
                      color: AppColors.immoTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 7),
                  GestureDetector(
                    onTap: onAccept,
                    child: Text(
                      rule.ctaLabel,
                      style: AppTypography.font(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Masquer la suggestion',
              onPressed: onDismiss,
              icon: Icon(Iconsax.close_circle,
                  size: 19, color: AppColors.immoTextSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatActionsSheet extends StatefulWidget {
  const _ChatActionsSheet({
    required this.actions,
    required this.showSupport,
    required this.canBlock,
    required this.onAction,
    required this.onSupport,
    required this.onReport,
    required this.onBlock,
  });

  final List<MessagingAction> actions;
  final bool showSupport;
  final bool canBlock;
  final ValueChanged<MessagingAction> onAction;
  final VoidCallback onSupport;
  final VoidCallback onReport;
  final VoidCallback onBlock;

  @override
  State<_ChatActionsSheet> createState() => _ChatActionsSheetState();
}

class _ChatActionsSheetState extends State<_ChatActionsSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      ...widget.actions.map(
        (action) => _ChatActionTile(
          icon: messagingActionIcon(action.id),
          title: action.label,
          isDanger: action.variant == 'danger',
          onTap: () => widget.onAction(action),
        ),
      ),
      if (widget.showSupport)
        _ChatActionTile(
          icon: Iconsax.message_question,
          title: 'Contacter le support',
          subtitle: 'Obtenir de l’aide de l’équipe ImmoPlus',
          onTap: widget.onSupport,
        ),
      _ChatActionTile(
        icon: Iconsax.warning_2,
        title: 'Signaler la conversation',
        onTap: widget.onReport,
      ),
      if (widget.canBlock)
        _ChatActionTile(
          icon: Iconsax.shield_cross,
          title: 'Bloquer la conversation',
          isDanger: true,
          onTap: widget.onBlock,
        ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.immoBorderStrong,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Actions du chat',
            style: AppTypography.font(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.actions.isEmpty
                ? 'Gérez cette conversation.'
                : 'Les actions disponibles sont actualisées par ImmoPlus.',
            style: AppTypography.font(
              fontSize: 13,
              color: AppColors.immoTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .58,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(tiles.length, (index) {
                  final start = (index * .07).clamp(0.0, .55).toDouble();
                  final animation = CurvedAnimation(
                    parent: _controller,
                    curve: Interval(start, 1, curve: Curves.easeOutCubic),
                  );
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, .12),
                        end: Offset.zero,
                      ).animate(animation),
                      child: tiles[index],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatActionTile extends StatelessWidget {
  const _ChatActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.isDanger = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isDanger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? AppColors.immoFeedbackError : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isDanger
            ? AppColors.immoFeedbackError.withValues(alpha: .06)
            : AppColors.immoBgSurfaceMuted,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.font(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDanger
                              ? AppColors.immoFeedbackError
                              : AppColors.black,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: AppTypography.font(
                            fontSize: 11,
                            color: AppColors.immoTextSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Iconsax.arrow_right_3,
                    size: 17, color: AppColors.immoTextDisabled),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvailabilityRequestSheet extends StatefulWidget {
  const _AvailabilityRequestSheet({required this.onSubmit});

  final Future<bool> Function(DateTimeRange dates, int guests) onSubmit;

  @override
  State<_AvailabilityRequestSheet> createState() =>
      _AvailabilityRequestSheetState();
}

class _AvailabilityRequestSheetState extends State<_AvailabilityRequestSheet> {
  DateTimeRange? _dates;
  int _guests = 1;
  bool _sending = false;
  String? _error;

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final dates = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _dates,
      helpText: 'Choisir les dates du séjour',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );
    if (dates != null && mounted) setState(() => _dates = dates);
  }

  Future<void> _submit() async {
    final dates = _dates;
    if (dates == null || _sending) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    final sent = await widget.onSubmit(dates, _guests);
    if (!mounted) return;
    if (sent) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _sending = false;
        _error = 'La demande n’a pas pu être envoyée. Vérifiez les dates.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _dates == null
        ? 'Choisir les dates'
        : '${DateFormat('d MMM', 'fr_FR').format(_dates!.start)} – '
            '${DateFormat('d MMM yyyy', 'fr_FR').format(_dates!.end)}';
    return Padding(
      padding: EdgeInsets.fromLTRB(
        22,
        16,
        22,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.immoBorderStrong,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Vérifier une disponibilité',
            style: AppTypography.font(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choisissez vos dates et le nombre de voyageurs. Aucun prix n’est saisi dans le chat.',
            style: AppTypography.font(
              fontSize: 13,
              color: AppColors.immoTextSecondary,
            ),
          ),
          const SizedBox(height: 18),
          _SheetSelector(
            icon: Iconsax.calendar_1,
            label: dateLabel,
            onTap: _pickDates,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.immoBgSurfaceMuted,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Iconsax.people, size: 20, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$_guests voyageur${_guests > 1 ? 's' : ''}',
                    style: AppTypography.font(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed:
                      _guests > 1 ? () => setState(() => _guests--) : null,
                  icon: const Icon(Iconsax.minus_cirlce),
                ),
                IconButton(
                  onPressed: () => setState(() => _guests++),
                  icon: const Icon(Iconsax.add_circle),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _error == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _error!,
                      style: AppTypography.font(
                        fontSize: 12,
                        color: AppColors.immoFeedbackError,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: _dates != null && !_sending ? _submit : null,
              icon: _sending
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Iconsax.send_2, size: 18),
              label: Text(_sending ? 'Envoi…' : 'Envoyer la demande'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetSelector extends StatelessWidget {
  const _SheetSelector({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.immoBgSurfaceMuted,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.font(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Iconsax.arrow_right_3,
                  size: 17, color: AppColors.immoTextDisabled),
            ],
          ),
        ),
      ),
    );
  }
}

/// En-tête réduit (juste le retour) pour les états chargement/erreur —
/// évite un écran sans aucun moyen de sortir si le réseau traîne.
class _MinimalHeader extends StatelessWidget {
  const _MinimalHeader({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppColors.immoBgSurfaceMuted, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Iconsax.arrow_left), onPressed: onBack),
        ],
      ),
    );
  }
}

class _ThreadLoadingSkeleton extends StatelessWidget {
  const _ThreadLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .45, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      builder: (context, opacity, child) => Opacity(
        opacity: opacity,
        child: child,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 74,
              decoration: BoxDecoration(
                color: AppColors.immoBgSurfaceMuted,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 24),
            const _SkeletonBubble(widthFactor: .68),
            const SizedBox(height: 12),
            const _SkeletonBubble(widthFactor: .54, alignRight: true),
            const SizedBox(height: 12),
            const _SkeletonBubble(widthFactor: .76),
            const Spacer(),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.immoBgSurfaceMuted,
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBubble extends StatelessWidget {
  const _SkeletonBubble({required this.widthFactor, this.alignRight = false});

  final double widthFactor;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.immoBgSurfaceMuted,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.peerLabel,
    required this.isSupport,
    required this.presenceLabel,
    required this.onMenuTap,
  });

  final String peerLabel;
  final bool isSupport;
  final String presenceLabel;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final isOnline =
        presenceLabel == 'En ligne' || presenceLabel == 'Équipe disponible';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppColors.immoBgSurfaceMuted, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Iconsax.arrow_left),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryLite,
            child: Icon(
              isSupport ? Iconsax.message_question : Iconsax.user,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(peerLabel,
                    style: AppTypography.font(
                        fontSize: 15, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                if (presenceLabel.isNotEmpty)
                  Semantics(
                    label: presenceLabel,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isOnline) ...[
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: AppColors.immoFeedbackSuccess,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4),
                        ],
                        Text(
                          presenceLabel,
                          style: AppTypography.font(
                              fontSize: 12, color: AppColors.immoTextSecondary),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Iconsax.more),
            onPressed: onMenuTap,
          ),
        ],
      ),
    );
  }
}

/// Résumé du fil de réservation alimenté uniquement par le contexte et
/// les actions calculés par le serveur. Aucun délai ni CTA n'est inventé ici.
class _ReservationContextSummary extends StatelessWidget {
  const _ReservationContextSummary({
    required this.conversation,
    required this.residence,
    required this.onAction,
  });

  final ConversationModel conversation;
  final ResidenceModel? residence;
  final ValueChanged<MessagingAction> onAction;

  Map<String, dynamic> _map(dynamic value) => value is Map
      ? Map<String, dynamic>.from(value)
      : const <String, dynamic>{};

  String _statusLabel(String value) => value
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');

  @override
  Widget build(BuildContext context) {
    final residenceContext = _map(conversation.context['residence']);
    final reservation = _map(conversation.context['currentReservation']);
    final amount = _map(reservation['amountForViewer']);
    final deadline = _map(reservation['deadline']);
    final title = residenceContext['title']?.toString().trim();
    final city = residenceContext['city']?.toString().trim();
    final cover = residenceContext['coverUrl']?.toString().trim();
    final localCover = residence?.images.isNotEmpty == true
        ? Utils.getImagePath(id: residence!.images.first)
        : null;
    final coverUrl = cover != null && cover.isNotEmpty
        ? (cover.startsWith('http') ? cover : Utils.getImagePath(id: cover))
        : localCover;
    final displayTitle =
        title?.isNotEmpty == true ? title! : residence?.nom ?? 'Réservation';
    final checkIn = reservation['checkIn']?.toString();
    final checkOut = reservation['checkOut']?.toString();
    final status = reservation['status']?.toString();
    final dueAt = conversation.pendingActionDueAt ??
        (deadline['at'] == null
            ? null
            : DateTime.tryParse(deadline['at'].toString()));
    final actions = conversation.isReadOnly
        ? const <MessagingAction>[]
        : conversation.actions.where(isMessagingActionVisible).toList();
    MessagingAction? primaryAction;
    for (final action in actions) {
      if (primaryAction == null || action.variant == 'primary') {
        primaryAction = action;
      }
      if (action.variant == 'primary') break;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.immoBorderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: coverUrl == null
                      ? Container(
                          color: AppColors.immoBgSurfaceMuted,
                          child: Icon(Iconsax.home_1, color: AppColors.primary),
                        )
                      : CachedNetworkImage(
                          imageUrl: coverUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.immoBgSurfaceMuted,
                            child:
                                Icon(Iconsax.home_1, color: AppColors.primary),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.font(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (city?.isNotEmpty == true) ...[
                      const SizedBox(height: 3),
                      Text(
                        city!,
                        style: AppTypography.font(
                          fontSize: 11,
                          color: AppColors.immoTextSecondary,
                        ),
                      ),
                    ],
                    if (status?.isNotEmpty == true) ...[
                      const SizedBox(height: 5),
                      Text(
                        _statusLabel(status!),
                        style: AppTypography.font(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (checkIn != null || checkOut != null) ...[
            const SizedBox(height: 12),
            _ReservationSummaryLine(
              icon: Iconsax.calendar_1,
              text: [checkIn, checkOut].whereType<String>().join(' → '),
            ),
          ],
          if (amount['value'] != null) ...[
            const SizedBox(height: 8),
            _ReservationSummaryLine(
              icon: Iconsax.wallet_3,
              text: '${amount['value']} ${amount['currency'] ?? 'XOF'}',
            ),
          ],
          if (conversation.pendingActionFor != null || dueAt != null) ...[
            const SizedBox(height: 8),
            _ReservationSummaryLine(
              icon: Iconsax.clock,
              text: [
                if (conversation.pendingActionFor == 'client')
                  'Action attendue de votre part'
                else if (conversation.pendingActionFor == 'pro')
                  'Réponse de l’hôte attendue',
                if (dueAt != null)
                  'avant ${DateFormat('HH:mm', 'fr_FR').format(dueAt.toLocal())}',
              ].join(' '),
            ),
          ],
          if (primaryAction != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: MessagingActionButton(
                action: primaryAction,
                onPressed: () => onAction(primaryAction!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReservationSummaryLine extends StatelessWidget {
  const _ReservationSummaryLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTypography.font(
              fontSize: 12,
              color: AppColors.immoTextSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Carte de contexte résidence + CTA "Voir la résidence" et
/// "Réserver"/"Payer" (spec §5.2) — réutilise la même vérification de
/// verrouillage reverse-search que `LogmentBottomBar` (même repository,
/// même helper de navigation), pas de logique de paiement dupliquée.
class _ResidenceContextCard extends StatefulWidget {
  const _ResidenceContextCard({required this.residence});
  final ResidenceModel residence;

  @override
  State<_ResidenceContextCard> createState() => _ResidenceContextCardState();
}

class _ResidenceContextCardState extends State<_ResidenceContextCard> {
  ReverseSearchItem? _activeSearch;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final active = await getIt<ReverseSearchRepository>().getActiveSearch();
      if (mounted) setState(() => _activeSearch = active);
    } catch (_) {}
  }

  bool get _isThisLocked =>
      _activeSearch?.statusEnum.isSelectionEnAttentePaiement == true &&
      _activeSearch?.residenceSelectionnee == widget.residence.id;

  bool get _isLockedElsewhere =>
      _activeSearch?.statusEnum.isSelectionEnAttentePaiement == true &&
      _activeSearch?.residenceSelectionnee != widget.residence.id;

  void _onBookingTap(BuildContext context) {
    final sessionManager = getIt<SessionManager>();
    if (sessionManager.currentUser == null) {
      // Peu probable ici (un fil implique déjà une session) — filet de
      // sécurité seulement.
      context.pushNamed(AuthenticationPage.name);
      return;
    }
    if (_isThisLocked) {
      ReverseSearchNavigation.resumeToPayment(context, _activeSearch!);
      return;
    }
    if (_isLockedElsewhere) {
      AppDialog.show(
        title: 'Sélection en attente de paiement',
        description: 'Vous avez déjà une résidence sélectionnée en attente de '
            'paiement. Terminez ou annulez cette sélection avant d\'en réserver '
            'une autre.',
        primaryButtonText: 'Continuer le paiement',
        onPrimary: () =>
            ReverseSearchNavigation.resumeToPayment(context, _activeSearch!),
      );
      return;
    }
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => BookingFormularAction(residenceModel: widget.residence),
      ),
    );
  }

  /// "20–22 nov. 2026" (même mois) ou "20 nov. – 22 déc. 2026" (mois différents).
  String _formatStayRange(DateTime start, DateTime end) {
    if (start.year == end.year && start.month == end.month) {
      return '${start.day}–${end.day} ${DateFormat('MMM yyyy', 'fr_FR').format(end)}';
    }
    final startFmt = DateFormat('d MMM', 'fr_FR').format(start);
    final endFmt = DateFormat('d MMM yyyy', 'fr_FR').format(end);
    return '$startFmt – $endFmt';
  }

  @override
  Widget build(BuildContext context) {
    final residence = widget.residence;
    final coverImageId =
        residence.images.isNotEmpty ? residence.images.first : null;
    final bookingLabel = _isThisLocked ? 'Terminer la réservation' : 'Réserver';

    // Dates/voyageurs uniquement quand une sélection reverse-search réelle
    // existe pour cette résidence — jamais de valeur inventée.
    final activeSearch = _activeSearch;
    final stayInfo = (_isThisLocked &&
            activeSearch?.dateDebut != null &&
            activeSearch?.dateFin != null)
        ? '${_formatStayRange(activeSearch!.dateDebut!, activeSearch.dateFin!)} · '
            '${activeSearch.nombrePersonnes} voyageur${activeSearch.nombrePersonnes > 1 ? 's' : ''}'
        : null;

    // Pas pleine largeur — une card système reste compacte, comme une bulle
    // de conversation, alignée à droite comme les messages envoyés par le client.
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 2 / 3),
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.immoBorderDefault),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Demande d'information envoyée",
              style: AppTypography.font(
                  fontSize: 11, color: AppColors.immoTextSecondary),
            ),
            SizedBox(height: 4),
            InkWell(
              onTap: () => context.pushNamed(
                ResidencePage.name,
                pathParameters: {'idProduct': residence.id},
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    residence.nom,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.font(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  if (stayInfo != null) ...[
                    SizedBox(height: 4),
                    Text(
                      stayInfo,
                      style: AppTypography.font(
                          fontSize: 11, color: AppColors.immoTextSecondary),
                    ),
                  ],
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: coverImageId != null
                          ? CachedNetworkImage(
                              imageUrl: Utils.getImagePath(id: coverImageId),
                              fit: BoxFit.cover)
                          : Container(color: AppColors.immoBorderDefault),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "L'hôte dispose de 24 heures pour répondre.",
              style: AppTypography.font(
                  fontSize: 11, color: AppColors.immoTextSecondary),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () => _onBookingTap(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60)),
                ),
                child: Text(bookingLabel,
                    style: AppTypography.font(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisiteContextCard extends StatelessWidget {
  const _VisiteContextCard({required this.visitData});
  final DemandeVisiteModel visitData;

  String get _statusLabel {
    switch (visitData.statusDemandeVisite) {
      case 'en_cours_validation_user':
      case 'en_cours_validation_admin':
        return 'En attente';
      case 'successful':
        return 'Confirmée';
      case 'failed':
        return 'Refusée';
      default:
        return visitData.statusDemandeVisite ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bien = visitData.bienImmobilier!;
    final photoUrl = bien.images.isNotEmpty
        ? Utils.getImagePath(id: bien.images.first)
        : null;
    final dateLabel = visitData.datesDemandeVisite.isNotEmpty
        ? VisitUtilsDateFormat.format(visitData.datesDemandeVisite.last.date)
        : 'Aucune date programmée';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.immoBgSurfaceMuted,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 36,
              height: 36,
              child: photoUrl != null
                  ? CachedNetworkImage(imageUrl: photoUrl, fit: BoxFit.cover)
                  : Container(color: AppColors.immoBorderDefault),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bien.nom.isNotEmpty ? bien.nom : 'Bien immobilier',
                  style: AppTypography.font(
                      fontSize: 13, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$dateLabel · $_statusLabel',
                  style: AppTypography.font(
                      fontSize: 11, color: AppColors.immoTextSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.pushNamed(
              EstatePage.name,
              pathParameters: {'idProduct': bien.id},
            ),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: Text('Voir le bien',
                style: AppTypography.font(
                    fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

/// Petit helper de formatage local — évite de dépendre de `VisitUtils`
/// (module paiement) juste pour une date.
class VisitUtilsDateFormat {
  static String format(DateTime? date) {
    if (date == null) return 'Aucune date programmée';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}

class _SupportContextBanner extends StatelessWidget {
  const _SupportContextBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.immoBgSurfaceMuted,
      child: Row(
        children: [
          Icon(Iconsax.message_question, size: 18, color: AppColors.primary),
          SizedBox(width: 8),
          Text('Assistance ImmoPlus',
              style: AppTypography.font(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({
    required this.scrollController,
    required this.state,
    required this.peerName,
    required this.isSupport,
    required this.onAction,
    this.topCard,
  });

  final ScrollController scrollController;
  final ConversationThreadLoaded state;
  final String peerName;
  final bool isSupport;
  final ValueChanged<MessagingAction> onAction;

  /// Carte de contexte (résidence/visite/support) — s'affiche juste sous le
  /// tout premier message du fil (comme la card "Demande d'information
  /// envoyée" d'Airbnb sous le premier message envoyé à l'hôte), pas avant.
  final Widget? topCard;

  @override
  Widget build(BuildContext context) {
    final messages = state.messages;
    final cubit = context.read<ConversationThreadCubit>();

    final lastClientIndex = messages.lastIndexWhere((m) => m.isFromClient);
    final typingLabel = isSupport
        ? 'Un conseiller écrit…'
        : '$peerName est en train d\'écrire…';
    final topCardCount = topCard != null ? 1 : 0;
    final historyControlCount = cubit.hasOlderMessages ? 1 : 0;
    // Sous le premier message s'il y en a un, sinon en tout premier (fil vide).
    final cardPosition = messages.isNotEmpty ? 1 : 0;

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: historyControlCount +
          topCardCount +
          messages.length +
          (state.peerTyping ? 1 : 0),
      itemBuilder: (context, rawIndex) {
        if (historyControlCount == 1 && rawIndex == 0) {
          return _LoadOlderMessagesButton(
            scrollController: scrollController,
            onLoad: cubit.loadOlderMessages,
          );
        }
        final contentIndex = rawIndex - historyControlCount;
        if (topCard != null && contentIndex == cardPosition) return topCard!;
        final index = (topCard != null && contentIndex > cardPosition)
            ? contentIndex - topCardCount
            : contentIndex;

        if (index >= messages.length) {
          return ThreadTypingIndicator(label: typingLabel);
        }

        final message = messages[index];
        final previous = index > 0 ? messages[index - 1] : null;

        final showDaySeparator = previous == null ||
            (message.createdAt != null &&
                previous.createdAt != null &&
                formatDaySeparator(message.createdAt!) !=
                    formatDaySeparator(previous.createdAt!));

        final showAvatar = !message.isFromClient &&
            (previous == null || previous.isFromClient != message.isFromClient);

        final showReadMarker =
            index == lastClientIndex && state.peerLastReadAt != null;

        final canReportMessage = !message.isFromClient &&
            message.senderId != null &&
            message.type != 'system' &&
            message.type != 'system_event';

        return _AnimatedMessageEntry(
          messageId: message.id,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showDaySeparator && message.createdAt != null)
                DaySeparator(label: formatDaySeparator(message.createdAt!)),
              GestureDetector(
                onLongPress: canReportMessage
                    ? () => ReportConversationSheet.show(
                          context,
                          title: 'Signaler ce message',
                          onSubmit: ({required reason, details}) =>
                              cubit.reportMessage(
                            message.id,
                            reason: reason,
                            details: details,
                          ),
                        )
                    : null,
                child: MessageBubble(
                  message: message,
                  showAvatar: showAvatar,
                  showReadMarker: showReadMarker,
                  actionsEnabled: !state.conversation.isReadOnly,
                  onSuggestedReply: (reply) {
                    cubit.sendText(reply);
                  },
                  onChoiceSelected: ({
                    required topic,
                    required optionId,
                    required label,
                  }) async {
                    await cubit.sendChoiceAnswer(
                      topic: topic,
                      optionId: optionId,
                      label: label,
                    );
                  },
                  onAction: state.conversation.isReadOnly ? null : onAction,
                  // Une réponse guidée porte un payload (`topic`, `optionId`) qui
                  // n'est pas conservé dans une bulle optimiste. En cas d'échec,
                  // l'utilisateur retouche donc le choix serveur plutôt que de
                  // renvoyer un message incomplet.
                  onRetry: !state.conversation.isReadOnly &&
                          message.deliveryState ==
                              MessageDeliveryState.failed &&
                          message.type == 'text'
                      ? () => cubit.retryMessage(message.clientTempId!)
                      : null,
                  onDelete: message.deliveryState == MessageDeliveryState.failed
                      ? () => cubit.deleteFailedMessage(message.clientTempId!)
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedMessageEntry extends StatelessWidget {
  const _AnimatedMessageEntry({
    required this.messageId,
    required this.child,
  });

  final String messageId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(messageId),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 7 * (1 - value)),
          child: child,
        ),
      ),
    );
  }
}

class _LoadOlderMessagesButton extends StatefulWidget {
  const _LoadOlderMessagesButton({
    required this.scrollController,
    required this.onLoad,
  });

  final ScrollController scrollController;
  final Future<void> Function() onLoad;

  @override
  State<_LoadOlderMessagesButton> createState() =>
      _LoadOlderMessagesButtonState();
}

class _LoadOlderMessagesButtonState extends State<_LoadOlderMessagesButton> {
  bool _loading = false;

  Future<void> _load() async {
    if (_loading) return;
    final beforeExtent = widget.scrollController.hasClients
        ? widget.scrollController.position.maxScrollExtent
        : 0.0;
    final beforeOffset = widget.scrollController.hasClients
        ? widget.scrollController.offset
        : 0.0;
    setState(() => _loading = true);
    await widget.onLoad();
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.scrollController.hasClients) return;
      final addedExtent =
          widget.scrollController.position.maxScrollExtent - beforeExtent;
      widget.scrollController.jumpTo(beforeOffset + addedExtent);
    });
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextButton.icon(
          onPressed: _loading ? null : _load,
          icon: _loading
              ? const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Iconsax.clock, size: 17),
          label: Text(_loading ? 'Chargement…' : 'Messages précédents'),
        ),
      ),
    );
  }
}

class _ModerationBanner extends StatelessWidget {
  const _ModerationBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.immoFeedbackError.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.immoFeedbackError.withValues(alpha: 0.3)),
      ),
      child: Text(
        message,
        style: AppTypography.font(
            fontSize: 13, color: AppColors.immoFeedbackError),
      ),
    );
  }
}
