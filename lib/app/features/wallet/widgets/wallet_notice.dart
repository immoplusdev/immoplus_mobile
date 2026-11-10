import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_style.dart';

/// Encadré d'information discret (icône « ! » + texte) de l'espace coffre.
class WalletNotice extends StatelessWidget {
  const WalletNotice(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: WalletColors.noticeBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: WalletColors.noticeIconBackground,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '!',
              style: AppTypography.font(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: WalletColors.brand,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTypography.font(
                fontSize: 12,
                height: 1.25,
                color: WalletColors.brand,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
