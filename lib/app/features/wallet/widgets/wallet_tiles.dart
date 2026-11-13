import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/wallet/data/wallet_models.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_formatters.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_style.dart';

BoxDecoration _cardDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: WalletColors.border),
    );

/// Un mouvement du coffre, en carte.
class WalletTransactionTile extends StatelessWidget {
  const WalletTransactionTile({super.key, required this.transaction});

  final WalletTransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final incoming = transaction.type.isIncoming;
    final color = incoming ? WalletColors.positive : WalletColors.textPrimary;
    final note = transaction.note?.trim() ?? '';
    final date = formatMovementDate(transaction.createdAt);
    final subtitle =
        [if (note.isNotEmpty) note, if (date.isNotEmpty) date].join(' · ');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: incoming ? WalletColors.positiveSoft : WalletColors.border,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              incoming ? Icons.check : Icons.arrow_upward_rounded,
              size: 15,
              color: color,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.type.label,
                  style: AppTypography.font(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: WalletColors.textPrimary,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.font(
                      fontSize: 11,
                      color: WalletColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${incoming ? '+' : '-'}${formatAmountCompact(transaction.amount, currency: transaction.currency)}',
            style: AppTypography.font(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Une demande de retrait, en carte.
class WithdrawalRequestTile extends StatelessWidget {
  const WithdrawalRequestTile({super.key, required this.request});

  final WithdrawalRequestModel request;

  Color get _statusColor => switch (request.status) {
        WithdrawalStatus.completed ||
        WithdrawalStatus.approved =>
          AppColors.immoFeedbackSuccess,
        WithdrawalStatus.rejected ||
        WithdrawalStatus.failed =>
          AppColors.immoFeedbackError,
        _ => AppColors.amber800,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatAmount(request.amount, currency: request.currency),
                  style: AppTypography.font(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: WalletColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatMovementDate(request.createdAt),
                  style: AppTypography.font(
                      fontSize: 11, color: WalletColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              request.status.label,
              style: AppTypography.font(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
