import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/lottie_assets.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:intl/intl.dart';

class StripeResultPage extends StatelessWidget {
  const StripeResultPage({
    super.key,
    required this.paymentIntentData,
  });

  final PaymentItentData paymentIntentData;

  @override
  Widget build(BuildContext context) {
    final paymentData = PaymentData.of(context);
    final amount = paymentIntentData.amount > 0
        ? paymentIntentData.amount
        : (paymentData?.amount ?? 0);
    final date = paymentIntentData.createdAt ?? DateTime.now();
    final txId =
        paymentIntentData.stripePaymentIntentId ?? paymentIntentData.id;
    final shortTx =
        txId.length > 16 ? '…${txId.substring(txId.length - 16)}' : txId;

    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final lottieH = (h * 0.14).clamp(60.0, 120.0);
        final vGap = h < 500 ? 8.0 : 14.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: h - 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Animation + titre ──
                SizedBox(height: lottieH, child: LottieAssets().success),
                Gap(vGap * 0.3),
                Text(
                  'Paiement confirmé',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1CA53F),
                      ),
                ),
                Gap(vGap * 0.2),
                Text(
                  'Transaction traitée avec succès',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
                Gap(vGap),

                // ── Carte reçu ──
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Montant
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF1CA53F).withValues(alpha: 0.08),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Montant payé',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                            const Gap(2),
                            Text(
                              Utils.formatCurrency(amount),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1CA53F),
                                  ),
                            ),
                          ],
                        ),
                      ),

                      _DashedDivider(),

                      // Lignes reçu
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                        child: Column(
                          children: [
                            _ReceiptRow(
                              icon: Iconsax.card,
                              label: 'Moyen de paiement',
                              value: 'Carte · Stripe',
                              iconColor: const Color(0xFF635BFF),
                            ),
                            const Gap(8),
                            _ReceiptRow(
                              icon: Iconsax.calendar,
                              label: 'Date',
                              value: DateFormat("dd MMM yyyy · HH'h'mm")
                                  .format(date),
                              iconColor: AppColors.primary,
                            ),
                            if (shortTx.isNotEmpty) ...[
                              const Gap(8),
                              _ReceiptRow(
                                icon: Iconsax.tag,
                                label: 'Référence',
                                value: shortTx,
                                iconColor: Colors.grey,
                                valueMono: true,
                              ),
                            ],
                            const Gap(8),
                            _ReceiptRow(
                              icon: Iconsax.tick_circle,
                              label: 'Statut',
                              value: 'Approuvé',
                              iconColor: const Color(0xFF1CA53F),
                              valueColor: const Color(0xFF1CA53F),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(vGap),

                // ── Boutons ──
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => context.go('/booking-history'),
                    icon: const Icon(Iconsax.receipt_item, size: 16),
                    label: const Text('Voir mes réservations'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                ),
                Gap(vGap * 0.6),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(Iconsax.home, size: 16),
                    label: const Text('Retour à l\'accueil'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.valueColor,
    this.valueMono = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color? valueColor;
  final bool valueMono;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, size: 13, color: iconColor),
        ),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                      fontSize: 10,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? Colors.black87,
                      fontFamily: valueMono ? 'monospace' : null,
                      fontSize: valueMono ? 11 : 13,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _notch(left: true),
        Expanded(
          child: LayoutBuilder(
            builder: (_, constraints) {
              final count = (constraints.maxWidth / 10).floor();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  count,
                  (_) => Container(
                    width: 5,
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                ),
              );
            },
          ),
        ),
        _notch(left: false),
      ],
    );
  }

  Widget _notch({required bool left}) {
    return Transform.translate(
      offset: Offset(left ? -7 : 7, 0),
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: AppColors.scafold,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
