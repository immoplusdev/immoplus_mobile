import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/residence_detail/components/mosaic_logment_images.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class FurnitureDetailAppBar extends StatefulWidget {
  const FurnitureDetailAppBar({super.key, required this.furnitureModel});
  final FurnitureModel furnitureModel;
  @override
  State<FurnitureDetailAppBar> createState() => _FurnitureDetailAppBarState();
}

final favoriesUtils = getIt<FavoriesUtils>();

class _FurnitureDetailAppBarState extends State<FurnitureDetailAppBar> {
  final ValueNotifier<bool> _liked = ValueNotifier(false);
  @override
  void initState() {
    favoriesUtils.isFavorite(widget.furnitureModel.id).then(
      (value) {
        _liked.value = value;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      expandedHeight: 260.0,
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 20,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(HomePage.name);
            }
          },
          style: IconButton.styleFrom(
            iconSize: 20,
            fixedSize: const Size(18, 18),
            padding: EdgeInsets.zero,
          ),
          icon: Container(
              width: 30,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: Center(
                  child: Icon(
                CupertinoIcons.chevron_back,
                color: AppColors.primary,
              ))),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ValueListenableBuilder(
            valueListenable: _liked,
            builder: (context, value, child) => GestureDetector(
              onTap: () {
                if (_liked.value == false) {
                  favoriesUtils
                      .addFurnitureToFavorites(widget.furnitureModel)
                      .then((value) {});
                } else {
                  favoriesUtils
                      .deleteFavoriteByItemId(widget.furnitureModel.id);
                }
                _liked.value = !value;
              },
              child: CircleAvatar(
                radius: 15,
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
      flexibleSpace: FlexibleSpaceBar(
        background: FlutterCarousel(
            items: widget.furnitureModel.images
                .map<Widget>(
                  (e) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MosaicLogmentImages(
                              tag: e,
                              imageUrls: widget.furnitureModel.images,
                            ),
                          ));
                    },
                    child: Hero(
                      tag: e,
                      child: Container(
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade700,
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0, 0.4],
                          ),
                        ),
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: Utils.getImagePath(id: e),
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade400,
                            period: const Duration(milliseconds: 500),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            options: FlutterCarouselOptions(
              aspectRatio: 1,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: widget.furnitureModel.images.length > 1,
              reverse: false,
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 2),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
                  slideIndicatorOptions: const SlideIndicatorOptions(
                indicatorRadius: 4,
                enableHalo: true,
                enableAnimation: true,
                itemSpacing: 12,
              )),
              floatingIndicator: true,
            )),
      ),
    );
  }
}
