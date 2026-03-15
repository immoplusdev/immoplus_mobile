class ActiveReservationException implements Exception {
  final String message;
  final String reservationId;

  const ActiveReservationException({
    required this.message,
    required this.reservationId,
  });
}
