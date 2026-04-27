import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';

class AlertSuccessPage extends StatelessWidget {
  const AlertSuccessPage({super.key});
  static const String name = 'ALERT_SUCCESS_PAGE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildSuccessIcon(),
              const Gap(40),
              Text(
                'Votre demande a été envoyée avec succès',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const Gap(16),
              Text(
                'Nous vous proposerons des biens correspondant à vos critères dans les plus brefs délais.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              _buildHomeButton(context),
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
            color: Colors.green.shade100.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
        Icon(
          Icons.verified,
          size: 140,
          color: Colors.green.shade400,
        ),
      ],
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return CustomLoadingButtom(
      text: 'Retourner à l\'accueil',
      isLoading: false,
      onClick: () => context.go('/'),
    );
  }
}
