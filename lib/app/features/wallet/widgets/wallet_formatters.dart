import 'package:intl/intl.dart';

/// Montant au format « 18 750 FCFA » (espace insécable entre les milliers).
String formatAmount(num value, {String currency = 'XOF'}) {
  final grouped = value.round().toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => ' ',
      );
  return '$grouped ${currency == 'XOF' ? 'FCFA' : currency}';
}

String formatMovementDate(DateTime? date) =>
    date == null ? '' : DateFormat("d MMM yyyy 'à' HH:mm", 'fr').format(date);
