import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:immoplus/app/features/suggest/widgets/selection_countdown.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/unified_property_card.dart';

/// Carte "Libre tout de suite" épinglée pour la résidence sélectionnée en
/// attente de paiement (statut reverse-search `selection_en_attente_paiement`).
/// Superpose à [UnifiedPropertyCard] : un badge de compte à rebours cropé sur
/// le coin haut-gauche (via [SelectionCountdown], aligné sur l'event socket
/// `reverse_search:selection_expiree` qui relâche le verrou côté serveur) et
/// un bouton "Payer" en bas à gauche.
class PendingSelectionCard extends StatelessWidget {
  final ReverseSearchProposition proposition;
  final DateTime? selectionExpireAt;
  final VoidCallback onContinuePayment;

  /// Appelé une fois quand le compte à rebours atteint zéro côté client —
  /// filet de sécurité pour revérifier l'état réel auprès du serveur si
  /// l'event socket `selection_expiree` n'arrive jamais.
  final VoidCallback? onExpired;

  const PendingSelectionCard({
    super.key,
    required this.proposition,
    required this.selectionExpireAt,
    required this.onContinuePayment,
    this.onExpired,
  });

  @override
  Widget build(BuildContext context) {
    final expireAt = selectionExpireAt;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          UnifiedPropertyCard(
            item: proposition.data,
            badge: const _ConfirmAPayerBadge(),
          ),

          // Compte à rebours, cropé dans le coin haut-gauche de la carte.
          if (expireAt != null)
            Positioned(
              top: 0,
              left: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(12),
                ),
                child: Container(
                  color: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: SelectionCountdown(
                    expireAt: expireAt,
                    onExpired: onExpired,
                    builder: (context, remaining, expired) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Iconsax.location,
                            size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          expired ? 'Expiré' : formatCountdown(remaining),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Bouton "Payer", en bas à gauche de la carte — plat, format
          // compact pour rester bien contenu dans la carte.
          Positioned(
            left: 12,
            bottom: 12,
            child: ElevatedButton(
              onPressed: onContinuePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green1CA53F,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: const StadiumBorder(),
                elevation: 0,
                shadowColor: Colors.transparent,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Payer',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmAPayerBadge extends StatelessWidget {
  const _ConfirmAPayerBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.green1CA53F,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Confirmer à payer',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
