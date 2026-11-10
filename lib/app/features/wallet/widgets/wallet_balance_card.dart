import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/wallet/data/wallet_models.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_formatters.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_style.dart';

/// Crédit du coffre : montant disponible et accès à la demande de
/// remboursement.
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
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [WalletColors.brand, WalletColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crédit disponible',
            style: AppTypography.font(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            formatAmount(wallet.availableBalance, currency: wallet.currency),
            style: AppTypography.font(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Crédit utilisable pour vos prochaines réservations',
            style: AppTypography.font(fontSize: 12, color: Colors.white),
          ),
          if (wallet.pendingBalance > 0) ...[
            const SizedBox(height: 4),
            Text(
              '${formatAmount(wallet.pendingBalance, currency: wallet.currency)} en cours de libération',
              style: AppTypography.font(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: wallet.canWithdraw ? onWithdraw : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: WalletColors.brand,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.3),
                disabledForegroundColor: Colors.white70,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Demander un remboursement',
                style: AppTypography.font(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
