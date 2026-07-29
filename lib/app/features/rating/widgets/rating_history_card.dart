import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:immoplus/app/data/models/remote/rating/rating_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingHistoryCard extends StatelessWidget {
  final RatingModel rating;

  const RatingHistoryCard({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    String dateStr = '';
    try {
      if (rating.ratedAt.isNotEmpty) {
        final d = Utils.toDateTime(rating.ratedAt);
        dateStr = DateFormat('d MMM yyyy').format(d);
      }
    } catch (_) {}

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Réservation: ${rating.reservationId.substring(0, 8)}...',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (dateStr.isNotEmpty)
                    Text(
                      dateStr,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
              const Gap(12),
              _buildRatingRow('Résidence', rating.propertyRating),
              const Gap(8),
              _buildRatingRow('Accueil', rating.hostRating),
              if (rating.propertyFeedback.isNotEmpty) ...[
                const Gap(12),
                Text(
                  '"${rating.propertyFeedback}"',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
              if (rating.tags.isNotEmpty) ...[
                const Gap(12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: rating.tags.map((t) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2548E5).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        t,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: const Color(0xFF2548E5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingRow(String label, int ratingValue) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        RatingBarIndicator(
          rating: ratingValue.toDouble(),
          itemBuilder: (context, index) => const Icon(
            Icons.star_rounded,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 16.0,
          direction: Axis.horizontal,
        ),
      ],
    );
  }
}
