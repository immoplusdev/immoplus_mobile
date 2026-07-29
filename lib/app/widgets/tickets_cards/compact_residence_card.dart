import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/extensions/string_extension.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/rating_component.dart';
import 'package:shimmer/shimmer.dart';

class CompactResidenceCard extends StatefulWidget {
  const CompactResidenceCard({
    super.key,
    required this.residence,
    this.showRating = true,
    this.showName = true,
    this.showLocation = true,
  });

  final ResidenceModel residence;
  final bool showRating;
  final bool showName;
  final bool showLocation;

  @override
  State<CompactResidenceCard> createState() => _CompactResidenceCardState();
}

class _CompactResidenceCardState extends State<CompactResidenceCard> {
  final favoriesUtils = getIt<FavoriesUtils>();
  final ValueNotifier<bool> _liked = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    favoriesUtils.isFavorite(widget.residence.id).then((value) {
      _liked.value = value;
    });
  }

  @override
  void dispose() {
    _liked.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: neirResidenceCardWidth,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Constantes.tempPage = Utils.getCurrentLocation();
          context.push(
            ResidencePage.route(widget.residence.id),
            extra: widget.residence,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: double.infinity,
                height: 170,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image de fond
                    _buildBackgroundImage(),

                    // Rating en haut à gauche (optionnel)
                    if (widget.showRating) ...[
                      _buildGradientOverlay(),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: RatingComponent(
                          rating: (widget.residence.score ?? 0).toDouble(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Gap(8),
            _buildResidenceInfo(context),
          ],
        ),
      ),
    );
  }

  /// Image de fond avec placeholder
  Widget _buildBackgroundImage() {
    final imageUrl = widget.residence.images.isNotEmpty
        ? Utils.getImagePath(id: widget.residence.images.first)
        : '';

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: 600,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        period: const Duration(milliseconds: 500),
        child: Container(
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Icon(
            FontAwesomeIcons.images,
            size: 60,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  /// Gradient overlay du bas vers le haut
  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.7),
          ],
          stops: const [0.3, 0.6, 1.0],
        ),
      ),
    );
  }

  /// Informations de la résidence : titre, localisation puis prix, empilés
  /// sous l'image (fond blanc, pas d'overlay).
  Widget _buildResidenceInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nom de la résidence
        if (widget.showName)
          Text(
            widget.residence.nom.capitalizeFirst(),
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        // Localisation
        if (widget.showLocation) ...[
          const Gap(3),
          Text(
            "${widget.residence.adresse}${widget.residence.communeModel?.name != null ? ', ${widget.residence.communeModel!.name}' : ''}",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],

        const Gap(12),

        // Prix
        if (widget.residence.hasReduction)
          Text(
            '${CurrencyFormatter().format(widget.residence.prixReservation.toString())} Fcfa',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey.shade500,
              fontSize: 12,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    '${CurrencyFormatter().format((widget.residence.hasReduction ? widget.residence.prixReduit : widget.residence.prixReservation).toString())} Fcfa',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: widget.residence.hasReduction
                      ? Colors.redAccent
                      : Colors.black,
                ),
              ),
              TextSpan(
                text: '/nuit',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w200,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Bouton favori (commenté)
  // Widget _buildFavoriteButton() {
  //   return ValueListenableBuilder<bool>(
  //     valueListenable: _liked,
  //     builder: (context, isLiked, _) {
  //       return ResidenceFavoriteButton(
  //         isFavorite: isLiked,
  //         onTap: () async {
  //           if (_liked.value) {
  //             await favoriesUtils.deleteFavoriteByItemId(widget.residence.id);
  //           } else {
  //             await favoriesUtils.addResidenceToFavorites(widget.residence);
  //           }
  //           _liked.value = !isLiked;
  //         },
  //       );
  //     },
  //   );
  // }
}
