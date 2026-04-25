import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

import '../models/chat_alert_payload.dart';
import '../models/chat_property.dart';
import 'chat_tokens.dart';

/// PropertyMiniCard (spec §9) — 76px · vignette 64 r10 · prix brand.
class PropertyMiniCard extends StatelessWidget {
  const PropertyMiniCard({
    super.key,
    required this.property,
    this.onTap,
    this.showScore = true,
  });

  final ChatProperty property;
  final VoidCallback? onTap;
  final bool showScore;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap == null
            ? null
            : () {
                HapticFeedback.lightImpact();
                onTap!();
              },
        child: SizedBox(
          height: 76,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            child: Row(
              children: [
                _Thumbnail(url: property.imageUrl),
                const SizedBox(width: ChatTokens.s12),
                Expanded(child: _Info(property: property)),
                if (showScore && property.scorePercent != null) ...[
                  const SizedBox(width: ChatTokens.s8),
                  ScoreBadge(value: property.scorePercent!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    const size = 64.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(ChatTokens.thumbRadius),
      child: SizedBox(
        width: size,
        height: size,
        child: url == null || url!.isEmpty
            ? _placeholder()
            : CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 150),
                placeholder: (_, __) => const _ShimmerSkeleton(),
                errorWidget: (_, __, ___) => _placeholder(),
              ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: ChatTokens.neutral100,
      alignment: Alignment.center,
      child: const Icon(
        Iconsax.gallery,
        color: ChatTokens.skeleton,
        size: 22,
      ),
    );
  }
}

class _ShimmerSkeleton extends StatelessWidget {
  const _ShimmerSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ChatTokens.neutral100,
      highlightColor: const Color(0xFFFAFAFA),
      child: Container(color: ChatTokens.neutral100),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.property});
  final ChatProperty property;

  @override
  Widget build(BuildContext context) {
    final meta = <String>[
      if (property.location != null) property.location!,
      if (property.rooms != null) '${property.rooms}p',
      if (property.surface != null) '${property.surface!.round()} m²',
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            property.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ChatTokens.neutral900,
              letterSpacing: -0.1,
            ),
          ),
          if (meta.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              meta,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: ChatTokens.neutral400,
                letterSpacing: -0.05,
              ),
            ),
          ],
          if (property.price != null) ...[
            const SizedBox(height: 4),
            Text(
              formatPriceLong(property.price!),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ChatTokens.brand500,
                fontFeatures: [FontFeature.tabularFigures()],
                letterSpacing: -0.1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ScoreBadge extends StatelessWidget {
  const ScoreBadge({super.key, required this.value});
  final int value;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$value%',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: -0.1,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  (Color, Color) _colors() {
    if (value >= 90) {
      return (ChatTokens.scoreHighBg, ChatTokens.scoreHighFg);
    }
    if (value >= 70) {
      return (ChatTokens.scoreMidBg, ChatTokens.scoreMidFg);
    }
    return (ChatTokens.neutral100, const Color(0xFF737373));
  }
}
