import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/residence_detail/components/mosaic_logment_images.dart';
import 'package:immoplus/app/services/share_service.dart';
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
        child: _CircleButton(
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
          child: _CircleButton(
            key: _shareButtonKey,
            icon: Iconsax.send_2,
            onTap: () async {
              final origin =
                  ShareService.getSharePositionFromKey(_shareButtonKey);
              await ShareService.shareBien(
                bienId: widget.bienImmobilier.id,
                sharePositionOrigin: origin,
              );
            },
          ),
        ),
        // Favorite button
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ValueListenableBuilder(
            valueListenable: _liked,
            builder: (context, liked, _) => _CircleButton(
              icon: liked ? Iconsax.heart5 : Iconsax.heart,
              iconColor: liked ? Colors.red : null,
              onTap: () {
                if (!_liked.value) {
                  favoriesUtils.addEstateToFavorites(widget.bienImmobilier);
                } else {
                  favoriesUtils
                      .deleteFavoriteByItemId(widget.bienImmobilier.id);
                }
                _liked.value = !liked;
              },
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

// ─── Reusable circle button for AppBar ──────────────────────────────────────
class _CircleButton extends StatelessWidget {
  const _CircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? const Color(0xFF222222),
        ),
      ),
    );
  }
}
