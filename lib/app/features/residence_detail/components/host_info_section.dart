import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/network/utils/constants.dart';
import '../../../core/network/utils/session_manager.dart';
import '../../../core/config/injection.dart';
import '../../../data/models/remote/residence/residence_model.dart';
import '../../../utils/app_colors.dart';
import '../../messaging/widgets/message_composer_sheet.dart';

/// Bloc "À propos de votre hôte" (spec messagerie §2.1).
///
/// Générique par nécessité : `ResidenceModel` n'expose aucun champ
/// propriétaire (ni id, ni nom, ni photo — le champ est commenté dans le
/// modèle), donc pas de vraie identité disponible avant le premier contact
/// (le `proId` n'arrive qu'à la création du fil, via `POST /conversations`).
class HostInfoSection extends StatelessWidget {
  const HostInfoSection({super.key, required this.residenceModel});

  final ResidenceModel residenceModel;

  @override
  Widget build(BuildContext context) {
    final sessionManager = getIt<SessionManager>();
    if (sessionManager.currentUser == null) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: appPadding),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryLite,
                child: Icon(Icons.verified_user_outlined, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Propriétaire vérifié',
                      style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Hébergé par un professionnel ImmoPlus',
                      style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () =>
                    MessageComposerSheet.showForResidence(context, residenceModel: residenceModel),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text('Contacter',
                    style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
