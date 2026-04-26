import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/data/repositories/furniture_repository.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/login_page/login_page.dart';
import 'package:immoplus/app/routes/app_router.dart';

import '../controllers/chat_controller.dart';
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
                        onSend: _chat.send,
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
        onSuggestionTap: _chat.send,
      );
    }

    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.only(
          top: ChatTokens.s8, bottom: ChatTokens.s16),
      itemCount: messages.length + (_chat.typing ? 1 : 0),
      itemBuilder: (context, index) {
        if (_chat.typing && index == messages.length) {
          return TypingIndicator(label: _chat.typingLabel);
        }
        final m = messages[index];
        if (m.role == ChatRole.user) return UserBubble(message: m);
        return AiBubble(message: m, onSend: _chat.send);
      },
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
