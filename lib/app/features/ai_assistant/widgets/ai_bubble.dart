import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/widgets/tickets_cards/estate_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/furniture_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/residence_card.dart';

import '../models/chat_alert_payload.dart';
import '../models/chat_action.dart';
import '../models/chat_clarification.dart';
import '../models/chat_message.dart';
import '../models/property_card_data.dart';
import 'alert_card.dart';
import 'chat_response_actions.dart';
import 'chat_tokens.dart';
import 'clarification_chips.dart';
import 'intent_response_card.dart';

class AiBubble extends StatelessWidget {
  const AiBubble({
    super.key,
    required this.message,
    this.isLast = false,
    this.onSend,
    this.onActionTap,
    this.onPaymentTap,
    this.onNavigateToPropositions,
    this.onPropertyTap,
  });

  final ChatMessage message;
  /// true uniquement pour le dernier message IA — active quickReplies/actions.
  final bool isLast;
  final void Function(String text)? onSend;
  final void Function(ChatActionModel action, ChatMessage message)? onActionTap;
  final void Function(String url)? onPaymentTap;
  final void Function(String alertId)? onNavigateToPropositions;
  /// Callback navigation vers la fiche d'un bien — ferme le modal avant de naviguer.
  final void Function(String id, String entityType)? onPropertyTap;

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
                  isLast: isLast,
                  onSend: onSend,
                  onActionTap: onActionTap,
                  onPaymentTap: onPaymentTap,
                  onNavigateToPropositions: onNavigateToPropositions,
                  onPropertyTap: onPropertyTap,
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
  const AiAvatar(
      {super.key, this.error = false, this.size = ChatTokens.avatarSize});

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
    this.isLast = false,
    this.onSend,
    this.onActionTap,
    this.onPaymentTap,
    this.onNavigateToPropositions,
    this.onPropertyTap,
  });

  final ChatMessage message;
  final bool isError;
  final bool isLast;
  final void Function(String text)? onSend;
  final void Function(ChatActionModel action, ChatMessage message)? onActionTap;
  final void Function(String url)? onPaymentTap;
  final void Function(String alertId)? onNavigateToPropositions;
  final void Function(String id, String entityType)? onPropertyTap;

  @override
  Widget build(BuildContext context) {
    final isStreaming = message.status == ChatStatus.streaming;
    final text = message.text;
    final richBlock = _richBlock(message, isStreaming);
    final actionBlock = _actionBlock(message, isStreaming);

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
        if (actionBlock != null) actionBlock,
      ],
    );
  }

  Widget? _richBlock(ChatMessage m, bool isStreaming) {
    final type = m.responseType;
    if (type == null) return null;

    if (isStreaming) return _skeletonFor(type);

    switch (type) {
      case AlertResponseType.alertConfirmation:
      case AlertResponseType.visitCreated:
      case AlertResponseType.bookingCreated:
      case AlertResponseType.bookingStatus:
      case AlertResponseType.bookingCancelled:
      case AlertResponseType.paymentCreated:
        return IntentResponseCard(
          message: m,
          onPaymentTap: onPaymentTap,
        );
      case AlertResponseType.alertCreated:
        final payload = ChatAlertPayload.fromData(m.data);
        return AlertCard(
          payload: payload,
          onNavigateToPropositions: onNavigateToPropositions,
          onPropertyTap: onPropertyTap,
          onSeeAll:
              onSend == null ? null : () => onSend!('Voir les résultats'),
          onManage:
              onSend == null ? null : () => onSend!('Gérer mon alerte'),
        );
      case AlertResponseType.alertUpdated:
        final payload = ChatAlertPayload.fromData(m.data);
        return AlertCard(
          payload: payload,
          variant: AlertCardVariant.updated,
          onNavigateToPropositions: onNavigateToPropositions,
          onPropertyTap: onPropertyTap,
          onSeeAll:
              onSend == null ? null : () => onSend!('Voir les résultats'),
          onManage:
              onSend == null ? null : () => onSend!('Gérer mon alerte'),
        );
      case AlertResponseType.showResults:
        final payload = ChatAlertPayload.fromData(m.data);
        return AlertCard(
          payload: payload,
          variant: AlertCardVariant.results,
          maxInline: 5,
          onNavigateToPropositions: onNavigateToPropositions,
          onPropertyTap: onPropertyTap,
          onSeeAll:
              onSend == null ? null : () => onSend!('Voir les résultats'),
          onManage:
              onSend == null ? null : () => onSend!('Gérer mon alerte'),
        );
      case AlertResponseType.alertClarification:
        if (onSend == null || !isLast) return null;
        final clar = ChatClarification.fromData(m.data);
        return ClarificationBlock(
          clarification: clar,
          quickReplies: m.quickReplies,
          onSend: onSend!,
        );
      case AlertResponseType.error:
        if (onSend == null || !isLast) return null;
        return ErrorReformulationChips(onSend: onSend!);
      case AlertResponseType.propertyAnswer:
        final cards = m.propertyCards;
        if (cards == null) return const _PropertyCardsSkeleton();
        if (cards.isEmpty) return null;
        return _FadeIn(
          duration: const Duration(milliseconds: 300),
          child: _PropertyCardsCarousel(
            propertyCards: cards,
            onPropertyTap: onPropertyTap,
          ),
        );
      case AlertResponseType.alertDeleted:
        if (onSend == null || !isLast) return null;
        return _AlertDeletedActions(onSend: onSend!);
      case AlertResponseType.generalAdvice:
      case AlertResponseType.transactionClarification:
      case AlertResponseType.propertyMatch:
      case AlertResponseType.unknown:
        return null;
    }
  }

  Widget? _skeletonFor(AlertResponseType type) {
    switch (type) {
      case AlertResponseType.alertConfirmation:
        return const _SkeletonCard(rows: 3);
      case AlertResponseType.alertCreated:
      case AlertResponseType.alertUpdated:
      case AlertResponseType.showResults:
        return const _AlertCardSkeleton();
      case AlertResponseType.alertClarification:
        return const _ChipsSkeleton();
      case AlertResponseType.propertyAnswer:
        return const _PropertyCardsSkeleton();
      default:
        return null;
    }
  }

  Widget? _actionBlock(ChatMessage m, bool isStreaming) {
    if (isStreaming || !isLast || onSend == null) return null;
    if (m.quickReplies.isEmpty && m.actions.isEmpty) return null;
    if (m.responseType == AlertResponseType.alertClarification &&
        m.quickReplies.isNotEmpty) {
      return null;
    }

    // Si des actions structurées existent, les quickReplies sont redondants
    // (le backend les envoie parfois en double pour compatibilité).
    final quickReplies = m.actions.isNotEmpty ? const <String>[] : m.quickReplies;

    return ChatResponseActions(
      quickReplies: quickReplies,
      actions: m.actions,
      onQuickReplyTap: onSend,
      onActionTap:
          onActionTap == null ? null : (action) => onActionTap!(action, m),
    );
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
    this.onPropertyTap,
  });

  final List<PropertyCardData> propertyCards;
  final void Function(String id, String entityType)? onPropertyTap;

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
    final Widget inner;
    final String entityType = data.entityType;

    switch (entityType) {
      case 'RESIDENCE':
        if (data.model is! ResidenceModel) return const SizedBox.shrink();
        inner = ResidenceCard(residence: data.model as ResidenceModel);
      case 'FURNITURE':
        if (data.model is! FurnitureModel) return const SizedBox.shrink();
        inner = FurnitureCard(furniture: data.model as FurnitureModel);
      default:
        if (data.model is! BienImmobilierModel) return const SizedBox.shrink();
        inner = EstateCard(
            bienImmobilierModel: data.model as BienImmobilierModel);
    }

    final onTap = widget.onPropertyTap;
    if (onTap == null) return inner;

    final id = _idFromModel(data.model);
    if (id == null) return inner;

    // AbsorbPointer désactive la navigation interne de la card ;
    // GestureDetector extérieur ferme le modal avant de naviguer.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(id, entityType),
      child: AbsorbPointer(child: inner),
    );
  }

  static String? _idFromModel(dynamic model) {
    if (model is BienImmobilierModel) return model.id;
    if (model is ResidenceModel) return model.id;
    if (model is FurnitureModel) return model.id;
    return null;
  }
}

class _AlertDeletedActions extends StatelessWidget {
  const _AlertDeletedActions({required this.onSend});
  final void Function(String text) onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: ChatTokens.s10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _FadeIn(
            duration: const Duration(milliseconds: 220),
            child: _NewAlertChip(onSend: onSend),
          ),
        ],
      ),
    );
  }
}

class _NewAlertChip extends StatelessWidget {
  const _NewAlertChip({required this.onSend});
  final void Function(String text) onSend;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onSend('Je veux créer une nouvelle alerte');
        },
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            color: ChatTokens.brandSurface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: ChatTokens.brandBorder20, width: 0.5),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              'Créer une nouvelle alerte',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ChatTokens.brand500,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Skeleton widgets (shimmer réel via package shimmer) ─────────────────────

/// Boite statique utilisée comme enfant de Shimmer — ne gère pas l'animation.
class _Box extends StatelessWidget {
  const _Box({required this.width, required this.height, this.radius = 8});
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Couleurs du shimmer — base gris léger, highlight blanc.
const Color _shimmerBase = ChatTokens.neutral100;
const Color _shimmerHighlight = ChatTokens.neutral0;

/// Skeleton card générique — pour alert_confirmation.
class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({this.rows = 3});
  final int rows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: ChatTokens.s12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ChatTokens.neutral0,
          borderRadius: BorderRadius.circular(ChatTokens.cardRadius),
          border: Border.all(color: ChatTokens.borderStandard, width: 0.5),
          boxShadow: ChatTokens.cardShadow,
        ),
        child: Shimmer.fromColors(
          baseColor: _shimmerBase,
          highlightColor: _shimmerHighlight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: const [
                _Box(width: 16, height: 16, radius: 4),
                SizedBox(width: 8),
                _Box(width: 80, height: 12, radius: 4),
              ]),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(
                  rows,
                  (i) => _Box(width: 60.0 + i * 16, height: 24, radius: 999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton pour alert_created / alert_updated / show_results.
class _AlertCardSkeleton extends StatelessWidget {
  const _AlertCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: ChatTokens.s12),
      child: Container(
        decoration: BoxDecoration(
          color: ChatTokens.neutral0,
          borderRadius: BorderRadius.circular(ChatTokens.cardRadius),
          border: Border.all(color: ChatTokens.borderStandard, width: 0.5),
          boxShadow: ChatTokens.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Shimmer.fromColors(
          baseColor: _shimmerBase,
          highlightColor: _shimmerHighlight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(children: [
                      _Box(width: 16, height: 16, radius: 4),
                      SizedBox(width: 8),
                      _Box(width: 90, height: 12, radius: 4),
                    ]),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _Box(width: 56, height: 20, radius: 999),
                        _Box(width: 72, height: 20, radius: 999),
                        _Box(width: 48, height: 20, radius: 999),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 0.5, color: ChatTokens.divider),
              for (var i = 0; i < 2; i++) ...[
                if (i > 0)
                  const Divider(height: 1, thickness: 0.5, color: ChatTokens.divider),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(children: const [
                    _Box(width: 48, height: 48, radius: 8),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Box(width: double.infinity, height: 11, radius: 4),
                          SizedBox(height: 6),
                          _Box(width: 80, height: 10, radius: 4),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
              const Divider(height: 1, thickness: 0.5, color: ChatTokens.divider),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(children: [
                  _Box(width: 120, height: 12, radius: 4),
                  Spacer(),
                  _Box(width: 72, height: 12, radius: 4),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton pour alert_clarification — chips en ligne.
class _ChipsSkeleton extends StatelessWidget {
  const _ChipsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: ChatTokens.s10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ChatTokens.neutral0,
          borderRadius: BorderRadius.circular(ChatTokens.cardRadius),
          border: Border.all(color: ChatTokens.borderStandard, width: 0.5),
        ),
        child: Shimmer.fromColors(
          baseColor: _shimmerBase,
          highlightColor: _shimmerHighlight,
          child: const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Box(width: 80, height: 32, radius: 999),
              _Box(width: 64, height: 32, radius: 999),
              _Box(width: 96, height: 32, radius: 999),
              _Box(width: 72, height: 32, radius: 999),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton pour property_answer — remplace la carte pendant le chargement API.
class _PropertyCardsSkeleton extends StatelessWidget {
  const _PropertyCardsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: ChatTokens.s12),
      child: Shimmer.fromColors(
        baseColor: _shimmerBase,
        highlightColor: _shimmerHighlight,
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
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
