import 'package:intl/intl.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/utils/utils.dart';

/// Résumé optionnel de l'élément à payer, affiché en haut de
/// l'écran de choix du moyen de paiement.
class PaymentSummary {
  const PaymentSummary({
    required this.title,
    this.subtitle,
    this.badge,
    this.dateRange,
    this.reference,
    this.imageIds = const [],
  });

  final String title;
  final String? subtitle;

  /// Ex: "3 nuits".
  final String? badge;

  /// Ex: "12 – 15 nov. 2026".
  final String? dateRange;
  final String? reference;

  /// Identifiants d'images, résolus avec [Utils.getImagePath].
  final List<String> imageIds;

  factory PaymentSummary.fromReservation(ReservationModel reservation) {
    final residence = reservation.residence;
    final nights = reservation.datesReservation.length;
    final location = [residence.commune, residence.ville]
        .where((e) => e.trim().isNotEmpty)
        .join(' · ');
    final images = [
      if (residence.miniature.isNotEmpty) residence.miniature,
      ...residence.images.where((e) => e != residence.miniature),
    ];

    return PaymentSummary(
      title: residence.nom,
      subtitle: location.isEmpty ? null : location,
      badge: nights > 0 ? '$nights nuit${nights > 1 ? 's' : ''}' : null,
      dateRange: _formatRange(reservation.dateDebut, reservation.dateFin),
      reference: reservation.codeReservation.isEmpty
          ? null
          : reservation.codeReservation,
      imageIds: images,
    );
  }

  static String? _formatRange(String start, String end) {
    if (start.isEmpty || end.isEmpty) return null;
    final from = Utils.toDateTime(start);
    final to = Utils.toDateTime(end);
    final sameMonth = from.year == to.year && from.month == to.month;
    final day = DateFormat('d', 'fr');
    final dayMonth = DateFormat('d MMM', 'fr');
    final full = DateFormat('d MMM yyyy', 'fr');
    return sameMonth
        ? '${day.format(from)} – ${full.format(to)}'
        : '${dayMonth.format(from)} – ${full.format(to)}';
  }
}

class PaymentPageAdapter<T> {
  String itemId;
  String collection;
  int amount;
  T? extra;
  PaymentSummary? summary;
  PaymentPageAdapter({
    required this.itemId,
    required this.collection,
    required this.amount,
    this.extra,
    this.summary,
  });
}
