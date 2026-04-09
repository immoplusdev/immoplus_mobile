enum StatusReservation {
  rejete,
  terminee,
  valide,
  enCours,
  enAttenteReponseProprietaire,
  enAttentePaiementClient,
  proprietaireAnnuleReservation,
  proprietaireSansReponse,
  clientAnnuleReservation,
  clientSansReponse;

  String get backendValue {
    switch (this) {
      case StatusReservation.rejete:
        return 'rejete';
      case StatusReservation.terminee:
        return 'terminee';
      case StatusReservation.valide:
        return 'valide';
      case StatusReservation.enCours:
        return 'en_cours';
      case StatusReservation.enAttenteReponseProprietaire:
        return 'en_attente_reponse_proprietaire';
      case StatusReservation.enAttentePaiementClient:
        return 'en_attente_paiement_client';
      case StatusReservation.proprietaireAnnuleReservation:
        return 'proprietaire_annule_reservation';
      case StatusReservation.proprietaireSansReponse:
        return 'proprietaire_sans_reponse';
      case StatusReservation.clientAnnuleReservation:
        return 'client_annule_reservation';
      case StatusReservation.clientSansReponse:
        return 'client_sans_reponse';
    }
  }

  static StatusReservation? fromString(String? value) {
    if (value == null) return null;
    try {
      return StatusReservation.values.firstWhere(
        (e) => e.backendValue == value,
      );
    } catch (_) {
      return null;
    }
  }
}
