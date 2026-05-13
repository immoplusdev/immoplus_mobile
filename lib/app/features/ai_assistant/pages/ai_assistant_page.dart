import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/data/repositories/furniture_repository.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/login_page/login_page.dart';
import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';
import 'package:immoplus/app/routes/app_router.dart';

import '../controllers/chat_controller.dart';
import '../models/chat_action.dart';
import '../models/chat_message.dart';
import '../services/chat_history_service.dart';
import '../services/chat_socket_service.dart';
import '../services/property_fetcher.dart';
import '../widgets/ai_bubble.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_history_drawer.dart';
import '../widgets/chat_tokens.dart';
import '../widgets/empty_state.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/user_bubble.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage>
    with SingleTickerProviderStateMixin {
  late final ChatController _chat;
  final ScrollController _scroll = ScrollController();
  late final String? _firstName;
  late final ChatHistoryService _historyService;
  bool _authRedirected = false;

  late final AnimationController _historyAnim;
  late final Animation<Offset> _historySlide;
  static const double _edgeWidth = 32;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    final session = getIt<SessionManager>();
    _firstName = session.currentUser?.firstName;
    _historyService = getIt<ChatHistoryService>();
    _chat = ChatController(
      ChatSocketService(session),
      fetcher: PropertyFetcher(
        getIt<BienImmobilierRepository>(),
        getIt<ResidenceRepository>(),
        getIt<FurnitureRepository>(),
      ),
      historyService: _historyService,
    );
    _chat.addListener(_onChatChange);
    _chat.init();

    _historyAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _historySlide = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _historyAnim,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));
  }

  void _onChatChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    });

    if (_chat.connection == ChatConnectionState.unauthenticated &&
        !_authRedirected) {
      _authRedirected = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
        AppRouter.router.push(LoginPage.routePath());
      });
    }
  }

  @override
  void dispose() {
    _chat.removeListener(_onChatChange);
    _chat.dispose();
    _scroll.dispose();
    _historyAnim.dispose();
    super.dispose();
  }

  // ─── History open/close ────────────────────────────────────────────────────

  void _openHistory() {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();
    _historyAnim.forward();
  }

  void _closeHistory() {
    _historyAnim.reverse();
  }

  void _handleChatAction(ChatActionModel action, ChatMessage _) {
    switch (action.id) {
      case 'confirm':
        _chat.send('Oui, confirmer');
        return;
      case 'modify':
        _chat.send('Non, modifier les critères');
        return;
      case 'cancel':
        _chat.send('Annuler');
        return;
      case 'create_alert':
        _chat.send(action.label);
        return;
      case 'continue_alert':
        _chat.send(action.label);
        return;
      case 'search_properties':
        _chat.send('Chercher un bien');
        return;
      case 'search_other_properties':
        _chat.send('Voir d\'autres biens');
        return;
      case 'contact_support':
        _handleSend('Contacter le support');
        return;
      default:
        _handleSend(action.label);
    }
  }

  void _navigateToPropositions(String alertId) {
    _navigateToImatch();
  }

  void _navigateToImatch() {
    HapticFeedback.lightImpact();
    if (!mounted) return;
    Navigator.of(context).pop();
    context.read<NavigationCubit>().switchPage(PageState.forMe);
  }

  void _navigateToProperty(String id, String entityType) {
    HapticFeedback.lightImpact();
    final route = switch (entityType) {
      'RESIDENCE' => '/residence_detail/$id',
      'FURNITURE' => '/furniture_detail/$id',
      _ => '/estate_detail/$id',
    };
    if (mounted) Navigator.of(context).pop();
    AppRouter.router.push(route);
  }

  Future<void> _openPaymentUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // Phrases qui ouvrent l'onglet Imatch au lieu d'envoyer un message au chat.
  static const _imatchPhrases = {
    'voir les résultats',
    'voir résultats',
    'voir mes résultats',
    'gérer mon alerte',
    'gérer l\'alerte',
    'gérer mes alertes',
    'voir mon alerte',
    'voir mes alertes',
    'voir les alertes',
    'voir alertes',
    'modifier l\'alerte',
    'modifier mes alertes',
    'mes alertes',
  };

  /// Intercepte les quickReplies spéciaux avant d'envoyer au serveur.
  void _handleSend(String text) {
    final normalized = text.trim().toLowerCase();

    if (normalized == 'contacter le support' ||
        normalized == 'contacter le service client') {
      _openSupportContact();
      return;
    }

    if (_imatchPhrases.contains(normalized)) {
      _navigateToImatch();
      return;
    }

    _chat.send(text);
  }

  void _openSupportContact() {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _SupportSheet(),
    );
  }

  // ─── Edge-swipe gesture ───────────────────────────────────────────────────

  void _onDragStart(DragStartDetails d) {
    final fromLeftEdge = d.globalPosition.dx < _edgeWidth;
    final fromAnywhereWhenOpen = _historyAnim.value > 0;
    if (fromLeftEdge || fromAnywhereWhenOpen) {
      _dragging = true;
    }
  }

  void _onDragUpdate(DragUpdateDetails d) {
    if (!_dragging) return;
    final width = MediaQuery.of(context).size.width;
    _historyAnim.value += d.primaryDelta! / width;
  }

  void _onDragEnd(DragEndDetails d) {
    if (!_dragging) return;
    _dragging = false;
    final v = d.primaryVelocity ?? 0;
    if (v > 500) {
      _historyAnim.forward();
    } else if (v < -500) {
      _historyAnim.reverse();
    } else {
      if (_historyAnim.value > 0.5) {
        _historyAnim.forward();
      } else {
        _historyAnim.reverse();
      }
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatTokens.neutral0,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: Stack(
          children: [
            _buildChatView(context),
            AnimatedBuilder(
              animation: _historyAnim,
              builder: (context, child) {
                if (_historyAnim.value == 0) return const SizedBox.shrink();
                return SlideTransition(
                  position: _historySlide,
                  child: child,
                );
              },
              child: _buildHistoryView(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatView(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatTokens.neutral0,
      appBar: _buildChatAppBar(context),
      body: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: _chat,
          builder: (context, _) {
            final isStreaming = _chat.typing ||
                _chat.messages.any((m) => m.status == ChatStatus.streaming);
            final isEmpty = _chat.messages.isEmpty &&
                !_chat.typing &&
                !_chat.loadingHistory;

            return Column(
              children: [
                _ConnectionBanner(connection: _chat.connection),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxWidth: ChatTokens.threadMaxWidth),
                      child: _buildThread(),
                    ),
                  ),
                ),
                if (!isEmpty)
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxWidth: ChatTokens.threadMaxWidth),
                      child: ChatComposer(
                        isStreaming: isStreaming,
                        onSend: _handleSend,
                        onStop: _chat.stopStreaming,
                        hint: _chat.composerHint,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHistoryView(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatTokens.neutral0,
      appBar: _buildHistoryAppBar(context),
      body: AnimatedBuilder(
        animation: _chat,
        builder: (context, _) => ChatHistoryDrawer(
          service: _historyService,
          currentSessionId: _chat.currentSessionId,
          onSessionSelected: (sessionId) async {
            _closeHistory();
            await _chat.loadSession(sessionId);
          },
          onNewConversation: () {
            _closeHistory();
            _chat.startNewConversation();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildChatAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: _AppBarIcon(
        icon: Iconsax.menu_1,
        onTap: _openHistory,
      ),
      actions: [
        _AppBarIcon(
          icon: Iconsax.add,
          onTap: () {
            HapticFeedback.lightImpact();
            _chat.startNewConversation();
          },
        ),
        _AppBarIcon(
          icon: Iconsax.close_circle,
          onTap: () {
            HapticFeedback.lightImpact();
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  PreferredSizeWidget _buildHistoryAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: _AppBarIcon(
        icon: Iconsax.arrow_left_2,
        onTap: _closeHistory,
      ),
      actions: [
        _AppBarIcon(
          icon: Iconsax.add,
          onTap: () {
            HapticFeedback.lightImpact();
            _closeHistory();
            _chat.startNewConversation();
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildThread() {
    if (_chat.loadingHistory) {
      return const Center(
        child: CircularProgressIndicator(
            strokeWidth: 2, color: ChatTokens.brand500),
      );
    }

    final messages = _chat.messages;
    if (messages.isEmpty && !_chat.typing) {
      return EmptyChatState(
        firstName: _firstName,
        onSuggestionTap: _handleSend,
      );
    }

    return ListView.builder(
      controller: _scroll,
      padding:
          const EdgeInsets.only(top: ChatTokens.s8, bottom: ChatTokens.s16),
      itemCount: messages.length + (_chat.typing ? 1 : 0),
      itemBuilder: (context, index) {
        if (_chat.typing && index == messages.length) {
          return TypingIndicator(label: _chat.typingLabel);
        }
        final m = messages[index];
        if (m.role == ChatRole.user) return UserBubble(message: m);
        final isLastAi = index == messages.length - 1;
        return AiBubble(
          message: m,
          isLast: isLastAi,
          onSend: _handleSend,
          onActionTap: _handleChatAction,
          onPaymentTap: (url) => _openPaymentUrl(url),
          onNavigateToPropositions: _navigateToPropositions,
          onPropertyTap: _navigateToProperty,
        );
      },
    );
  }
}

class _ConnectionBanner extends StatelessWidget {
  const _ConnectionBanner({required this.connection});
  final ChatConnectionState connection;

  @override
  Widget build(BuildContext context) {
    final (label, showSpinner, bg, fg) = switch (connection) {
      ChatConnectionState.connecting => (
          null,
          false,
          Colors.transparent,
          Colors.transparent,
        ),
      ChatConnectionState.reconnecting => (
          'Reconnexion…',
          true,
          ChatTokens.bannerWarnBg,
          ChatTokens.bannerWarnFg,
        ),
      ChatConnectionState.disconnected => (
          'Hors ligne — vérifie ta connexion',
          false,
          ChatTokens.bannerErrorBg,
          ChatTokens.bannerErrorFg,
        ),
      ChatConnectionState.error => (
          'Erreur de connexion',
          false,
          ChatTokens.bannerErrorBg,
          ChatTokens.bannerErrorFg,
        ),
      _ => (null, false, Colors.transparent, Colors.transparent),
    };

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: label == null
          ? const SizedBox.shrink()
          : Container(
              width: double.infinity,
              color: bg,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showSpinner) ...[
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: fg,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: fg,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _AppBarIcon extends StatelessWidget {
  const _AppBarIcon({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 22,
      icon: Icon(icon, color: ChatTokens.neutral900, size: 22),
      onPressed: onTap,
    );
  }
}

class _SupportSheet extends StatelessWidget {
  const _SupportSheet();

  static const _email = 'support@immoplus.ci';

  Future<void> _launchEmail() async {
    final uri = Uri(scheme: 'mailto', path: _email, queryParameters: {
      'subject': 'Demande de support ImmoPlus',
    });
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp() async {
    const phone = '2250779801183';
    final uri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: ChatTokens.neutral200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Contacter le support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ChatTokens.neutral900,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Notre équipe répond en moins de 24h.',
              style: TextStyle(
                fontSize: 14,
                color: ChatTokens.neutral400,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            _SupportOption(
              icon: Iconsax.sms,
              label: 'Email',
              value: _email,
              onTap: _launchEmail,
            ),
            const SizedBox(height: 12),
            _SupportOption(
              icon: Iconsax.message,
              label: 'WhatsApp',
              value: 'Ouvrir WhatsApp',
              onTap: _launchWhatsApp,
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportOption extends StatelessWidget {
  const _SupportOption({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: ChatTokens.neutral50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ChatTokens.borderStandard, width: 0.8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: ChatTokens.brandSurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: ChatTokens.brand500),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: ChatTokens.neutral900,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 12,
                          color: ChatTokens.neutral400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Iconsax.arrow_right_3,
                  size: 16,
                  color: ChatTokens.neutral400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
