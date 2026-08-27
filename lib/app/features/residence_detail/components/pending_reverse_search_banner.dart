import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/features/suggest/widgets/selection_countdown.dart';

/// Bandeau affiché au-dessus de la barre de réservation d'une résidence
/// quand le client a déjà une résidence sélectionnée en attente de paiement
/// (recherche inversée verrouillée, ici ou ailleurs). Tap sur le bandeau =
/// raccourci direct vers le paiement ([onTap]) ; le bouton "Annuler" garde sa
/// propre zone de tap et n'active pas [onTap].
class PendingReverseSearchBanner extends StatelessWidget {
  final DateTime? selectionExpireAt;
  final VoidCallback onTap;
  final VoidCallback onCancel;

  /// Appelé une fois quand le compte à rebours atteint zéro côté client —
  /// filet de sécurité pour revérifier l'état réel auprès du serveur si
  /// l'event socket `selection_expiree` n'arrive jamais.
  final VoidCallback? onExpired;

  const PendingReverseSearchBanner({
    super.key,
    required this.selectionExpireAt,
    required this.onTap,
    required this.onCancel,
    this.onExpired,
  });

  static const _amber = Color(0xFFB54708);
  static const _amberBg = Color(0xFFFFFAEB);
  static const _amberBorder = Color(0xFFFEC84B);

  @override
  Widget build(BuildContext context) {
    final expireAt = selectionExpireAt;

    return Material(
      color: _amberBg,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: _amberBorder, width: 1)),
          ),
          child: Row(
            children: [
              const Icon(Iconsax.wallet_2, color: _amber, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Résidence sélectionnée · en attente de paiement',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _amber,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (expireAt != null)
                      SelectionCountdown(
                        expireAt: expireAt,
                        onExpired: onExpired,
                        builder: (context, remaining, expired) => Text(
                          expired
                              ? 'Expiré'
                              : 'Expire dans ${formatCountdown(remaining)} · touchez pour payer',
                          style: const TextStyle(fontSize: 11, color: _amber),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onCancel,
                style: TextButton.styleFrom(
                  foregroundColor: _amber,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Annuler',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
