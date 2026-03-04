import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
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
import 'package:immoplus/app/utils/immo_icons.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/small_button.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/rating_component.dart';
import 'package:shimmer/shimmer.dart';

class ResidenceCard extends StatefulWidget {
  const ResidenceCard({super.key, required this.residence});
  final ResidenceModel residence;

  @override
  State<ResidenceCard> createState() => _ResidenceCardState();
}

class _ResidenceCardState extends State<ResidenceCard> {
  final favoriesUtils = getIt<FavoriesUtils>();

  final ValueNotifier<bool> _liked = ValueNotifier(false);
  @override
  void initState() {
    favoriesUtils.isFavorite(widget.residence.id).then(
      (value) {
        _liked.value = value;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Constantes.tempPage = Utils.getCurrentLocation();

            context.push(ResidencePage.route(widget.residence.id),
                extra: widget.residence);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: AspectRatio(
                      aspectRatio: 1.70, // Rectangle paysage
                      child: FlutterCarousel(
                        items: widget.residence.images
                            .map((e) => Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: Utils.getImagePath(id: e),
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      period: const Duration(milliseconds: 500),
                                      child: Container(
                                        color: Colors.white,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      FontAwesomeIcons.images,
                                      size: 100,
                                      color: Colors.grey.shade400,
                                    ),
                                    fit: BoxFit
                                        .cover, // Ajuste l'image au conteneur
                                  ),
                                ))
                            .toList(),
                        options: FlutterCarouselOptions(
                          aspectRatio: 1, // Assure le rectangle paysage
                          viewportFraction:
                              1.0, // Pas de découpage ou chevauchement
                          initialPage: 0,
                          enableInfiniteScroll: widget.residence.images.length > 1,

                          reverse: false,
                          autoPlay: false,
                          enlargeCenterPage: false,
                          scrollDirection: Axis.horizontal,
                          showIndicator: true,
                          indicatorMargin: 20,
                          slideIndicator: CircularSlideIndicator(
                            slideIndicatorOptions: const SlideIndicatorOptions(
                              indicatorRadius: 4,
                              enableHalo: true,
                              enableAnimation: true,
                              itemSpacing: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 10,
                  //   right: 10,
                  //   child: RatingComponent(
                  //       rating: (widget.residence.score ?? 0).toDouble()),
                  // )
                ],
              ),
              Gap(10),
              Container(
                //color: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.residence.nom.capitalizeFirst(),
                            overflow: TextOverflow.fade,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Gap(5),
                          Row(
                            children: [
                              const ImmoIcon(
                                ImmoIcons.marker,
                                size: 10,
                              ),
                              const Gap(3),
                              Flexible(
                                child: Text(
                                  maxLines: maxLineAdress,
                                  overflow: TextOverflow.clip,
                                  // TODO Add commune
                                  "${widget.residence.adresse} ${widget.residence.communeModel?.name ?? ""}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.grey.shade600),
                                ),
                              ),
                            ],
                          ),
                          Gap(5),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text:
                                  "${CurrencyFormatter().format(widget.residence.prixReservation.toString())} Fcfa",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                            ),
                            TextSpan(
                              text: '/nuitée',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )
                          ]))
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Gap(10),
                          SmallButton(text: "Réserver"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: ValueListenableBuilder(
            valueListenable: _liked,
            builder: (context, value, child) => ResidenceFavoriteButton(
              isFavorite: value,
              onTap: () async {
                if (_liked.value == false) {
                  favoriesUtils
                      .addResidenceToFavorites(widget.residence)
                      .then((value) {});
                } else {
                  favoriesUtils.deleteFavoriteByItemId(widget.residence.id);
                }
                _liked.value = !value;
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ResidenceFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  const ResidenceFavoriteButton(
      {super.key, required this.isFavorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: isFavorite ? Colors.red : Colors.grey.shade300,
        child: const Icon(
          FontAwesomeIcons.solidHeart,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
