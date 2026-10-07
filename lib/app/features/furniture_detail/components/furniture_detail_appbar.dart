import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/residence_detail/components/mosaic_logment_images.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/detail_flexible_carousel.dart';

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
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
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
                backgroundColor:
                    value ? AppColors.red : AppColors.immoBorderStrong,
                child: Icon(
                  FontAwesomeIcons.solidHeart.data,
                  size: 16,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: DetailFlexibleCarousel(
          images: widget.furnitureModel.images,
          onImageTap: (imageId) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MosaicLogmentImages(
                tag: imageId,
                imageUrls: widget.furnitureModel.images,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
