enum DemandeProParticulierStatus {
  pending("pending"),
  approved("approved"),
  rejected("rejected");

  final String value;

  const DemandeProParticulierStatus(this.value);

  static DemandeProParticulierStatus fromString(String status) {
    switch (status) {
      case 'approved':
        return DemandeProParticulierStatus.approved;
      case 'rejected':
        return DemandeProParticulierStatus.rejected;
      default:
        return DemandeProParticulierStatus.pending;
    }
  }
}
