import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/wallet/data/wallet_models.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_formatters.dart';

/// Solde du coffre : montant disponible, montant en cours de libération et
/// accès au retrait.
class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    super.key,
    required this.wallet,
    required this.onWithdraw,
  });

  final WalletModel wallet;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.wallet_3, size: 18, color: AppColors.white),
              const SizedBox(width: 8),
              Text(
                'Solde disponible',
                style: AppTypography.font(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            formatAmount(wallet.availableBalance, currency: wallet.currency),
            style: AppTypography.font(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          if (wallet.pendingBalance > 0) ...[
            const SizedBox(height: 6),
            Text(
              '${formatAmount(wallet.pendingBalance, currency: wallet.currency)} en cours de libération',
              style: AppTypography.font(
                fontSize: 12,
                color: AppColors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: wallet.canWithdraw ? onWithdraw : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.white.withValues(alpha: 0.4),
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Retirer mon solde',
                style: AppTypography.font(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color:
                      wallet.canWithdraw ? AppColors.primary : AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
