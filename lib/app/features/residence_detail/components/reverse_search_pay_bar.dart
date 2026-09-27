import 'package:flutter/material.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';

/// Barre "prix + Payer" pour une résidence issue d'une recherche inversée —
class ReverseSearchPayBar extends StatelessWidget {
  /// Prix total à payer pour tout le séjour.
  final double price;

  /// Nombre de nuits, toujours >= 1 — filet de secours si [perNightPrice] n'est pas fourni.
  final int nights;

  /// Prix par nuit explicite (figé côté backend), prioritaire sur le calcul.
  final int? perNightPrice;
  final bool isLoading;
  final VoidCallback onTap;

  const ReverseSearchPayBar({
    super.key,
    required this.price,
    required this.nights,
    this.perNightPrice,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalRounded = price.round();
    final perNight = perNightPrice ?? (totalRounded / nights).round();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.immoBgSurfaceMuted, width: 1),
        ),
      ),
      padding: EdgeInsets.only(
        left: appPadding,
        right: appPadding,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: CurrencyFormatter().format(perNight.toString()),
                        style: AppTypography.font(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF222222),
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: ' F / nuit',
                        style: AppTypography.font(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Total séjour ($nights nuit${nights > 1 ? 's' : ''}) : '
                  '${CurrencyFormatter().format(totalRounded.toString())} F',
                  style: AppTypography.font(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.immoTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
                textStyle: AppTypography.font(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text('Payer'),
            ),
          ),
        ],
      ),
    );
  }
}
