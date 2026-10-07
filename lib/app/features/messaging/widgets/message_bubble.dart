import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../data/models/remote/messaging/message_model.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/booking/booking_detail_page.dart';
import 'package:immoplus/app/features/booking/pending_payment/pending_payment_reservations_page.dart';
import 'location_card_message.dart';
import '../utils/messaging_time_format.dart';

/// Les anciennes actions de disponibilité ne correspondent plus au contrat
/// actuel. Toutes les autres actions calculées par le serveur restent visibles.
bool isMessagingActionVisible(MessagingAction action) {
  const allowedIds = {
    'view_residence',
    'view_reservation',
    'pick_dates',
    'book_now',
    'pay_reservation',
    'cancel_reservation',
    'open_checkin_qr',
    'rate_stay',
    'open_support',
    'open_arrival_info',
    'share_residence_card',
    'share_reservation_card',
  };
  return allowedIds.contains(action.id);
}

/// Bulle de message (spec §5.3/5.4) : à droite/primary pour le client, à
/// gauche/neutre pour le pro. Avatar affiché seulement sur la première
/// bulle d'un groupe consécutif (contrôlé par [showAvatar]).
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.showAvatar,
    required this.showReadMarker,
    this.actionsEnabled = true,
    this.onSuggestedReply,
    this.onChoiceSelected,
    this.onAction,
    this.onRetry,
    this.onDelete,
  });

  final MessageModel message;
  final bool showAvatar;
  final bool showReadMarker;
  final bool actionsEnabled;
  final ValueChanged<String>? onSuggestedReply;
  final Future<void> Function({
    required String topic,
    required String optionId,
    required String label,
  })? onChoiceSelected;
  final ValueChanged<MessagingAction>? onAction;
  final VoidCallback? onRetry;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    if (message.type == 'location_card') {
      return LocationCardMessage(message: message);
    }
    if (message.type != 'text') {
      return _ServerMessageCard(
        message: message,
        onSuggestedReply: onSuggestedReply,
        onChoiceSelected: onChoiceSelected,
        onAction: onAction,
        actionsEnabled: actionsEnabled,
      );
    }
    final isClient = message.isFromClient;
    final maxWidth = MediaQuery.of(context).size.width * 0.75;

    return Padding(
      padding: EdgeInsets.only(
        left: isClient ? 48 : 16,
        right: isClient ? 16 : 48,
        top: 2,
        bottom: 2,
      ),
      child: Column(
        crossAxisAlignment:
            isClient ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isClient) ...[
                SizedBox(
                  width: 28,
                  height: 28,
                  child: showAvatar
                      ? CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.primaryLite,
                          child: Icon(Iconsax.user,
                              size: 16, color: AppColors.primary),
                        )
                      : null,
                ),
                SizedBox(width: 8),
              ],
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isClient
                        ? AppColors.primary
                        : AppColors.immoBgSurfaceMuted,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isClient ? 18 : 4),
                      bottomRight: Radius.circular(isClient ? 4 : 18),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: AppTypography.font(
                      fontSize: 15,
                      height: 1.4,
                      color:
                          isClient ? AppColors.white : const Color(0xFF1F2937),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              left: isClient ? 0 : 36,
              right: isClient ? 0 : 0,
            ),
            child: _StatusRow(
              message: message,
              showReadMarker: showReadMarker,
              onRetry: onRetry,
              onDelete: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte neutre pilotée par le serveur pour les messages structurés. Les
/// données viennent du payload ; aucun statut, montant ou CTA n'est inventé.
class _ServerMessageCard extends StatelessWidget {
  const _ServerMessageCard({
    required this.message,
    this.onSuggestedReply,
    this.onChoiceSelected,
    this.onAction,
    this.actionsEnabled = true,
  });
  final MessageModel message;
  final ValueChanged<String>? onSuggestedReply;
  final Future<void> Function({
    required String topic,
    required String optionId,
    required String label,
  })? onChoiceSelected;
  final ValueChanged<MessagingAction>? onAction;
  final bool actionsEnabled;

  IconData get _icon => switch (message.type) {
        'availability_request' => Iconsax.calendar_1,
        'availability_answer' => Iconsax.calendar_tick,
        'stay_proposal' => Iconsax.receipt_item,
        'arrival_info' => Iconsax.key,
        'residence_card' => Iconsax.home_1,
        'reservation_card' => Iconsax.receipt_item,
        'choice_prompt' => Iconsax.message_question,
        _ => Iconsax.info_circle,
      };

  String get _title => switch (message.type) {
        'availability_request' => 'Demande de disponibilité',
        'availability_answer' => message.payload['available'] == true
            ? 'Dates disponibles'
            : 'Dates indisponibles',
        'stay_proposal' => message.payload['expired'] == true
            ? 'Proposition expirée'
            : 'Proposition de séjour',
        'arrival_info' => _payloadText('title') ?? 'Informations d’arrivée',
        'residence_card' => 'Résidence partagée',
        'reservation_card' => _payloadText('title') ?? 'Réservation',
        'choice_prompt' =>
          _payloadText('question') ?? 'Comment pouvons-nous vous aider ?',
        'choice_answer' => 'Réponse envoyée',
        'system_event' => 'Mise à jour',
        _ => 'Information',
      };

  String? _payloadText(String key) {
    final value = message.payload[key]?.toString().trim();
    return value == null || value.isEmpty || value == 'null' ? null : value;
  }

  List<MessagingAction> _serverActions({required bool isExpired}) {
    if (isExpired || !actionsEnabled) return const [];
    final receivedActions =
        message.actions.where(isMessagingActionVisible).toList(growable: false);
    if (receivedActions.isNotEmpty) return receivedActions;

    final rawCta = message.payload['cta'];
    if (rawCta is! Map) return const [];
    final cta = Map<String, dynamic>.from(rawCta);
    final actionId = cta['action']?.toString() ?? '';
    const allowedActions = {
      'view_residence',
      'view_reservation',
      'pick_dates',
      'book_now',
      'pay_reservation',
      'cancel_reservation',
      'open_checkin_qr',
      'rate_stay',
      'open_support',
    };
    if (!allowedActions.contains(actionId)) return const [];

    final target = <String, dynamic>{};
    final residenceId = _payloadText('residenceId');
    final reservationId = _payloadText('reservationId');
    if (residenceId != null) target['residenceId'] = residenceId;
    if (reservationId != null) target['reservationId'] = reservationId;
    return [
      MessagingAction(
        id: actionId,
        label: cta['label']?.toString() ?? 'Continuer',
        variant: cta['variant']?.toString() ?? 'secondary',
        target: target,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isTimeline =
        message.type == 'system' || message.type == 'system_event';
    final isExpiredProposal =
        message.type == 'stay_proposal' && message.payload['expired'] == true;
    final serverActions = _serverActions(isExpired: isExpiredProposal);
    final choiceTopic = message.payload['topic']?.toString() ??
        (message.type == 'choice_prompt' ? 'support' : null);
    final arrivalCta = message.payload['cta'];
    final canOpenArrivalInfo = actionsEnabled &&
        (message.actions.any((action) => action.id == 'open_arrival_info') ||
            (arrivalCta is Map &&
                arrivalCta['action']?.toString() == 'open_arrival_info'));
    final actions = message.type == 'arrival_info'
        ? serverActions
            .where((action) => action.id != 'open_arrival_info')
            .toList(growable: false)
        : serverActions;
    final cardHasStructuredContent = {
      'location_card',
      'residence_card',
      'availability_request',
      'availability_answer',
      'stay_proposal',
      'reservation_card',
      'choice_prompt',
      'choice_answer',
      'arrival_info',
    }.contains(message.type);
    final choiceOptions = message.payload['options'] is List
        ? (message.payload['options'] as List).whereType<Map>()
        : const <Map>[];
    if (isTimeline) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        child: Text(
          message.content,
          textAlign: TextAlign.center,
          style: AppTypography.font(
              fontSize: 12, color: AppColors.immoTextSecondary),
        ),
      );
    }
    return Opacity(
      opacity: isExpiredProposal ? 0.55 : 1,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 6, 16, 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.immoBgSurfaceMuted.withValues(alpha: 0.56),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryLite,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(_icon, size: 19, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(_title,
                      style: AppTypography.font(
                          fontSize: 14, fontWeight: FontWeight.w700))),
            ]),
            if (!cardHasStructuredContent && message.content.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(message.content,
                  style: AppTypography.font(fontSize: 13, height: 1.35)),
            ],
            _StructuredMessageDetails(
              message: message,
              canOpenArrivalInfo: canOpenArrivalInfo,
              arrivalInfoLabel:
                  arrivalCta is Map ? arrivalCta['label']?.toString() : null,
            ),
            if (actionsEnabled && message.suggestedReplies.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: message.suggestedReplies
                    .map((reply) => OutlinedButton(
                          onPressed: onSuggestedReply == null
                              ? null
                              : () => onSuggestedReply!(reply),
                          child: Text(reply),
                        ))
                    .toList(growable: false),
              ),
            ],
            if (message.type == 'choice_prompt' &&
                actionsEnabled &&
                choiceTopic != null &&
                choiceOptions.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...choiceOptions.map((rawOption) {
                final option = Map<String, dynamic>.from(rawOption);
                final optionId = option['id']?.toString();
                final label = option['label']?.toString() ?? '';
                if (optionId == null || label.isEmpty)
                  return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onChoiceSelected == null
                          ? null
                          : () => onChoiceSelected!(
                                topic: choiceTopic,
                                optionId: optionId,
                                label: label,
                              ),
                      icon: const Icon(Iconsax.message_question, size: 17),
                      label: Text(label),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                        alignment: Alignment.centerLeft,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...actions.map((action) => Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: SizedBox(
                      width: double.infinity,
                      child: MessagingActionButton(
                        action: action,
                        onPressed:
                            onAction == null ? null : () => onAction!(action),
                      ),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

class _StructuredMessageDetails extends StatelessWidget {
  const _StructuredMessageDetails({
    required this.message,
    this.canOpenArrivalInfo = false,
    this.arrivalInfoLabel,
  });

  final MessageModel message;
  final bool canOpenArrivalInfo;
  final String? arrivalInfoLabel;

  String? _value(String key) {
    final value = message.payload[key];
    final text = value?.toString().trim();
    return text == null || text.isEmpty || text == 'null' ? null : text;
  }

  @override
  Widget build(BuildContext context) {
    if (message.type == 'residence_card') {
      return _residencePreview();
    }

    if (message.type == 'choice_answer') {
      final answer = _value('content');
      if (answer == null) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          answer,
          style: AppTypography.font(fontSize: 13, height: 1.35),
        ),
      );
    }

    if (message.type == 'arrival_info') {
      if (!canOpenArrivalInfo) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _showArrivalInfo(context),
            icon: const Icon(Iconsax.key, size: 18),
            label: Text(arrivalInfoLabel?.isNotEmpty == true
                ? arrivalInfoLabel!
                : 'Voir les détails'),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      );
    }

    final rows = <(IconData, String)>[];
    final checkIn = _value('checkIn');
    final checkOut = _value('checkOut');
    final guests = _value('guests');
    final status = _value('status');
    final residenceName = _value('residenceName');
    final amount =
        message.payload['amount'] ?? message.payload['amountForViewer'];
    final expiresAt = _value('expiresAt');

    if (checkIn != null || checkOut != null) {
      rows.add((
        Iconsax.calendar_1,
        [checkIn, checkOut].whereType<String>().join(' → '),
      ));
    }
    if (guests != null) {
      rows.add((Iconsax.people, '$guests voyageur${guests == '1' ? '' : 's'}'));
    }
    if (status != null) {
      rows.add((
        Iconsax.info_circle,
        status.replaceAll('_', ' '),
      ));
    }
    if (residenceName != null && message.type == 'reservation_card') {
      rows.add((Iconsax.home_1, residenceName));
    }
    if (amount != null) {
      final amountValue =
          amount is Map ? amount['value']?.toString() : amount.toString();
      final currency = amount is Map
          ? amount['currency']?.toString() ?? 'XOF'
          : _value('currency') ?? 'XOF';
      if (amountValue != null && amountValue.isNotEmpty) {
        rows.add((Iconsax.wallet_3, '$amountValue $currency'));
      }
    }
    if (expiresAt != null) {
      rows.add((
        Iconsax.clock,
        message.payload['expired'] == true
            ? 'Cette proposition a expiré.'
            : 'Valable jusqu’au $expiresAt',
      ));
    }

    final alternatives =
        message.payload['suggestedWindows'] ?? message.payload['alternatives'];
    if (rows.isEmpty && alternatives is! List) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                children: [
                  Icon(row.$1, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      row.$2,
                      style: AppTypography.font(
                        fontSize: 12,
                        color: AppColors.immoTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (alternatives is List && alternatives.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              'Autres dates proposées',
              style: AppTypography.font(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: alternatives.whereType<Map>().map((window) {
                final start = window['checkIn']?.toString() ?? '';
                final end = window['checkOut']?.toString() ?? '';
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$start → $end',
                    style: AppTypography.font(fontSize: 11),
                  ),
                );
              }).toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }

  Widget _residencePreview() {
    final title = _value('title') ?? _value('residenceName') ?? 'Résidence';
    final subtitle = _value('subtitle');
    final priceText = _value('priceText');
    final imageUrl = _value('imageUrl');

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null &&
              (imageUrl.startsWith('https://') ||
                  imageUrl.startsWith('http://'))) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 144,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      const _ResidenceImagePlaceholder(),
                  placeholder: (context, url) =>
                      const _ResidenceImagePlaceholder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ] else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: const SizedBox(
                height: 112,
                width: double.infinity,
                child: _ResidenceImagePlaceholder(),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.font(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.font(
                fontSize: 12,
                color: AppColors.immoTextSecondary,
              ),
            ),
          ],
          if (priceText != null) ...[
            const SizedBox(height: 7),
            Text(
              priceText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.font(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showArrivalInfo(BuildContext context) {
    final addressLabel = _value('addressLabel');
    final instructions = _value('accessInstructions') ?? _value('instructions');
    final checkInWindow = _value('checkInWindow');
    final checkInTime = _value('checkInTime');
    final checkOutTime = _value('checkOutTime');
    final accessCodeHint = _value('accessCodeHint');
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Iconsax.key, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                'Informations d’arrivée',
                style: AppTypography.font(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (addressLabel != null)
              _ArrivalDetailRow(
                icon: Iconsax.location,
                label: 'Zone',
                value: addressLabel,
              ),
            if (instructions != null)
              _ArrivalDetailRow(
                icon: Iconsax.document_text,
                label: 'Instructions',
                value: instructions,
              ),
            if (checkInWindow != null ||
                checkInTime != null ||
                checkOutTime != null)
              _ArrivalDetailRow(
                icon: Iconsax.clock,
                label: 'Horaires',
                value: checkInWindow ??
                    [checkInTime, checkOutTime].whereType<String>().join(' – '),
              ),
            if (accessCodeHint != null)
              _ArrivalDetailRow(
                icon: Iconsax.password_check,
                label: 'Accès',
                value: accessCodeHint,
              ),
          ],
        ),
      ),
    );
  }
}

class _ArrivalDetailRow extends StatelessWidget {
  const _ArrivalDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.font(
                    fontSize: 11,
                    color: AppColors.immoTextSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: AppTypography.font(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResidenceImagePlaceholder extends StatelessWidget {
  const _ResidenceImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.immoBgSurfaceMuted,
      child: Center(
        child: Icon(
          Iconsax.home_1,
          size: 32,
          color: AppColors.immoTextSecondary,
        ),
      ),
    );
  }
}

class MessagingActionButton extends StatelessWidget {
  const MessagingActionButton({
    super.key,
    required this.action,
    this.compact = false,
    this.onPressed,
  });
  final MessagingAction action;
  final bool compact;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isDanger = action.variant == 'danger';
    final isPrimary = action.variant == 'primary';
    final color = isDanger ? AppColors.immoFeedbackError : AppColors.primary;
    final chipShape = const StadiumBorder();
    final child = isPrimary
        ? FilledButton(
            onPressed:
                onPressed ?? () => handleMessagingAction(context, action),
            style: FilledButton.styleFrom(
              backgroundColor: color,
              shape: chipShape,
              minimumSize: compact ? const Size(0, 32) : null,
              padding: compact
                  ? const EdgeInsets.symmetric(horizontal: 11)
                  : const EdgeInsets.symmetric(horizontal: 18),
            ),
            child: Text(
              action.label,
              style: AppTypography.font(
                fontSize: compact ? 11 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : OutlinedButton(
            onPressed:
                onPressed ?? () => handleMessagingAction(context, action),
            style: OutlinedButton.styleFrom(
              foregroundColor: color,
              side: BorderSide(color: color),
              shape: chipShape,
              minimumSize: compact ? const Size(0, 32) : null,
              padding: compact
                  ? const EdgeInsets.symmetric(horizontal: 11)
                  : const EdgeInsets.symmetric(horizontal: 18),
            ),
            child: Text(
              action.label,
              style: AppTypography.font(
                fontSize: compact ? 11 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
    if (!compact) return child;
    return SizedBox(height: 32, child: child);
  }
}

IconData messagingActionIcon(String actionId) => switch (actionId) {
      'view_residence' => Iconsax.home_1,
      'view_reservation' => Iconsax.receipt_item,
      'pick_dates' => Iconsax.calendar_1,
      'book_now' => Iconsax.calendar_tick,
      'pay_reservation' => Iconsax.card,
      'cancel_reservation' => Iconsax.calendar_remove,
      'open_checkin_qr' => Iconsax.scan_barcode,
      'rate_stay' => Iconsax.star,
      'open_support' => Iconsax.message_question,
      'share_residence_card' => Iconsax.home_1,
      'share_reservation_card' => Iconsax.receipt_item,
      _ => Iconsax.arrow_right_3,
    };

Future<void> handleMessagingAction(
  BuildContext context,
  MessagingAction action,
) async {
  final targetId = action.target['id']?.toString();
  final residenceId = action.target['residenceId']?.toString() ??
      (action.target['collection'] == 'residences' ? targetId : null);
  final reservationId = action.target['reservationId']?.toString() ??
      (action.target['collection'] == 'reservations' ? targetId : null);

  if (action.id == 'view_residence' && residenceId?.isNotEmpty == true) {
    context.push(ResidencePage.route(residenceId!));
    return;
  }
  if (action.id == 'view_reservation' && reservationId?.isNotEmpty == true) {
    context.push(BookingDetailPage.route(id: reservationId!));
    return;
  }
  if (action.id == 'book_now' && residenceId?.isNotEmpty == true) {
    context.push(ResidencePage.route(residenceId!));
    return;
  }
  if ({'open_checkin_qr', 'rate_stay'}.contains(action.id) &&
      reservationId?.isNotEmpty == true) {
    context.push(BookingDetailPage.route(
      id: reservationId!,
      action: action.id == 'rate_stay' ? 'rate' : null,
    ));
    return;
  }

  String? route;
  var title = action.label;
  var message =
      'Vérifiez les informations avant de continuer dans le parcours sécurisé.';
  var continueLabel = action.label;
  var icon = messagingActionIcon(action.id);

  if (action.id == 'pick_dates' && residenceId?.isNotEmpty == true) {
    route = ResidencePage.route(residenceId!);
    title = 'Choisir mes dates';
    message =
        'Sélectionnez vos dates et le nombre de voyageurs. La disponibilité sera vérifiée avant toute réservation.';
    continueLabel = action.label;
  } else if (action.id == 'pay_reservation' &&
      reservationId?.isNotEmpty == true) {
    route = PendingPaymentReservationsPage.route(
      reservationId: reservationId,
    );
    title = 'Confirmer avant le paiement';
    final amount = action.target['amount'];
    final currency = action.target['currency']?.toString() ?? 'XOF';
    message = amount == null
        ? 'Vous allez ouvrir le paiement sécurisé de cette réservation.'
        : 'Montant à régler : $amount $currency. Vous pourrez encore vérifier les informations avant de payer.';
    continueLabel = action.label;
  } else if (action.id == 'cancel_reservation' &&
      reservationId?.isNotEmpty == true) {
    route = BookingDetailPage.route(id: reservationId!);
    title = 'Consulter l’annulation';
    message =
        'Consultez les conditions et les conséquences avant de confirmer l’annulation.';
    continueLabel = action.label;
  }

  await showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    backgroundColor: AppColors.white,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryLite,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.font(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.font(
              fontSize: 13,
              color: AppColors.immoTextSecondary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: route == null
                  ? () => Navigator.pop(sheetContext)
                  : () {
                      Navigator.pop(sheetContext);
                      context.push(route!);
                    },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(route == null ? 'Compris' : continueLabel),
            ),
          ),
        ],
      ),
    ),
  );
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.message,
    required this.showReadMarker,
    this.onRetry,
    this.onDelete,
  });

  final MessageModel message;
  final bool showReadMarker;
  final VoidCallback? onRetry;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isClient = message.isFromClient;
    final timeLabel = formatBubbleTime(message.createdAt);

    if (isClient && message.deliveryState == MessageDeliveryState.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.close_circle,
              size: 14, color: AppColors.immoFeedbackError),
          SizedBox(width: 4),
          Text(
            'Échec',
            style: AppTypography.font(
                fontSize: 11, color: AppColors.immoFeedbackError),
          ),
          if (onRetry != null) ...[
            SizedBox(width: 8),
            GestureDetector(
              onTap: onRetry,
              child: Text('Réessayer',
                  style: AppTypography.font(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600)),
            ),
          ],
          if (onDelete != null) ...[
            SizedBox(width: 8),
            GestureDetector(
              onTap: onDelete,
              child: Text('Supprimer',
                  style: AppTypography.font(
                      fontSize: 11, color: AppColors.immoTextSecondary)),
            ),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(timeLabel,
            style: AppTypography.font(
                fontSize: 11, color: AppColors.immoTextSecondary)),
        if (isClient) ...[
          SizedBox(width: 4),
          if (message.deliveryState == MessageDeliveryState.sending)
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppColors.immoTextDisabled,
              ),
            )
          else
            Icon(Iconsax.tick_circle,
                size: 13, color: AppColors.immoTextDisabled),
        ],
        if (isClient && showReadMarker) ...[
          SizedBox(width: 6),
          Text('Lu',
              style: AppTypography.font(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600)),
        ],
      ],
    );
  }
}

/// Séparateur de jour centré dans la liste de messages.
class DaySeparator extends StatelessWidget {
  const DaySeparator({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.immoBgSurfaceMuted,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: AppTypography.font(
                fontSize: 12,
                color: AppColors.immoTextSecondary,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
