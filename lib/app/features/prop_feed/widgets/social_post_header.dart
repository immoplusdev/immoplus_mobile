import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/features/prop_feed/widgets/profile_avatar.dart';
import 'package:immoplus/app/features/prop_feed/widgets/description_footer.dart';
import 'package:immoplus/app/utils/app_colors.dart';

/// En-tête de post type TikTok : avatar, nom, légende avec hashtags.
/// Comportement Plus/Moins : tap sur description ou bouton → étend/replie avec animation.
class SocialPostHeader extends StatelessWidget {
  const SocialPostHeader({
    super.key,
    required this.username,
    this.caption = '',
    this.hashtags = const [],
    this.avatarUrl,
    this.avatarPath,
    this.date,
    this.verify = false,
    this.onFollowTap,
    this.onMoreTap,
    this.isExpanded = false,
    this.descriptionMaxWidthFactor = 0.70,
    this.contentMaxWidth,
    this.contentMaxLines = 2,
    this.scrollThreshold = 190,
  });

  final String username;
  final String caption;
  final List<String> hashtags;
  final String? avatarUrl;
  final String? avatarPath;
  /// Date affichée à côté du username (ex: "2024-04-01").
  final String? date;
  final bool verify;
  final VoidCallback? onFollowTap;
  final VoidCallback? onMoreTap;
  /// Si true, la description est entièrement affichée (après tap sur "Plus").
  final bool isExpanded;
  /// Facteur de largeur max pour la description (0.0 à 1.0). Ex: 0.65 = 65% du parent.
  final double descriptionMaxWidthFactor;
  /// Largeur max du contenu. Si dépassée, la description est tronquée à [contentMaxLines].
  final double? contentMaxWidth;
  /// Nombre max de lignes pour la description quand le contenu dépasse [contentMaxWidth].
  final int contentMaxLines;
  /// Quand on appuie sur Plus et que la description dépasse ce nombre de caractères, elle devient scrollable.
  final int scrollThreshold;

  static const double _padding = 12.0;
  static const int _longDescriptionThreshold = 60;

  static const double _captionFontSize = 13.0;
  static const double _usernameFontSize = 14.0;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.all(_padding),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileRow(context),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Iconsax.location,
                color: AppColors.white.withOpacity(0.5),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                'Cocody, Abidjan',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (caption.isNotEmpty || hashtags.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildDescriptionRow(context),
          ],
        ],
      ),
    );

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      alignment: Alignment.bottomCenter,
      child: contentMaxWidth != null
          ? ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth!),
              child: content,
            )
          : content,
    );
  }

  Widget _buildProfileRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onFollowTap,
          child: ProfileAvatar(
            username: username,
            avatarUrl: avatarUrl,
            avatarPath: avatarPath,
            verify: verify,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: _usernameFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildDescriptionRow(BuildContext context) {
    final fullText = _buildCaptionText();
    final isLong = fullText.length > _longDescriptionThreshold;
    final shouldScroll =
        isExpanded && fullText.length > scrollThreshold;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth * descriptionMaxWidthFactor;

        Widget descriptionChild;
        if (shouldScroll) {
          final lineHeight = _captionFontSize * 1.35;
          final maxHeight = lineHeight * 7; // Affiche 5 lignes au lieu de 2
          descriptionChild = SizedBox(
            width: maxWidth,
            height: maxHeight,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: RichText(
                text: TextSpan(children: _buildCaptionSpans()),
              ),
            ),
          );
        } else {
          descriptionChild = SizedBox(
            width: maxWidth,
            child: RichText(
              text: TextSpan(children: _buildCaptionSpans()),
              maxLines: isExpanded ? null : contentMaxLines,
              overflow:
                  isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: isLong ? onMoreTap : null,
                  behavior: HitTestBehavior.opaque,
                  child: descriptionChild,
                ),
                if (isLong && !isExpanded) ...[
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: onMoreTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Plus',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            // Afficher le footer avec hashtags + date quand la description est expandue
            if (isExpanded) ...[
              const SizedBox(height: 8),
              DescriptionFooter(
                date: date,
                hashtags: const ['immo', 'feed', 'immobilier'],
              ),
            ],
          ],
        );
      },
    );
  }

  String _buildCaptionText() {
    final parts = <String>[];
    if (caption.isNotEmpty) parts.add(caption);
    if (hashtags.isNotEmpty) {
      parts.add(hashtags.map((h) => h.startsWith('#') ? h : '#$h').join(' '));
    }
    return parts.join(' ');
  }

  List<InlineSpan> _buildCaptionSpans() {
    final List<InlineSpan> spans = <InlineSpan>[];

    if (caption.isNotEmpty) {
      spans.add(
        TextSpan(
          text: caption,
          style: TextStyle(
            color: Colors.white.withOpacity(0.95),
            fontSize: _captionFontSize,
            height: 1.35,
          ),
        ),
      );
    }

    if (hashtags.isNotEmpty) {
      if (spans.isNotEmpty) spans.add(const TextSpan(text: ' '));
      final hashtagText = hashtags
          .map((h) => h.startsWith('#') ? h : '#$h')
          .join(' ');
      spans.add(
        TextSpan(
          text: hashtagText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: _captionFontSize,
            fontWeight: FontWeight.bold,
            height: 1.35,
          ),
        ),
      );
    }

    return spans;
  }
}
