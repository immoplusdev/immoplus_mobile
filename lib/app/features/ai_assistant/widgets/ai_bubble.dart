import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/widgets/tickets_cards/estate_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/furniture_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/residence_card.dart';

import '../models/chat_alert_payload.dart';
import '../models/chat_clarification.dart';
import '../models/chat_message.dart';
import '../models/property_card_data.dart';
import 'alert_card.dart';
import 'chat_tokens.dart';
import 'clarification_chips.dart';

class AiBubble extends StatelessWidget {
  const AiBubble({
    super.key,
    required this.message,
    this.onSend,
  });

  final ChatMessage message;
  final void Function(String text)? onSend;

  bool get _isError =>
      message.status == ChatStatus.error ||
      message.responseType == AlertResponseType.error;

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final maxBubble = mediaWidth * 0.85;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ChatTokens.s16,
        ChatTokens.s8,
        ChatTokens.s16,
        ChatTokens.s8,
      ),
      child: _FadeIn(
        duration: const Duration(milliseconds: 250),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxBubble),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AiAvatar(error: _isError),
              const SizedBox(width: ChatTokens.s10),
              Flexible(
                child: _Content(
                  message: message,
                  isError: _isError,
                  onSend: onSend,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Avatar IA — utilise `assets/icon/icon_radius.png` (spec §2 + §14).
class AiAvatar extends StatelessWidget {
  const AiAvatar({super.key, this.error = false, this.size = ChatTokens.avatarSize});

  final bool error;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (error) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: ChatTokens.dangerSurface,
          borderRadius: BorderRadius.circular(ChatTokens.avatarRadius),
          border: Border.all(
            color: ChatTokens.danger500.withValues(alpha: 0.20),
            width: 0.5,
          ),
        ),
        child: const Center(
          child: Icon(Iconsax.warning_2, color: ChatTokens.danger500, size: 18),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ChatTokens.brandSurface,
        borderRadius: BorderRadius.circular(ChatTokens.avatarRadius),
        border: Border.all(color: ChatTokens.brandBorder15, width: 0.5),
      ),
      child: Center(
        child: Image.asset(
          ChatTokens.aiLogoAsset,
          width: ChatTokens.avatarLogoSize,
          height: ChatTokens.avatarLogoSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.message,
    required this.isError,
    this.onSend,
  });

  final ChatMessage message;
  final bool isError;
  final void Function(String text)? onSend;

  @override
  Widget build(BuildContext context) {
    final isStreaming = message.status == ChatStatus.streaming;
    final text = message.text;
    final richBlock = _richBlock(message, isStreaming);

    return Column(
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
        if (text.isEmpty && isStreaming)
          const StreamingCursor()
        else if (text.isNotEmpty)
          _MarkdownBody(text: text, isError: isError),
        if (isStreaming && text.isNotEmpty) ...[
          const SizedBox(height: 2),
          const StreamingCursor(),
        ],
        if (richBlock != null) ...[
          const SizedBox(height: ChatTokens.s12),
          richBlock,
        ],
      ],
    );
  }

  Widget? _richBlock(ChatMessage m, bool isStreaming) {
    if (isStreaming) return null;
    final type = m.responseType;
    if (type == null) return null;

    switch (type) {
      case AlertResponseType.alertCreated:
        return AlertCard(payload: ChatAlertPayload.fromData(m.data));
      case AlertResponseType.alertUpdated:
        return AlertCard(
          payload: ChatAlertPayload.fromData(m.data),
          variant: AlertCardVariant.updated,
        );
      case AlertResponseType.showResults:
        return AlertCard(
          payload: ChatAlertPayload.fromData(m.data),
          maxInline: 5,
        );
      case AlertResponseType.alertClarification:
        if (onSend == null) return null;
        final clar = ChatClarification.fromData(m.data);
        return ClarificationBlock(
          clarification: clar,
          onSend: onSend!,
        );
      case AlertResponseType.error:
        if (onSend == null) return null;
        return ErrorReformulationChips(onSend: onSend!);
      case AlertResponseType.propertyAnswer:
        final cards = m.propertyCards;
        if (cards == null || cards.isEmpty) return null;
        return _FadeIn(
          duration: const Duration(milliseconds: 300),
          child: _PropertyCardsCarousel(propertyCards: cards),
        );
      case AlertResponseType.alertDeleted:
      case AlertResponseType.generalAdvice:
      case AlertResponseType.unknown:
        return null;
    }
  }
}

class _MarkdownBody extends StatelessWidget {
  const _MarkdownBody({required this.text, required this.isError});
  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final color = isError ? ChatTokens.danger500 : ChatTokens.neutral900;
    return MarkdownBody(
      data: text,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          fontSize: 15,
          height: 1.55,
          color: color,
          letterSpacing: -0.1,
        ),
        strong: TextStyle(fontWeight: FontWeight.w700, color: color),
        em: TextStyle(fontStyle: FontStyle.italic, color: color),
        listBullet: TextStyle(fontSize: 15, height: 1.55, color: color),
        listIndent: 18,
        blockSpacing: 10,
        a: const TextStyle(
          color: ChatTokens.brand500,
          decoration: TextDecoration.underline,
          decorationThickness: 1.2,
        ),
        code: const TextStyle(
          fontSize: 13,
          backgroundColor: ChatTokens.neutral100,
          color: ChatTokens.neutral900,
          fontFamily: 'monospace',
        ),
        codeblockDecoration: BoxDecoration(
          color: ChatTokens.neutral100,
          borderRadius: BorderRadius.circular(ChatTokens.cardRadius),
        ),
        codeblockPadding: const EdgeInsets.all(ChatTokens.s12),
        blockquoteDecoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: ChatTokens.borderStandard, width: 2),
          ),
        ),
        blockquotePadding: const EdgeInsets.only(left: ChatTokens.s12),
        h1: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: ChatTokens.neutral900,
          letterSpacing: -0.3,
        ),
        h2: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: ChatTokens.neutral900,
          letterSpacing: -0.2,
        ),
        h3: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: ChatTokens.neutral900,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

/// Curseur de streaming (spec §5).
class StreamingCursor extends StatefulWidget {
  const StreamingCursor({super.key});

  @override
  State<StreamingCursor> createState() => _StreamingCursorState();
}

class _StreamingCursorState extends State<StreamingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: Container(
        width: 7,
        height: 14,
        margin: const EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: ChatTokens.brand500,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

/// Helper one-shot fade-in (spec §12).
class _FadeIn extends StatefulWidget {
  const _FadeIn({required this.child, required this.duration});
  final Widget child;
  final Duration duration;

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _opacity = 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: widget.duration,
      curve: Curves.easeOut,
      child: widget.child,
    );
  }
}

/// Affiche les cartes natives (EstateCard, ResidenceCard, FurnitureCard) en carrousel horizontal.
class _PropertyCardsCarousel extends StatefulWidget {
  const _PropertyCardsCarousel({
    required this.propertyCards,
  });

  final List<PropertyCardData> propertyCards;

  @override
  State<_PropertyCardsCarousel> createState() => _PropertyCardsCarouselState();
}

class _PropertyCardsCarouselState extends State<_PropertyCardsCarousel> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController()
      ..addListener(() {
        final page = _controller.page?.round() ?? 0;
        if (page != _index) setState(() => _index = page);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = widget.propertyCards;
    if (cards.isEmpty) return const SizedBox.shrink();

    if (cards.length == 1) {
      return _buildCard(cards.first);
    }

    return Column(
      children: [
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildCard(cards[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _DotsIndicator(count: cards.length, current: _index),
      ],
    );
  }

  Widget _buildCard(PropertyCardData data) {
    switch (data.entityType) {
      case 'RESIDENCE':
        if (data.model is ResidenceModel) {
          return ResidenceCard(residence: data.model as ResidenceModel);
        }
        return const SizedBox.shrink();

      case 'FURNITURE':
        if (data.model is FurnitureModel) {
          return FurnitureCard(furniture: data.model as FurnitureModel);
        }
        return const SizedBox.shrink();

      default: // BIEN_IMMOBILIER
        if (data.model is BienImmobilierModel) {
          return EstateCard(bienImmobilierModel: data.model as BienImmobilierModel);
        }
        return const SizedBox.shrink();
    }
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? ChatTokens.brand500 : ChatTokens.neutral200,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
