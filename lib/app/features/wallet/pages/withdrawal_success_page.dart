import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/wallet/data/wallet_models.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_formatters.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_notice.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_style.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

/// Données affichées sur la page de succès d'une demande de remboursement.
class WithdrawalSummary {
  const WithdrawalSummary({
    required this.request,
    required this.operatorName,
    required this.phoneNumber,
  });

  final WithdrawalRequestModel request;
  final String operatorName;
  final String phoneNumber;
}

/// Confirmation d'une demande de remboursement enregistrée.
class WithdrawalSuccessPage extends StatelessWidget {
  const WithdrawalSuccessPage({super.key, required this.summary});

  final WithdrawalSummary summary;

  static const String name = 'WITHDRAWAL_SUCCESS_PAGE';
  static String routePath() => '/wallet/withdrawal/success';

  String get _statusLabel => switch (summary.request.status) {
        WithdrawalStatus.pending ||
        WithdrawalStatus.unknown =>
          'En attente de validation',
        final status => status.label,
      };

  @override
  Widget build(BuildContext context) {
    final request = summary.request;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('MON COFFRE'),
        titleTextStyle: AppTypography.font(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: WalletColors.textSecondary,
        ),
        leading: BackButton(
          color: AppColors.black,
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: WalletColors.border),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: AppColors.immoFeedbackSuccess
                            .withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 48,
                        color: AppColors.immoFeedbackSuccess,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Demande envoyée',
                      textAlign: TextAlign.center,
                      style: AppTypography.font(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: WalletColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Votre demande de remboursement a bien été enregistrée.',
                      textAlign: TextAlign.center,
                      style: AppTypography.font(
                        fontSize: 13,
                        color: WalletColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: WalletColors.amberBackground,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _statusLabel,
                            style: AppTypography.font(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: WalletColors.amberText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${formatAmount(request.amount, currency: request.currency)} '
                            'vers ${summary.operatorName} au ${summary.phoneNumber}.',
                            style: AppTypography.font(
                              fontSize: 11,
                              height: 1.3,
                              color: WalletColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    CustomButtom(
                      text: 'Retourner à mon coffre',
                      buttonHeight: 48,
                      fontSize: 14,
                      borderRadius: BorderRadius.circular(24),
                      onClick: () => context.pop(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const WalletNotice(
                'La demande est visible dans votre coffre. Vous recevrez une '
                'mise à jour lorsque son statut évoluera.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
