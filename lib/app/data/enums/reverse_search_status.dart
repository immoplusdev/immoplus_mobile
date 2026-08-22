enum ReverseSearchStatus {
  enRecherche("en_recherche"),
  annuleeParClient("annulee_par_client"),
  annulee("annulee"),
  expiree("expiree"),
  selectionExpiree("selection_expiree"),
  selectionnee("selectionnee"),
  terminee("terminee"),
  unknown("unknown");

  final String value;

  const ReverseSearchStatus(this.value);

  static ReverseSearchStatus fromString(String? status) {
    if (status == null) return ReverseSearchStatus.unknown;
    switch (status.toLowerCase().trim()) {
      case 'en_recherche':
      case 'en_attente':
      case 'active':
      case 'pending':
      case 'searching':
      case 'created':
        return ReverseSearchStatus.enRecherche;
      case 'annulee_par_client':
        return ReverseSearchStatus.annuleeParClient;
      case 'annulee':
        return ReverseSearchStatus.annulee;
      case 'expiree':
        return ReverseSearchStatus.expiree;
      case 'selection_expiree':
        return ReverseSearchStatus.selectionExpiree;
      case 'selectionnee':
        return ReverseSearchStatus.selectionnee;
      case 'terminee':
      case 'payee':
        return ReverseSearchStatus.terminee;
      default:
        return ReverseSearchStatus.unknown;
    }
  }

  bool get isEnRecherche => this == ReverseSearchStatus.enRecherche;
  bool get isAnnulee =>
      this == ReverseSearchStatus.annuleeParClient ||
      this == ReverseSearchStatus.annulee;
}
