import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/utils/ad_action_handler.dart';
import 'package:immoplus/app/widgets/ads/components/mosaic_items_gallery_page.dart';
import 'package:immoplus/app/widgets/image_collage.dart';

class AdCarouselVilleAdsCampaignCategory extends StatelessWidget {
  final AdCampaignModel campaign;

  const AdCarouselVilleAdsCampaignCategory({
    super.key,
    required this.campaign,
  });

  void _openMosaicGallery(BuildContext context, List<CollageItem> items) {
    context.push(
      MosaicItemsGalleryPage.routePath,
      extra: MosaicGalleryExtra(
        items: items,
        title: campaign.content.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = campaign.media.images;
    if (images.isEmpty) return const SizedBox.shrink();
    final title = campaign.content.title;
    final ctaLabel = campaign.content.ctaLabel?.isNotEmpty == true
        ? campaign.content.ctaLabel!
        : 'Voir tout';

    final items = List.generate(images.length, (index) {
      return CollageItem(
        image: images[index],
        onTap: () => AdActionHandler.handleCardAction(
          context,
          campaign,
          cardIndex: index,
        ),
      );
    });

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête : Titre à gauche, "Voir tout" à droite
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (title?.isNotEmpty == true)
                  Expanded(
                    child: Text(
                      title!,
                      style: GoogleFonts.dmSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F1E36),
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else
                  const Spacer(),
                GestureDetector(
                  onTap: () => _openMosaicGallery(context, items),
                  child: Text(
                    ctaLabel,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ImageCollage avec CollageItem
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              const collageHeight = 315.0;

              return Stack(
                children: [
                  ImageCollage(
                    items: items,
                    width: totalWidth,
                    height: collageHeight,
                    borderRadius: 20,
                    spacing: 8,
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => _openMosaicGallery(context, items),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
