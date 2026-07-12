import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../models/chat_alert_payload.dart';
import '../models/chat_message.dart';
import 'chat_tokens.dart';

class IntentResponseCard extends StatelessWidget {
  const IntentResponseCard({
    super.key,
    required this.message,
    this.onPaymentTap,
  });

  final ChatMessage message;
  final void Function(String url)? onPaymentTap;

  @override
  Widget build(BuildContext context) {
    return switch (message.responseType) {
      AlertResponseType.alertConfirmation => _AlertConfirmationCard(
          payload: ChatAlertPayload.fromData(message.data),
          meta: message.meta,
        ),
      AlertResponseType.visitCreated => _InfoCard(
          icon: Iconsax.calendar_add,
          title: 'Visite créée',
          rows: _visitRows(message.data),
        ),
      AlertResponseType.bookingCreated => _InfoCard(
          icon: Iconsax.calendar_1,
          title: 'Réservation créée',
          rows: _bookingRows(message.data),
        ),
      AlertResponseType.bookingStatus => _InfoCard(
          icon: Iconsax.info_circle,
          title: 'Statut de réservation',
          rows: _bookingStatusRows(message.data),
        ),
      AlertResponseType.bookingCancelled => _InfoCard(
          icon: Iconsax.close_circle,
          title: 'Réservation annulée',
          rows: _bookingCancelledRows(message.data),
          accentColor: ChatTokens.danger500,
        ),
      AlertResponseType.paymentCreated => _PaymentCard(
          data: message.data,
          onPaymentTap: onPaymentTap,
        ),
      _ => const SizedBox.shrink(),
    };
  }

  static List<_InfoRow> _visitRows(Map<String, dynamic>? data) {
    return [
      if (_string(data?['id']) != null)
        _InfoRow('Référence', _string(data?['id'])!),
      if (_string(data?['type']) != null)
        _InfoRow('Type', _string(data?['type'])!),
    ];
  }

  static List<_InfoRow> _bookingRows(Map<String, dynamic>? data) {
    return [
      if (_string(data?['code']) != null)
        _InfoRow('Référence', _string(data?['code'])!),
      if (_string(data?['statut']) != null)
        _InfoRow('Statut', _bookingStatusLabel(_string(data?['statut'])!)),
    ];
  }

  static List<_InfoRow> _bookingStatusRows(Map<String, dynamic>? data) {
    return [
      if (_string(data?['code']) != null)
        _InfoRow('Référence', _string(data?['code'])!),
      if (_string(data?['statut']) != null)
        _InfoRow('Statut', _bookingStatusLabel(_string(data?['statut'])!)),
    ];
  }

  static List<_InfoRow> _bookingCancelledRows(Map<String, dynamic>? data) {
    return [
      if (_string(data?['code']) != null)
        _InfoRow('Référence', _string(data?['code'])!),
    ];
  }

  static String _bookingStatusLabel(String raw) {
    switch (raw.toLowerCase()) {
      case 'en_attente_reponse_proprietaire':
        return 'En attente du proprietaire';
      case 'en_attente_paiement_client':
        return 'Paiement a finaliser';
      case 'valide':
        return 'Validee';
      case 'paye':
        return 'Payee';
      case 'en_cours':
        return 'En cours';
      case 'termine':
      case 'terminee':
        return 'Terminee';
      case 'annule':
        return 'Annulee';
      case 'rejete':
        return 'Rejetee';
      case 'proprietaire_annule_reservation':
        return 'Annulee par le proprietaire';
      case 'client_annule_reservation':
        return 'Annulee par le client';
      default:
        return raw.replaceAll('_', ' ');
    }
  }

  static String? _string(dynamic value) {
    if (value == null) return null;
    final stringValue = value.toString().trim();
    return stringValue.isEmpty ? null : stringValue;
  }
}

class _AlertConfirmationCard extends StatelessWidget {
  const _AlertConfirmationCard({
    required this.payload,
    required this.meta,
  });

  final ChatAlertPayload payload;
  final Map<String, dynamic>? meta;

  @override
  Widget build(BuildContext context) {
    final chips = payload.criteriaChips;
    final count = meta?['count'];
    final countLabel =
        count is num && count > 0 ? '${count.round()} biens' : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ChatTokens.neutral0,
        borderRadius: BorderRadius.circular(ChatTokens.cardRadius),
        border: Border.all(color: ChatTokens.borderStandard, width: 0.5),
        boxShadow: ChatTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Icon(Iconsax.notification_bing,
                  size: 16, color: ChatTokens.brand500),
              SizedBox(width: 8),
              Text(
                'Alerte prête',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ChatTokens.neutral900,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
          if (chips.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: chips.map((chip) => _Tag(label: chip)).toList(),
            ),
          ],
          if (payload.missingFieldLabels.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Tu peux encore preciser: ${payload.missingFieldLabels.join(', ')}',
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: ChatTokens.neutral400,
              ),
            ),
          ],
          if (countLabel != null || payload.fromCache == true) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (countLabel != null) _SoftBadge(label: countLabel),
                if (payload.fromCache == true) const _SoftBadge(label: 'Cache'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.data,
    this.onPaymentTap,
  });

  final Map<String, dynamic>? data;
  final void Function(String url)? onPaymentTap;

  @override
  Widget build(BuildContext context) {
    final amount = data?['amount'];
    final currency = _string(data?['currency']) ?? 'XOF';
    final paymentUrl = _string(data?['paymentUrl']);
    final status = _string(data?['statut']);

    return _InfoCard(
      icon: Iconsax.wallet_1,
      title: 'Paiement initie',
      rows: [
        if (amount is num)
          _InfoRow('Montant', '${formatPriceLong(amount)} $currency'),
        if (status != null) _InfoRow('Statut', status),
      ],
      footer: paymentUrl == null || onPaymentTap == null
          ? null
          : _InlinePrimaryButton(
              label: 'Payer maintenant',
              onTap: () => onPaymentTap!(paymentUrl),
            ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.rows,
    this.footer,
    this.accentColor = ChatTokens.brand500,
  });

  final IconData icon;
  final String title;
  final List<_InfoRow> rows;
  final Widget? footer;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty && footer == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ChatTokens.neutral0,
        borderRadius: BorderRadius.circular(ChatTokens.cardRadius),
        border: Border.all(color: ChatTokens.borderStandard, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ChatTokens.neutral900,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
          if (rows.isNotEmpty) ...[
            const SizedBox(height: 12),
            for (var index = 0; index < rows.length; index++) ...[
              if (index > 0) const SizedBox(height: 8),
              _LabeledValue(row: rows[index]),
            ],
          ],
          if (footer != null) ...[
            const SizedBox(height: 12),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.row});

  final _InfoRow row;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: Text(
            row.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ChatTokens.neutral400,
            ),
          ),
        ),
        Expanded(
          child: Text(
            row.value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ChatTokens.neutral900,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _InlinePrimaryButton extends StatelessWidget {
  const _InlinePrimaryButton({
    required this.label,
    required this.onTap,
  });

  final String label;
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
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: ChatTokens.brand500,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ChatTokens.neutral0,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ChatTokens.brandSurface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: ChatTokens.brand500,
        ),
      ),
    );
  }
}

class _SoftBadge extends StatelessWidget {
  const _SoftBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ChatTokens.neutral100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: ChatTokens.neutral400,
        ),
      ),
    );
  }
}

class _InfoRow {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;
}

String? _string(dynamic value) {
  if (value == null) return null;
  final stringValue = value.toString().trim();
  return stringValue.isEmpty ? null : stringValue;
}
