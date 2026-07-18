import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/residence_detail/components/mosaic_logment_images.dart';
import 'package:immoplus/app/services/share_service.dart';
import 'package:immoplus/app/widgets/circle_button.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/detail_flexible_carousel.dart';

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
          (value) => _liked.value = value,
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
      expandedHeight: 300,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleButton(
          icon: CupertinoIcons.chevron_back,
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(HomePage.name);
            }
          },
        ),
      ),
      actions: [
        // Share button
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: CircleButton(
            key: _shareButtonKey,
            icon: Iconsax.send_2,
            onTap: () async {
              final origin =
                  ShareService.getSharePositionFromKey(_shareButtonKey);
              await ShareService.shareResidence(
                residenceId: widget.logmentModel.id,
                context: context,
                sharePositionOrigin: origin,
              );
              getIt<AnalyticsService>().logResidenceShared(residenceId: widget.logmentModel.id);
            },
          ),
        ),
        // Favorite button
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ValueListenableBuilder(
            valueListenable: _liked,
            builder: (context, liked, _) => CircleButton(
              icon: liked ? Iconsax.heart5 : Iconsax.heart,
              iconColor: liked ? Colors.red : null,
              onTap: () {
                if (!_liked.value) {
                  favoriesUtils.addResidenceToFavorites(widget.logmentModel);
                } else {
                  favoriesUtils.deleteFavoriteByItemId(widget.logmentModel.id);
                }
                _liked.value = !liked;
              },
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: DetailFlexibleCarousel(
          images: widget.logmentModel.images,
          onImageTap: (imageId) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MosaicLogmentImages(
                tag: imageId,
                imageUrls: widget.logmentModel.images,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

