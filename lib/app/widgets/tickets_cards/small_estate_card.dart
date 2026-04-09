import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/utils/immo_icons.dart';
import 'package:immoplus/app/widgets/custom_chip.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/rating_component.dart';
import 'package:shimmer/shimmer.dart';

class SmallEstateCard extends StatefulWidget {
  const SmallEstateCard(
      {super.key, required this.bienImmobilier, this.closeTap, this.onCardTap});
  final BienImmobilierModel bienImmobilier;
  final VoidCallback? closeTap;
  final VoidCallback? onCardTap;
  @override
  State<SmallEstateCard> createState() => _SmallEstateCardState();
}

class _SmallEstateCardState extends State<SmallEstateCard> {
  final favoriesUtils = getIt<FavoriesUtils>();

  final ValueNotifier<bool> _liked = ValueNotifier(false);
  @override
  void initState() {
    favoriesUtils.isFavorite(widget.bienImmobilier.id).then(
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
        Positioned.fill(
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: widget.onCardTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    spreadRadius: 2,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      //height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CachedNetworkImage(
                              imageUrl: Utils.getImagePath(
                                  id: widget.bienImmobilier.images.first),
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
                              errorWidget: (context, url, error) => SizedBox(
                                height: double.infinity,
                                child: Center(
                                  child: Icon(
                                    FontAwesomeIcons.images,
                                    size: 100,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                              fit: BoxFit.cover, // Ajuste l'image au conteneur
                            ),
                          ),
                          Positioned(
                            left: 10,
                            top: 8,
                            child: ValueListenableBuilder(
                              valueListenable: _liked,
                              builder: (context, value, child) =>
                                  GestureDetector(
                                onTap: () {
                                  if (_liked.value == false) {
                                    favoriesUtils
                                        .addEstateToFavorites(
                                            widget.bienImmobilier)
                                        .then((value) {});
                                  } else {
                                    favoriesUtils.deleteFavoriteByItemId(
                                        widget.bienImmobilier.id);
                                  }
                                  _liked.value = !value;
                                },
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor:
                                      value ? Colors.red : Colors.grey.shade300,
                                  child: const Icon(
                                    FontAwesomeIcons.solidHeart,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            bottom: 10,
                            child: CustomChip(
                              label: widget.bienImmobilier.typeBienImmobilier,
                              labelStyle:
                                  Theme.of(context).textTheme.labelMedium,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          widget.bienImmobilier.nom,
                          maxLines: 3,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.grey.shade600),
                        ),
                        const Gap(8),
                        const RatingComponent(rating: 5),
                        const Gap(5),
                        Flexible(
                          child: Row(
                            children: [
                              const ImmoIcon(
                                ImmoIcons.marker,
                                color: Colors.black,
                                size: 10,
                              ),
                              const Gap(3),
                              Expanded(
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  widget.bienImmobilier.adresse,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.grey.shade600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: GestureDetector(
            onTap: widget.closeTap,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blueGrey),
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
