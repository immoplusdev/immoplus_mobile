import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';

import '../controllers/chat_controller.dart';
import '../models/chat_message.dart';
import '../services/chat_socket_service.dart';
import '../widgets/ai_bubble.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_tokens.dart';
import '../widgets/empty_state.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/user_bubble.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  late final ChatController _chat;
  final ScrollController _scroll = ScrollController();
  late final String? _firstName;

  @override
  void initState() {
    super.initState();
    final session = getIt<SessionManager>();
    _firstName = session.currentUser?.firstName;
    _chat = ChatController(
      ChatSocketService(session),
    );
    _chat.addListener(_onChatChange);
    _chat.init();
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
  }

  @override
  void dispose() {
    _chat.removeListener(_onChatChange);
    _chat.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatTokens.neutral0,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: _chat,
          builder: (context, _) {
            final isStreaming = _chat.typing ||
                _chat.messages.any((m) => m.status == ChatStatus.streaming);
            final isEmpty =
                _chat.messages.isEmpty && !_chat.typing;

            return Column(
              children: [
                _ConnectionBanner(state: _chat.connection),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: ChatTokens.threadMaxWidth,
                      ),
                      child: _buildThread(),
                    ),
                  ),
                ),
                if (!isEmpty)
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: ChatTokens.threadMaxWidth,
                      ),
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: _AppBarIcon(
        icon: Iconsax.arrow_left_2,
        color: ChatTokens.neutral400,
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
        },
      ),
      title: const Text(
        'Immo AI',
        style: TextStyle(
          color: ChatTokens.neutral900,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildThread() {
    final messages = _chat.messages;
    final showEmpty = messages.isEmpty && !_chat.typing;

    if (showEmpty) {
      return EmptyChatState(
        firstName: _firstName,
        onSuggestionTap: _chat.send,
      );
    }

    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.only(
        top: ChatTokens.s8,
        bottom: ChatTokens.s16,
      ),
      itemCount: messages.length + (_chat.typing ? 1 : 0),
      itemBuilder: (context, index) {
        if (_chat.typing && index == messages.length) {
          return TypingIndicator(label: _chat.typingLabel);
        }
        final m = messages[index];
        if (m.role == ChatRole.user) {
          return UserBubble(message: m);
        }
        return AiBubble(message: m, onSend: _chat.send);
      },
    );
  }
}

class _AppBarIcon extends StatelessWidget {
  const _AppBarIcon({
    required this.icon,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 22,
      icon: Icon(icon, color: color ?? ChatTokens.neutral900, size: 22),
      onPressed: onTap,
    );
  }
}

/// Bandeau de connexion (spec §1) — 32px · slide down 200ms / slide up 200ms.
class _ConnectionBanner extends StatelessWidget {
  const _ConnectionBanner({required this.state});
  final ChatConnectionState state;

  @override
  Widget build(BuildContext context) {
    final cfg = _config();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) {
        final slide = Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(anim);
        return ClipRect(
          child: SlideTransition(
            position: slide,
            child: FadeTransition(opacity: anim, child: child),
          ),
        );
      },
      child: cfg == null
          ? const SizedBox(key: ValueKey('none'), width: double.infinity)
          : Container(
              key: ValueKey(state),
              width: double.infinity,
              height: 32,
              color: cfg.bg,
              padding: const EdgeInsets.symmetric(horizontal: ChatTokens.s16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cfg.icon, size: 14, color: cfg.fg),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      cfg.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: cfg.fg,
                        letterSpacing: -0.1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _BannerConfig? _config() {
    switch (state) {
      case ChatConnectionState.connecting:
        return const _BannerConfig(
          'Connexion…',
          ChatTokens.bannerNeutralBg,
          ChatTokens.bannerNeutralFg,
          Iconsax.wifi,
        );
      case ChatConnectionState.reconnecting:
        return const _BannerConfig(
          'Reconnexion…',
          ChatTokens.bannerWarnBg,
          ChatTokens.bannerWarnFg,
          Iconsax.wifi_square,
        );
      case ChatConnectionState.disconnected:
        return const _BannerConfig(
          'Hors ligne — messages envoyés à la reconnexion',
          ChatTokens.bannerErrorBg,
          ChatTokens.bannerErrorFg,
          Iconsax.wifi_square,
        );
      case ChatConnectionState.unauthenticated:
        return const _BannerConfig(
          'Connecte-toi pour utiliser l\'assistant',
          ChatTokens.bannerErrorBg,
          ChatTokens.bannerErrorFg,
          Iconsax.lock_1,
        );
      case ChatConnectionState.error:
        return const _BannerConfig(
          'Impossible de joindre le serveur',
          ChatTokens.bannerErrorBg,
          ChatTokens.bannerErrorFg,
          Iconsax.close_circle,
        );
      case ChatConnectionState.connected:
        return null;
    }
  }
}

class _BannerConfig {
  const _BannerConfig(this.label, this.bg, this.fg, this.icon);
  final String label;
  final Color bg;
  final Color fg;
  final IconData icon;
}
