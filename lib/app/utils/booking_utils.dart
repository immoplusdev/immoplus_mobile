enum BookingStatus { upcoming, ongoing, completed }

class BookingUtils {
  static BookingStatus getBookingStatus(DateTime startDate, DateTime endDate) {
    DateTime today = DateTime.now();
    DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);
    DateTime startWithoutTime =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime endWithoutTime =
        DateTime(endDate.year, endDate.month, endDate.day);

    if (endWithoutTime.isBefore(todayWithoutTime)) {
      return BookingStatus.completed;
    } else if (startWithoutTime.isAfter(todayWithoutTime)) {
      return BookingStatus.upcoming;
    } else {
      return BookingStatus.ongoing;
    }
  }

  static getStatusText(
      {required DateTime startDate, required DateTime endDate}) {
    switch (getBookingStatus(startDate, endDate)) {
      case BookingStatus.upcoming:
        return 'Séjour à venir';
      case BookingStatus.ongoing:
        return 'Séjour en cours';
      case BookingStatus.completed:
        return 'Séjour terminé';
    }
  }
}
