import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/residence_detail/components/mosaic_logment_images.dart';
import 'package:immoplus/app/services/share_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/detail_flexible_carousel.dart';

class DetailEstateAppBar extends StatefulWidget {
  const DetailEstateAppBar({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;
  @override
  State<DetailEstateAppBar> createState() => _DetailEstateAppBarState();
}

class _DetailEstateAppBarState extends State<DetailEstateAppBar> {
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

  final GlobalKey _shareButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      //toolbarHeight: 300,
      expandedHeight: 280.0,
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 20,
          onPressed: () {
            if (kDebugMode) {
              print(Constantes.tempPage);
            }
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
          child: IconButton(
            padding: EdgeInsets.zero,
            key: _shareButtonKey,
            iconSize: 20,
            onPressed: () async {
              final origin =
                  ShareService.getSharePositionFromKey(_shareButtonKey);
              await ShareService.shareBien(
                bienId: widget.bienImmobilier.id,
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
                  favoriesUtils.addEstateToFavorites(widget.bienImmobilier);
                } else {
                  favoriesUtils
                      .deleteFavoriteByItemId(widget.bienImmobilier.id);
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
        background: DetailFlexibleCarousel(
          images: widget.bienImmobilier.images,
          onImageTap: (imageId) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MosaicLogmentImages(
                tag: imageId,
                imageUrls: widget.bienImmobilier.images,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
