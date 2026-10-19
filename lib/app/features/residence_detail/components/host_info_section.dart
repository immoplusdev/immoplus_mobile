import 'package:flutter/material.dart';
import '../../../core/network/utils/constants.dart';
import '../../../core/network/utils/session_manager.dart';
import '../../../core/config/injection.dart';
import '../../../data/models/remote/residence/residence_model.dart';
import '../../messaging/widgets/message_composer_sheet.dart';
import '../../messaging/widgets/host_contact_prompt.dart';

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
    if (sessionManager.currentUser == null)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: HostContactPrompt(
        padding: const EdgeInsets.fromLTRB(appPadding, 8, appPadding, 20),
        label: 'Envoyer un message à l’hôte',
        onPressed: () => MessageComposerSheet.showForResidence(
          context,
          residenceModel: residenceModel,
        ),
      ),
    );
  }
}
