import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/utils/ad_action_handler.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

/// Carte pub "carrousel" — un seul bloc compact (pas un carrousel plein
/// écran) : 3 photos en éventail statique, badge "Voir les vidéos" si la
/// campagne en a, titre/sous-titre, et jusqu'à 2 pastilles méta (quartier,
/// durée) déduites des champs déjà renvoyés par l'API — aucune valeur
/// inventée côté front.
class AdCarouselWidget extends StatelessWidget {
  final AdCampaignModel campaign;

  const AdCarouselWidget({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    final images = campaign.media.images.take(3).toList();
    if (images.isEmpty) return const SizedBox.shrink();

    final hasVideos = campaign.media.videos.isNotEmpty;
    final badge = campaign.content.badge;

    return GestureDetector(
      // Toute la carte est UN seul bloc visuel (les 3 photos se chevauchent,
      // plus de tap par photo) : on route donc systématiquement vers la
      // première entité — couvre `scope.entity_id` (campagne mono-cible,
      // via le fallback `handleAdAction`) ET `scope.entity_ids` pluriel
      // (campagne multi-résidences, ex: `OPEN_RESIDENCE` avec 3 ids) que
      // `AdTap`/`handleAdAction` seul ne sait pas lire.
      behavior: HitTestBehavior.opaque,
      onTap: () => AdActionHandler.handleCardAction(context, campaign, cardIndex: 0),
      onLongPress: () => AdActionHandler.handleCardAction(
        context,
        campaign,
        cardIndex: 0,
        isLongPress: true,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _PhotoFan(images: images, showWatchVideos: hasVideos),
            const SizedBox(height: 14),
            if (campaign.content.title?.isNotEmpty == true)
              Text(
                campaign.content.title!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            if (campaign.content.subtitle?.isNotEmpty == true) ...[
              const SizedBox(height: 2),
              Text(
                campaign.content.subtitle!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
            if ((campaign.location?.isNotEmpty ?? false) || (badge?.isNotEmpty ?? false)) ...[
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (campaign.location?.isNotEmpty ?? false)
                    _MetaPill(icon: Iconsax.location, label: campaign.location!),
                  if (badge?.isNotEmpty ?? false)
                    _MetaPill(icon: Iconsax.tag, label: badge!),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.grey.shade600),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Éventail statique de 2-3 photos (pas de scroll) + badge "Voir les
/// vidéos" superposé en bas, hauteur fixe modérée pour rester compact dans
/// le feed.
class _PhotoFan extends StatelessWidget {
  final List<String> images;
  final bool showWatchVideos;

  const _PhotoFan({required this.images, required this.showWatchVideos});

  static const double _cardWidth = 112;
  static const double _cardHeight = 112;
  static const double _centerCardWidth = 126;
  static const double _centerCardHeight = 126;
  static const double _centerVerticalOffset = 6;
  static const double _fanHeight = 150;
  static const double _borderWidth = 3;
  static const double _radius = 14;

  /// Décalage horizontal du centre de chaque carte latérale par rapport au
  /// centre de la pile.
  static const double _sideOffset = 72;

  /// Décalage vertical des cartes latérales — plus basses que celle du
  /// milieu, pour un vrai effet d'éventail plutôt que 3 cartes alignées.
  static const double _sideVerticalOffset = 14;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: _fanHeight,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Cartes latérales d'abord (dessous), celle du milieu en dernier
            // (dessus) — l'ordre des enfants d'un Stack fixe le z-order.
            if (images.length > 2)
              Transform.translate(
                offset: const Offset(-_sideOffset, _sideVerticalOffset),
                child: _photoCard(images[0], angle: -6),
              ),
            if (images.length > 1)
              Transform.translate(
                offset: const Offset(_sideOffset, _sideVerticalOffset),
                child: _photoCard(images.last, angle: 6),
              ),
            Transform.translate(
              offset: const Offset(0, _centerVerticalOffset),
              child: _photoCard(
                images.length > 2 ? images[1] : images.first,
                angle: 0,
                width: _centerCardWidth,
                height: _centerCardHeight,
              ),
            ),
            if (showWatchVideos)
              const Positioned(bottom: 0, child: _WatchVideosPill()),
          ],
        ),
      ),
    );
  }

  Widget _photoCard(
    String imageId, {
    required double angle,
    double width = _cardWidth,
    double height = _cardHeight,
  }) {
    // Bordure blanche = padding autour d'un `ClipRRect` explicite plutôt
    // qu'un `Container.border` + `clipBehavior` — le clip du child est
    // garanti quel que soit le rendu de la décoration (pas de coins carrés
    // en dessous du liseré blanc).
    return Transform.rotate(
      angle: angle * 3.1415926535 / 180,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(_borderWidth),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius - _borderWidth),
          child: CachedNetworkImage(
            imageUrl: Utils.getImagePath(id: imageId),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(color: Colors.white),
            ),
            errorWidget: (_, __, ___) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}

class _WatchVideosPill extends StatelessWidget {
  const _WatchVideosPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.video_play, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            'Voir les vidéos',
            style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
