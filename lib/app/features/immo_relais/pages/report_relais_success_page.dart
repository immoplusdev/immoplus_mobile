import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';

/// Écran 4/4 du flux B : confirmation, puis retour à l'accueil.
class ReportRelaisSuccessPage extends StatelessWidget {
  const ReportRelaisSuccessPage({super.key});
  static const String name = 'REPORT_RELAIS_SUCCESS_PAGE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildSuccessIcon(),
              const Gap(32),
              Text(
                'Votre demande est en ligne',
                textAlign: TextAlign.center,
                style: AppTypography.font(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  height: 1.2,
                ),
              ),
              const Gap(12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Publication active',
                  style: AppTypography.font(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Gap(16),
              Text(
                'Nous vous proposerons des biens correspondant à vos critères dans les plus brefs délais.',
                textAlign: TextAlign.center,
                style: AppTypography.font(
                  fontSize: 14,
                  color: AppColors.immoTextSecondary,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              CustomLoadingButtom(
                text: "Retourner à l'accueil",
                isLoading: false,
                onClick: () => context.go('/homePage'),
              ),
              const Gap(40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.green50.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
        Icon(
          Icons.verified,
          size: 140,
          color: AppColors.green500,
        ),
      ],
    );
  }
}
