import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_interest_requests.dart';
import 'package:immoplus/app/data/repositories/relais_repository.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';

/// Bottom sheet "exprimer un intérêt" (`POST /relais/:id/interests`) —
/// partagé entre `PropositionCard` (matches d'une alerte) et le
/// Marketplace ("Autour de moi" dans "Je déménage").
Future<void> showExpressRelaisInterestSheet(
  BuildContext context, {
  required String relaisId,
  VoidCallback? onSuccess,
}) {
  final messageController = TextEditingController();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exprimer votre intérêt',
            style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Gap(4),
          Text(
            "L'occupant sera notifié et pourra vous proposer une visite.",
            style: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade600),
          ),
          const Gap(16),
          TextField(
            controller: messageController,
            maxLines: 3,
            maxLength: 2000,
            decoration: InputDecoration(
              hintText: 'Un message pour l\'occupant (optionnel)',
              hintStyle: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          const Gap(8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(sheetContext).pop();
                await _expressInterest(context, relaisId, messageController.text.trim(), onSuccess);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                'Envoyer',
                style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _expressInterest(
  BuildContext context,
  String relaisId,
  String message,
  VoidCallback? onSuccess,
) async {
  try {
    await getIt<RelaisRepository>().expressInterest(
      relaisId,
      RelaisExpressInterestRequest(message: message.isEmpty ? null : message),
    );
    CustomPopup.toast(text: 'Votre intérêt a été envoyé');
    onSuccess?.call();
  } catch (_) {
    CustomPopup.showErrorToast(text: "Impossible d'envoyer votre intérêt");
  }
}
