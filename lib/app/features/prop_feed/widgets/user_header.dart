import 'package:flutter/material.dart';

/// En-tête utilisateur : légende avec hashtags.
class UserHeader extends StatelessWidget {
  const UserHeader({
    super.key,
    this.caption = '',
    this.hashtags = const [],
  });

  final String caption;
  final List<String> hashtags;

  static const double _padding = 12.0;
  static const double _captionFontSize = 13.0;

  @override
  Widget build(BuildContext context) {
    if (caption.isEmpty && hashtags.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(_padding),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildCaption(context)],
      ),
    );
  }

  Widget _buildCaption(BuildContext context) {
    final List<InlineSpan> spans = <InlineSpan>[];

    if (caption.isNotEmpty) {
      spans.add(
        TextSpan(
          text: caption,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.95),
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

    return RichText(
      text: TextSpan(children: spans),
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }
}
