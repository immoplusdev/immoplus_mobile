import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/residence_detail/components/mosaic_logment_images.dart';
import 'package:immoplus/app/services/share_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class DetailLogmentAppBar extends StatefulWidget {
  const DetailLogmentAppBar({super.key, required this.logmentModel});
  final ResidenceModel logmentModel;
  @override
  State<DetailLogmentAppBar> createState() => _DetailLogmentAppBarState();
}

final favoriesUtils = getIt<FavoriesUtils>();

class _DetailLogmentAppBarState extends State<DetailLogmentAppBar> {
  final ValueNotifier<bool> _liked = ValueNotifier(false);
  @override
  void initState() {
    favoriesUtils.isFavorite(widget.logmentModel.id).then(
      (value) {
        _liked.value = value;
      },
    );
    super.initState();
  }

  final GlobalKey _shareButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      //toolbarHeight: 300,
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            key: _shareButtonKey,
            padding: EdgeInsets.zero,
            iconSize: 20,
            onPressed: () async {
              final origin =
                  ShareService.getSharePositionFromKey(_shareButtonKey);
              await ShareService.shareResidence(
                residenceId: widget.logmentModel.id,
                context: context,
                sharePositionOrigin: origin,
              );
            },
            style: IconButton.styleFrom(
              iconSize: 25,
              fixedSize: const Size(18, 18),
              padding: EdgeInsets.zero,
            ),
            icon: Container(
              width: 30,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: Center(
                child: Icon(
                  CupertinoIcons.share,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ValueListenableBuilder(
            valueListenable: _liked,
            builder: (context, value, child) => GestureDetector(
              onTap: () {
                if (_liked.value == false) {
                  favoriesUtils
                      .addResidenceToFavorites(widget.logmentModel)
                      .then((value) {});
                } else {
                  favoriesUtils.deleteFavoriteByItemId(widget.logmentModel.id);
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
        //title: Text('SliverAppBar'),
        background: FlutterCarousel(
            items: widget.logmentModel.images
                .map<Widget>(
                  (e) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MosaicLogmentImages(
                              tag: e,
                              imageUrls: widget.logmentModel.images,
                            ),
                          ));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ViewerImage(
                      //           tag: e.directusFilesId!,
                      //           url: Utils.getImagePath(id: e.directusFilesId!)),
                      //     ));
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
                          imageUrl: Utils.getImagePath(
                              id: e), //https://pbs.twimg.com/profile_banners/1444928438331224069/1633448972/600x200

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
                          fit: BoxFit
                              .cover, // or other BoxFit values as per your design
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            options: FlutterCarouselOptions(
              //height: 240.0,
              aspectRatio: 1,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: widget.logmentModel.images.length > 1,
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
    );
  }
}
