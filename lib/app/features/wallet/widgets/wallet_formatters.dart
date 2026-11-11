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

/// Montant sans séparateur de milliers : « 45000 FCFA » (lignes d'opérations).
String formatAmountCompact(num value, {String currency = 'XOF'}) =>
    '${value.round()} ${currency == 'XOF' ? 'FCFA' : currency}';

/// Montant groupé par points, unité en minuscules : « 45.000 fcfa » (cartes
/// de synthèse).
String formatAmountDotted(num value, {String currency = 'XOF'}) {
  final grouped = value.round().toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => '.',
      );
  return '$grouped ${currency == 'XOF' ? 'fcfa' : currency.toLowerCase()}';
}
