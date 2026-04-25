import 'dart:math' as math;
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'package:immoplus/app/utils/app_colors.dart';

/// Écran d'accueil du chat — Immo AI Empty State 2026.
///
/// Logo dans cercle glassmorphisme animé, titre dynamique avec prénom,
/// composer hero (pilule 54px, fond transparent, bordure gris léger,
/// placeholder typewriter) dans le flux, puis grille 2×2 de cards outline.
/// Les cards disparaissent (fade 150ms) au premier envoi effectif.
class EmptyChatState extends StatefulWidget {
  const EmptyChatState({
    super.key,
    required this.onSuggestionTap,
    this.firstName,
  });

  /// Appelé pour envoyer un message — depuis une card ou le composer hero.
  final void Function(String text) onSuggestionTap;

  /// Prénom de l'utilisateur connecté (peut être null/vide).
  final String? firstName;

  @override
  State<EmptyChatState> createState() => _EmptyChatStateState();
}

class _EmptyChatStateState extends State<EmptyChatState> {
  static const Color _ink = Color(0xFF1A1A1A);
  static const Color _placeholder = Color(0xFFBBBBBB);
  static const Color _composerBorder = Color(0xFFF0F0F0);

  static const List<_Card> _cards = [
    _Card(
      label: 'Appart 2p à Cocody max 500k',
      icon: Iconsax.buildings_2,
    ),
    _Card(
      label: 'Prix d\'un bien à Marcory',
      icon: Iconsax.tag_right,
    ),
    _Card(
      label: 'Villa avec piscine',
      icon: Iconsax.cup,
    ),
    _Card(
      label: 'Procédure d\'achat',
      icon: Iconsax.document_text,
    ),
  ];

  static const List<String> _typewriterPhrases = [
    'Trouve un bien',
    'Crée une alerte…',
    'Demande un conseil…',
  ];

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _cardsVisible = true;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final has = _controller.text.isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit(String text) {
    final t = text.trim();
    if (t.isEmpty) {
      _focusNode.requestFocus();
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() => _cardsVisible = false);
    widget.onSuggestionTap(t);
    _controller.clear();
  }

  void _onCardTap(String label) {
    HapticFeedback.lightImpact();
    setState(() => _cardsVisible = false);
    widget.onSuggestionTap(label);
  }

  String get _greeting {
    final raw = widget.firstName?.trim();
    if (raw == null || raw.isEmpty) return 'Bonjour 👋';
    return 'Bonjour, $raw 👋';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Logo(),
            const SizedBox(height: 24),
            _HeroTitle(text: _greeting),
            const SizedBox(height: 32),
            _HeroComposer(
              controller: _controller,
              focusNode: _focusNode,
              onSubmit: _submit,
              borderColor: _composerBorder,
              ink: _ink,
              placeholder: _placeholder,
              sendBg: AppColors.primary,
              showTypewriter: !_hasText,
              typewriterPhrases: _typewriterPhrases,
            ),
            const SizedBox(height: 24),
            AnimatedOpacity(
              opacity: _cardsVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              child: IgnorePointer(
                ignoring: !_cardsVisible,
                child: _SuggestionsGrid(
                  cards: _cards,
                  onTap: _onCardTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card {
  const _Card({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

class _Logo extends StatefulWidget {
  const _Logo();

  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> with SingleTickerProviderStateMixin {
  static const double _circleSize = 140;
  static const double _logoSize = 84;

  late final AnimationController _orb = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4000),
  )..repeat();

  @override
  void dispose() {
    _orb.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: _circleSize,
        height: _circleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 28,
              spreadRadius: 1,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.95),
                    const Color(0xFFF5F3EF).withValues(alpha: 0.85),
                    const Color(0xFFE8E4DC).withValues(alpha: 0.75),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.9),
                  width: 1,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _orb,
                      builder: (context, _) {
                        final t = _orb.value;
                        return Align(
                          alignment: Alignment(
                            math.sin(t * 2 * math.pi) * 0.55,
                            math.sin(t * 4 * math.pi) * 0.4,
                          ),
                          child: ImageFiltered(
                            imageFilter:
                                ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromRGBO(0, 194, 255, 0),
                                    Color(0xFFFF29C3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  IgnorePointer(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 26,
                        margin: const EdgeInsets.symmetric(horizontal: 22),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.95),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/icon/icon_radius.png',
                      width: _logoSize,
                      height: _logoSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroTitle extends StatefulWidget {
  const _HeroTitle({required this.text});
  final String text;

  @override
  State<_HeroTitle> createState() => _HeroTitleState();
}

class _HeroTitleState extends State<_HeroTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  late final Animation<double> _angle = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.4), weight: 8),
    TweenSequenceItem(tween: Tween(begin: 0.4, end: -0.4), weight: 14),
    TweenSequenceItem(tween: Tween(begin: -0.4, end: 0.4), weight: 14),
    TweenSequenceItem(tween: Tween(begin: 0.4, end: 0.0), weight: 8),
    TweenSequenceItem(tween: ConstantTween(0.0), weight: 56),
  ]).animate(_wave);

  static const TextStyle _style = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    height: 1.2,
  );

  @override
  void dispose() {
    _wave.dispose();
    super.dispose();
  }

  (String, String) _split() {
    final raw = widget.text;
    final runes = raw.runes.toList();
    if (runes.isEmpty) return (raw, '');
    final lastChar = String.fromCharCode(runes.last);
    if (lastChar != '👋') return (raw, '');
    final headRunes = runes.sublist(0, runes.length - 1);
    final head = String.fromCharCodes(headRunes).trimRight();
    return (head, '👋');
  }

  @override
  Widget build(BuildContext context) {
    final (head, emoji) = _split();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            head,
            textAlign: TextAlign.center,
            style: _style.copyWith(color: AppColors.primary),
          ),
        ),
        if (emoji.isNotEmpty) ...[
          const SizedBox(width: 6),
          AnimatedBuilder(
            animation: _angle,
            builder: (context, child) => Transform.rotate(
              angle: _angle.value,
              alignment: Alignment.bottomCenter,
              child: child,
            ),
            child: Text(emoji, style: _style),
          ),
        ],
      ],
    );
  }
}

class _HeroComposer extends StatelessWidget {
  const _HeroComposer({
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
    required this.borderColor,
    required this.ink,
    required this.placeholder,
    required this.sendBg,
    required this.showTypewriter,
    required this.typewriterPhrases,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String text) onSubmit;
  final Color borderColor;
  final Color ink;
  final Color placeholder;
  final Color sendBg;
  final bool showTypewriter;
  final List<String> typewriterPhrases;

  @override
  Widget build(BuildContext context) {
    final hintStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: placeholder,
      height: 1.3,
    );

    return Container(
      height: 54,
      padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Row(
        children: [
          Icon(Iconsax.message_edit, size: 18, color: placeholder),
          const SizedBox(width: 10),
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                if (showTypewriter)
                  IgnorePointer(
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(milliseconds: 1400),
                      animatedTexts: [
                        for (final phrase in typewriterPhrases)
                          TypewriterAnimatedText(
                            phrase,
                            textStyle: hintStyle,
                            speed: const Duration(milliseconds: 70),
                          ),
                      ],
                    ),
                  ),
                TextField(
                  controller: controller,
                  focusNode: focusNode,
                  maxLines: 1,
                  cursorColor: sendBg,
                  cursorWidth: 1.6,
                  textInputAction: TextInputAction.send,
                  onSubmitted: onSubmit,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ink,
                    height: 1.3,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _SendButton(
            onTap: () => onSubmit(controller.text),
            background: sendBg,
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.onTap, required this.background});

  final VoidCallback onTap;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Iconsax.arrow_up_3,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SuggestionsGrid extends StatelessWidget {
  const _SuggestionsGrid({required this.cards, required this.onTap});

  final List<_Card> cards;
  final void Function(String label) onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 100,
      ),
      itemBuilder: (context, i) {
        final c = cards[i];
        return _SuggestionCard(card: c, onTap: () => onTap(c.label));
      },
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.card, required this.onTap});

  final _Card card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(card.icon, size: 22, color: AppColors.primary),
                const Spacer(),
                Text(
                  card.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _EmptyChatStateState._ink,
                    height: 1.25,
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
