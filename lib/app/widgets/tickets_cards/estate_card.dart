import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/extensions/string_extension.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/immo_icons.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/small_button.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/rating_component.dart';
import 'package:shimmer/shimmer.dart';

class EstateCard extends StatefulWidget {
  const EstateCard({super.key, required this.bienImmobilierModel});
  final BienImmobilierModel bienImmobilierModel;

  @override
  State<EstateCard> createState() => _EstateCardState();
}

class _EstateCardState extends State<EstateCard> {
  final favoriesUtils = getIt<FavoriesUtils>();

  final ValueNotifier<bool> _liked = ValueNotifier(false);
  @override
  void initState() {
    favoriesUtils.isFavorite(widget.bienImmobilierModel.id).then(
      (value) {
        _liked.value = value;
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      //color: Colors.grey,
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Constantes.tempPage = Utils.getCurrentLocation();
              context.push('/estate_detail/${widget.bienImmobilierModel.id}');
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: AspectRatio(
                        aspectRatio: 1.70, // Rectangle paysage
                        child: FlutterCarousel(
                            items: widget.bienImmobilierModel.images
                                .map((e) => Container(
                                      color: Colors.grey.shade200,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: Utils.getImagePath(
                                            id: e), //https://pbs.twimg.com/profile_banners/1444928438331224069/1633448972/600x200

                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey.shade100,
                                          period:
                                              const Duration(milliseconds: 500),
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: Colors.white,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          FontAwesomeIcons.images,
                                          size: 100,
                                          color: Colors.grey.shade400,
                                        ),
                                        fit: BoxFit
                                            .cover, // or other BoxFit values as per your design
                                      ),
                                    ))
                                .toList(),
                            options: FlutterCarouselOptions(
                              //height: 240.0,
                              aspectRatio: 1,
                              viewportFraction: 1.0,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: false,
                              autoPlayInterval: const Duration(seconds: 2),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: false,
                              controller: FlutterCarouselController(),
                              onPageChanged: (e, x) {},
                              pageSnapping: true,
                              scrollDirection: Axis.horizontal,
                              pauseAutoPlayOnTouch: true,
                              pauseAutoPlayOnManualNavigate: true,
                              pauseAutoPlayInFiniteScroll: false,
                              enlargeStrategy: CenterPageEnlargeStrategy.scale,
                              disableCenter: false,
                              showIndicator: true,
                              indicatorMargin: 20,
                              slideIndicator: CircularSlideIndicator(
                                  slideIndicatorOptions:
                                      const SlideIndicatorOptions(
                                //currentIndicatorColor: Colors.red,
                                indicatorRadius: 4,

                                enableHalo: true,
                                enableAnimation: true,
                                itemSpacing: 12,
                              )
                                  // indicatorRadius: 3,
                                  // itemSpacing: 10,
                                  ),
                              floatingIndicator: true,
                            )),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: RatingComponent(rating: 5),
                    )
                  ],
                ),
                Gap(10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.bienImmobilierModel.nom.capitalizeFirst(),
                              overflow: TextOverflow.fade,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Gap(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const Icon(
                                //   Icons.location_on_outlined,
                                //   size: 20,
                                // ),
                                Flexible(
                                  child: Row(
                                    children: [
                                      const ImmoIcon(
                                        ImmoIcons.marker,
                                        size: 10,
                                      ),
                                      const Gap(3),
                                      Expanded(
                                        child: Text(
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          widget.bienImmobilierModel.adresse,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Colors.grey.shade600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gap(5),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: Utils.formatCurrency(
                                    widget.bienImmobilierModel.prix),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: AppColors.primary),
                              ),
                              TextSpan(
                                  text:
                                      "/ ${widget.bienImmobilierModel.typeLocation}",
                                  style: TextStyle(color: Colors.grey.shade600))
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
                            SmallButton(text: "Visiter"),
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
              builder: (context, value, child) => GestureDetector(
                onTap: () {
                  if (_liked.value == false) {
                    favoriesUtils
                        .addEstateToFavorites(widget.bienImmobilierModel)
                        .then((value) {});
                  } else {
                    favoriesUtils
                        .deleteFavoriteByItemId(widget.bienImmobilierModel.id);
                  }
                  _liked.value = !value;
                },
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: value ? Colors.red : Colors.grey.shade300,
                  child: const Icon(
                    FontAwesomeIcons.solidHeart,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
