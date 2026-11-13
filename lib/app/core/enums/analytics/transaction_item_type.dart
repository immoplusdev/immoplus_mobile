/// Types de cartes du menu flottant « Mes réservations ».
enum TransactionItemType {
  pendingOwnerReservation('reservation_pending'),
  reservationToPay('reservation_to_pay'),
  reverseSearch('reverse_search');

  const TransactionItemType(this.analyticsValue);

  final String analyticsValue;
}
