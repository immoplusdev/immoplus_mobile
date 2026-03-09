import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Composant réutilisable affichant hashtags + date au format français
/// Exemple : #immo #feed #immobilier (17 février)
class DescriptionFooter extends StatelessWidget {
  const DescriptionFooter({
    super.key,
    this.date,
    this.hashtags = const ['immo', 'feed', 'immobilier'],
  });

  /// Date au format String (ex: "2024-02-17")
  final String? date;

  /// Liste des hashtags sans le # (ex: ['immo', 'feed', 'immobilier'])
  final List<String> hashtags;

  static const double _fontSize = 12.0;

  /// Formate la date en français (ex: "17 février")
  String _formatDateToFrench(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.tryParse(dateStr);
      if (dt == null) return '';
      return DateFormat('d MMMM', 'fr_FR').format(dt);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDateToFrench(date);
    final hashtagsText = hashtags.map((h) => '#$h').join(' ');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hashtagsText,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: _fontSize,
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
        ),
        if (formattedDate.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            formattedDate,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: _fontSize,
              fontWeight: FontWeight.w400,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }
}
