import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:immoplus/app/data/models/remote/rating/residence_review_model.dart';
import 'package:immoplus/app/extensions/string_extension.dart';
import 'package:immoplus/app/utils/utils.dart';

/// Carte d'un avis résidence (avatar, nom, note, date relative, texte
/// tronqué avec "Afficher plus").
///
/// Locale FR enregistrée localement (`_kFrenchLocale`) plutôt que
/// globalement dans main.dart — n'affecte que la date relative de cette
/// carte, pas les autres usages de `timeago`/`Utils.getTimeAgo` de l'app.
const String _kFrenchLocale = 'fr_reviews';

class ResidenceReviewCard extends StatelessWidget {
  ResidenceReviewCard({
    super.key,
    required this.review,
    this.width,
  }) {
    if (!_frenchLocaleRegistered) {
      timeago.setLocaleMessages(_kFrenchLocale, timeago.FrMessages());
      _frenchLocaleRegistered = true;
    }
  }

  static bool _frenchLocaleRegistered = false;

  final ResidenceReviewModel review;

  /// Largeur fixe pour l'usage en liste horizontale ; null = pleine largeur
  /// (utilisé dans la feuille "voir tous les avis").
  final double? width;

  DateTime? get _ratedAt {
    final raw = review.ratedAt;
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  @override
  Widget build(BuildContext context) {
    final ratedAt = _ratedAt;
    final feedback = review.propertyFeedback?.trim();

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: review.reviewerAvatarId?.isNotEmpty == true
                    ? CachedNetworkImageProvider(
                        Utils.getImagePath(id: review.reviewerAvatarId!),
                      )
                    : null,
                child: review.reviewerAvatarId?.isNotEmpty == true
                    ? null
                    : Text(
                        review.reviewerName.isNotEmpty
                            ? review.reviewerName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF222222),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Text(
                review.reviewerName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Stars(rating: review.propertyRating),
              if (ratedAt != null) ...[
                const Text(' · ', style: TextStyle(color: Colors.grey)),
                Text(
                  timeago.format(ratedAt, locale: _kFrenchLocale),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ],
          ),
          if (feedback != null && feedback.isNotEmpty) ...[
            const SizedBox(height: 12),
            _ExpandableFeedback(text: feedback),
          ],
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating});
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star_rounded : Icons.star_border_rounded,
          size: 16,
          color: const Color(0xFF222222),
        );
      }),
    );
  }
}

class _ExpandableFeedback extends StatefulWidget {
  const _ExpandableFeedback({required this.text});
  final String text;

  @override
  State<_ExpandableFeedback> createState() => _ExpandableFeedbackState();
}

class _ExpandableFeedbackState extends State<_ExpandableFeedback> {
  bool _hasOverflow = false;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Colors.grey.shade800,
      height: 1.5,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final textPainter = TextPainter(
              text: TextSpan(text: widget.text.capitalizeFirst(), style: style),
              maxLines: 4,
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: constraints.maxWidth);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (_hasOverflow != textPainter.didExceedMaxLines) {
                setState(() => _hasOverflow = textPainter.didExceedMaxLines);
              }
            });

            return Text(
              widget.text.capitalizeFirst(),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: style,
            );
          },
        ),
        if (_hasOverflow) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => _showFullFeedback(context),
            child: const Text(
              'Afficher plus',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF222222),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showFullFeedback(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
          child: Text(
            widget.text.capitalizeFirst(),
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}
