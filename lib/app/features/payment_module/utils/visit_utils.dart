import 'package:intl/intl.dart';

class VisitUtils {
  static String formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    // Créer une instance de DateFormat
    DateFormat formatter = DateFormat('d MMMM y à HH:mm', 'fr_FR');
    // Formater la date
    String formatted = formatter.format(dateTime);
    return formatted.replaceAll(':', 'H');
  }
}
