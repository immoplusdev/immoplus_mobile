import 'package:flutter/material.dart';

/// `InterestStatus` — voir CLIENT-IMMO-RELAIS-API.md § Énumérations. La
/// réponse occupant (`PATCH /relais/:id/interests/:interestId`) n'accepte
/// que `inProgress`/`declined` en entrée ; `accepted`/`completed` sont
/// posés ailleurs dans le flux (visite, finalisation).
enum RelaisInterestStatus {
  pending('pending', 'En attente', Color(0xFFFFF7E6), Color(0xFFB45309)),
  inProgress('in_progress', 'Visite planifiée', Color(0xFFEFF6FF), Color(0xFF2548E5)),
  accepted('accepted', 'Accepté', Color(0xFFEFFCF3), Color(0xFF1CA53F)),
  declined('declined', 'Décliné', Color(0xFFFEF2F2), Color(0xFFDC2626)),
  completed('completed', 'Terminé', Color(0xFFF3F4F6), Color(0xFF6B7280));

  final String value;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const RelaisInterestStatus(this.value, this.label, this.backgroundColor, this.textColor);

  static RelaisInterestStatus fromString(String? value) {
    return RelaisInterestStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RelaisInterestStatus.pending,
    );
  }
}
