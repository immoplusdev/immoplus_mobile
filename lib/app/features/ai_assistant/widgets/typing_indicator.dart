import 'dart:async';

import 'package:flutter/material.dart';

import 'ai_bubble.dart';
import 'chat_tokens.dart';

/// Indicateur de typing (spec §6).
/// - Avatar logo + label "Immo AI"
/// - Bulle pill #F4F4F5 · 3 dots #2744DE · label dynamique
/// - Labels : 0-2s "Immo AI réfléchit…", 2-4s "Je cherche dans les biens…",
///            4s+ "Je compare les résultats…"
/// - Cross-fade 300ms entre labels
/// - Entrée : scale 0.9→1 + fade · 200ms
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key, this.label});

  /// Label optionnel (override). Si null → labels dynamiques par défaut.
  final String? label;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _dots = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  Timer? _ticker;
  int _phase = 0; // 0: réfléchit, 1: cherche, 2: compare

  static const _labels = [
    'Immo AI réfléchit…',
    'Je cherche dans les biens…',
    'Je compare les résultats…',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _enter.forward();
    });
    if (widget.label == null) {
      _ticker = Timer.periodic(const Duration(seconds: 2), (_) {
        if (!mounted) return;
        if (_phase < 2) setState(() => _phase++);
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _dots.dispose();
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label ?? _labels[_phase];
    final fade = CurvedAnimation(parent: _enter, curve: Curves.easeOut);
    final scale = Tween<double>(begin: 0.9, end: 1.0).animate(fade);

    return Semantics(
      liveRegion: true,
      label: label,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          ChatTokens.s16,
          ChatTokens.s8,
          ChatTokens.s16,
          ChatTokens.s8,
        ),
        child: FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AiAvatar(),
                const SizedBox(width: ChatTokens.s10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                          'Immo AI',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ChatTokens.neutral400,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: ChatTokens.neutral100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _Dot(controller: _dots, delay: 0.0),
                            const SizedBox(width: 4),
                            _Dot(controller: _dots, delay: 0.2),
                            const SizedBox(width: 4),
                            _Dot(controller: _dots, delay: 0.4),
                            const SizedBox(width: 10),
                            Flexible(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, anim) =>
                                    FadeTransition(opacity: anim, child: child),
                                child: Text(
                                  label,
                                  key: ValueKey(label),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: ChatTokens.neutral400,
                                    letterSpacing: -0.1,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _Dot extends StatelessWidget {
  const _Dot({required this.controller, required this.delay});
  final AnimationController controller;
  final double delay;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = (controller.value + delay) % 1.0;
        final scale = 0.7 + (1 - (t * 2 - 1).abs()) * 0.5;
        return Opacity(
          opacity: 0.35 + (scale - 0.7) * 1.3,
          child: Transform.scale(
            scale: scale.clamp(0.7, 1.2),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: ChatTokens.brand500,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
