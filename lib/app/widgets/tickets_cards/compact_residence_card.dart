import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/extensions/string_extension.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/rating_component.dart';
import 'package:immoplus/app/widgets/tickets_cards/residence_card.dart';
import 'package:shimmer/shimmer.dart';

class CompactResidenceCard extends StatefulWidget {
  const CompactResidenceCard({
    super.key,
    required this.residence,
    this.showRating = true,
  });

  final ResidenceModel residence;
  final bool showRating;

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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image de fond
              _buildBackgroundImage(),

              // Gradient overlay pour rendre le texte lisible
              _buildGradientOverlay(),

              // Rating en haut à gauche (optionnel)
              if (widget.showRating)
                Positioned(
                  top: 16,
                  left: 16,
                  child: RatingComponent(
                    rating: (widget.residence.score ?? 0).toDouble(),
                  ),
                ),

              // Badge de prix en haut à droite
              Positioned(
                top: 16,
                right: 16,
                child: _buildPriceBadge(context),
              ),

              // Informations en bas
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: _buildResidenceInfo(context),
              ),

              // Bouton favori en bas à droite
              Positioned(
                right: 16,
                bottom: 16,
                child: _buildFavoriteButton(),
              ),
            ],
          ),
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

  /// Badge de prix stylisé
  Widget _buildPriceBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text:
                  '${CurrencyFormatter().format(widget.residence.prixReservation.toString())} Fcfa',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            TextSpan(
              text: '/nuits',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Informations de la résidence
  Widget _buildResidenceInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nom de la résidence
        Text(
          widget.residence.nom.capitalizeFirst(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const Gap(8),
        // Localisation
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            const Gap(4),
            Expanded(
              child: Text(
                "${widget.residence.adresse}${widget.residence.communeModel?.name != null ? ', ${widget.residence.communeModel!.name}' : ''}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Bouton favori
  Widget _buildFavoriteButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _liked,
      builder: (context, isLiked, _) {
        return ResidenceFavoriteButton(
          isFavorite: isLiked,
          onTap: () async {
            if (_liked.value) {
              await favoriesUtils.deleteFavoriteByItemId(widget.residence.id);
            } else {
              await favoriesUtils.addResidenceToFavorites(widget.residence);
            }
            _liked.value = !isLiked;
          },
        );
      },
    );
  }
}
