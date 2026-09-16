import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/home_feed/for_you_residence_item.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

/// Carte plein cadre pour la section "Les plus aimées" (`section.key ==
/// "top_rated"`) : photo pleine largeur + dégradé, nom/localisation/avis en
/// overlay, et la pile d'avatars des reviewers en bas à droite.
/// Distincte de `ForYouResidenceTile` (gabarit compact classique) — cette
/// section a un design dédié plus immersif.
class ForYouTopRatedTile extends StatelessWidget {
  final ForYouResidenceItem residence;

  const ForYouTopRatedTile({super.key, required this.residence});

  static const double width = 286;
  static const double height = 286;
  static const double _radius = 20;

  /// Marge verticale à réserver AUTOUR de cette carte (ex: la hauteur de
  /// la ligne du carousel qui l'affiche) pour que le débordement de la
  /// pile d'avatars (positionnée hors de la carte, en bas-droite) ne soit
  /// pas rogné par le viewport de la `ListView` horizontale.
  static const double overflowAllowance = 30;

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        residence.imageUrl != null ? Utils.getImagePath(id: residence.imageUrl!) : '';
    final reviewersTotal = _ReviewerAvatarStack._totalFor(residence);
    final hasAvatars = reviewersTotal > 0;
    // Réserve la place de la pile d'avatars (positionnée à part, en dehors
    // du `ClipRRect`) pour que le texte ne passe pas dessous.
    final infoRightInset = hasAvatars ? 16 + _ReviewerAvatarStack.widthFor(residence) + 8 : 16.0;

    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        borderRadius: BorderRadius.circular(_radius),
        onTap: () => context.push(ResidencePage.route(residence.residenceId)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(_radius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 800,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      period: const Duration(milliseconds: 500),
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child:
                            FaIcon(FontAwesomeIcons.images, size: 60, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.75)],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: infoRightInset,
                    bottom: 18,
                    child: _Info(residence: residence),
                  ),
                ],
              ),
            ),
            // Pile d'avatars en position absolue, HORS du `ClipRRect` : ne
            // doit pas être rognée par les coins arrondis de la carte —
            // elle chevauche volontairement le coin bas-droite.
            if (hasAvatars)
              Positioned(
                left: 204,
                top: 248,
                child: _ReviewerAvatarStack(
                  avatars: residence.reviewerAvatars,
                  total: reviewersTotal,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final ForYouResidenceItem residence;

  const _Info({required this.residence});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          residence.name,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (residence.location != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Iconsax.location, size: 12, color: Colors.white),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  residence.location!,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        if (residence.totalReviews != null) ...[
          const SizedBox(height: 2),
          Text(
            '${residence.totalReviews} avis',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500,
              fontSize: 9,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ],
    );
  }
}

class _ReviewerAvatarStack extends StatelessWidget {
  final List<ForYouReviewerAvatar> avatars;
  final int total;

  const _ReviewerAvatarStack({required this.avatars, required this.total});

  static const double _size = 42;
  static const double _overlap = 22;

  /// Toujours 3 éléments visibles max. En dessous ou égal à 3 reviewers au
  /// total, on affiche un cercle par reviewer ; au-delà, seuls les 2
  /// premiers avatars sont montrés et le 3e cercle devient "+N" (N = le
  /// reste, pas juste `total - 3`).
  static const int _maxSlots = 3;

  /// Couleurs de la pile : du plus clair (avatar le plus "enterré", à
  /// gauche) au plus foncé (la bulle "+N", tout à droite) — dégradé,
  /// pas une couleur unique par avatar.
  static const Color _lightest = Color(0xFFAEB8FF);
  static const Color _darkest = Color(0xFF2744DE);

  static List<ForYouReviewerAvatar> _displayAvatars(
      List<ForYouReviewerAvatar> avatars, int total) {
    final take = total > _maxSlots ? _maxSlots - 1 : _maxSlots;
    return avatars.take(take).toList();
  }

  static int _remaining(List<ForYouReviewerAvatar> displayAvatars, int total) =>
      total > displayAvatars.length ? total - displayAvatars.length : 0;

  static int _itemCount(ForYouResidenceItem residence) {
    final total = _totalFor(residence);
    final displayAvatars = _displayAvatars(residence.reviewerAvatars, total);
    return displayAvatars.length + (_remaining(displayAvatars, total) > 0 ? 1 : 0);
  }

  /// Nombre total de reviewers, tous champs backend confondus (compat avec
  /// `remainingCount` si `reviewerCount` n'est pas fourni).
  static int _totalFor(ForYouResidenceItem residence) =>
      residence.reviewerCount ??
      (residence.reviewerAvatars.length + (residence.remainingCount ?? 0));

  /// Largeur qu'occupera la pile pour cette résidence — pour réserver la
  /// place à côté (le texte ne doit pas passer dessous).
  static double widthFor(ForYouResidenceItem residence) {
    final itemCount = _itemCount(residence);
    if (itemCount == 0) return 0;
    return _size + (itemCount - 1) * (_size - _overlap);
  }

  @override
  Widget build(BuildContext context) {
    final displayAvatars = _displayAvatars(avatars, total);
    final remaining = _remaining(displayAvatars, total);
    final itemCount = displayAvatars.length + (remaining > 0 ? 1 : 0);
    if (itemCount == 0) return const SizedBox.shrink();

    final width = _size + (itemCount - 1) * (_size - _overlap);

    return SizedBox(
      width: width,
      height: _size,
      child: Stack(
        children: [
          for (var i = 0; i < displayAvatars.length; i++)
            Positioned(
              right: (itemCount - 1 - i) * (_size - _overlap),
              child: _ReviewerAvatar(
                avatar: displayAvatars[i],
                color: Color.lerp(_lightest, _darkest, (i + 1) / itemCount)!,
              ),
            ),
          if (remaining > 0)
            Positioned(
              right: 0,
              child: _RemainingBubble(count: remaining),
            ),
        ],
      ),
    );
  }
}

class _ReviewerAvatar extends StatelessWidget {
  final ForYouReviewerAvatar avatar;
  final Color color;

  const _ReviewerAvatar({required this.avatar, required this.color});

  /// Sans `avatarId`, on retombe sur la 1ère lettre du nom de famille (à
  /// défaut, prénom, à défaut "?") pour composer un monogramme.
  String get _letter {
    final source = avatar.lastName?.trim().isNotEmpty == true
        ? avatar.lastName!
        : avatar.firstName?.trim().isNotEmpty == true
            ? avatar.firstName!
            : null;
    return source == null ? '?' : source.trim().substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = avatar.avatarId != null && avatar.avatarId!.isNotEmpty;
    final monogram = Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        _letter,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );

    return Container(
      width: _ReviewerAvatarStack._size,
      height: _ReviewerAvatarStack._size,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? CachedNetworkImage(
              imageUrl: Utils.getImagePath(id: avatar.avatarId!),
              fit: BoxFit.cover,
              placeholder: (context, url) => monogram,
              errorWidget: (context, url, error) => monogram,
            )
          : monogram,
    );
  }
}

class _RemainingBubble extends StatelessWidget {
  final int count;

  const _RemainingBubble({required this.count});

  static const Color _bg = _ReviewerAvatarStack._darkest;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _ReviewerAvatarStack._size,
      height: _ReviewerAvatarStack._size,
      decoration: BoxDecoration(color: _bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        '+$count',
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: Colors.white,
        ),
      ),
    );
  }
}
