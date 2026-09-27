import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Locale FR enregistrée localement (comme `residence_review_card.dart`)
/// plutôt que globalement — n'affecte que les dates de la messagerie.
const String _kFrenchLocale = 'fr_messaging';
bool _frenchLocaleRegistered = false;

void _ensureFrenchLocale() {
  if (_frenchLocaleRegistered) return;
  timeago.setLocaleMessages(_kFrenchLocale, timeago.FrMessages());
  _frenchLocaleRegistered = true;
}

String _twoDigits(int n) => n.toString().padLeft(2, '0');

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Heure relative pour l'aperçu de l'inbox (ex. "il y a 5 minutes").
String formatLastMessageRelative(DateTime? date) {
  if (date == null) return '';
  _ensureFrenchLocale();
  return timeago.format(date, locale: _kFrenchLocale);
}

/// Sous-titre de présence (spec §5.1) : "En ligne" géré séparément par
/// l'appelant ; ceci ne formate que le "vu à/hier/le ...".
String formatLastSeen(DateTime lastSeenAt) {
  final now = DateTime.now();
  final time = '${_twoDigits(lastSeenAt.hour)}:${_twoDigits(lastSeenAt.minute)}';
  if (_isSameDay(lastSeenAt, now)) {
    return 'Vu à $time';
  }
  final yesterday = now.subtract(const Duration(days: 1));
  if (_isSameDay(lastSeenAt, yesterday)) {
    return 'Vu hier à $time';
  }
  final date = DateFormat('dd/MM').format(lastSeenAt);
  return 'Vu le $date';
}

/// Heure affichée sous une bulle de message.
String formatBubbleTime(DateTime? date) {
  if (date == null) return '';
  return '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
}

/// Libellé du séparateur de jour dans la liste de messages.
String formatDaySeparator(DateTime date) {
  final now = DateTime.now();
  if (_isSameDay(date, now)) return "Aujourd'hui";
  final yesterday = now.subtract(const Duration(days: 1));
  if (_isSameDay(date, yesterday)) return 'Hier';
  return DateFormat('d MMMM', 'fr_FR').format(date);
}
