import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/utils/app_colors.dart';

/// Carte d'intro + bandeau d'avertissement, identiques sur les 2 écrans du
/// flux "Publiez votre ancien logement" (flux B, signalement anonyme).
class RelaisIntroHeader extends StatelessWidget {
  const RelaisIntroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryLite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Iconsax.home_2, color: AppColors.primary, size: 30),
              ),
              const Gap(16),
              Text(
                'Publiez votre ancien logement',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Gap(8),
              Text(
                'Votre bien sera visible immediatement aupres des personnes qui recherchent un logement dans votre quartier.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const Gap(16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.shade100),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Iconsax.warning_2, color: Colors.orange.shade700, size: 20),
              const Gap(10),
              Expanded(
                child: Text(
                  "Ce logement ne vous appartient pas. Précisez votre lien avec le bien pour orienter les personnes intéressées.",
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: Colors.orange.shade900,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
