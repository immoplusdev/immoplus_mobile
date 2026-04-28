import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import 'chat_tokens.dart';

/// Bulle utilisateur (spec §3).
/// - max 75% largeur · fond #1A1A1A · texte blanc 15pt
/// - radius 20 · coin bas droit 6 (queue subtile)
/// - timestamp fade-in après 1.5s
/// - entrée : slide up 200ms + fade + scale 0.96→1.0
class UserBubble extends StatefulWidget {
  const UserBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  State<UserBubble> createState() => _UserBubbleState();
}

class _UserBubbleState extends State<UserBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  bool _showTimestamp = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _enter.forward();
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showTimestamp = true);
    });
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  String get _timeLabel {
    final t = widget.message.createdAt;
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final maxBubble = mediaWidth * 0.75;

    final fade = CurvedAnimation(parent: _enter, curve: Curves.easeOut);
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(fade);
    final scale = Tween<double>(begin: 0.96, end: 1.0).animate(fade);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ChatTokens.s16,
        ChatTokens.s4,
        ChatTokens.s16,
        ChatTokens.s8,
      ),
      child: FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: ScaleTransition(
            scale: scale,
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxBubble),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                        color: ChatTokens.neutral900,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      child: Text(
                        widget.message.text,
                        style: const TextStyle(
                          color: ChatTokens.neutral0,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.45,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: _showTimestamp ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, right: 4),
                    child: Text(
                      _timeLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
