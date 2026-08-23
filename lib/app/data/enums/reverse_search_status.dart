/// Miroir de `ReverseSearchStatus` côté backend
/// (api-immoplus-v2/src/core/domain/reverse-searches/reverse-search-status.enum.ts).
enum ReverseSearchStatus {
  enRecherche("en_recherche"),
  selectionEnAttentePaiement("selection_en_attente_paiement"),
  confirmee("confirmee"),
  expiree("expiree"),
  annuleeParClient("annulee_par_client"),
  unknown("unknown");

  final String value;

  const ReverseSearchStatus(this.value);

  static ReverseSearchStatus fromString(String? status) {
    if (status == null) return ReverseSearchStatus.unknown;
    switch (status.toLowerCase().trim()) {
      case 'en_recherche':
        return ReverseSearchStatus.enRecherche;
      case 'selection_en_attente_paiement':
        return ReverseSearchStatus.selectionEnAttentePaiement;
      case 'confirmee':
        return ReverseSearchStatus.confirmee;
      case 'expiree':
        return ReverseSearchStatus.expiree;
      case 'annulee_par_client':
        return ReverseSearchStatus.annuleeParClient;
      default:
        return ReverseSearchStatus.unknown;
    }
  }

  bool get isEnRecherche => this == ReverseSearchStatus.enRecherche;
  bool get isSelectionEnAttentePaiement =>
      this == ReverseSearchStatus.selectionEnAttentePaiement;

  /// Recherche encore "vivante" côté client : soit en cours de recherche,
  /// soit en attente de paiement suite à une sélection.
  bool get isActive => isEnRecherche || isSelectionEnAttentePaiement;

  bool get isAnnulee => this == ReverseSearchStatus.annuleeParClient;
}
