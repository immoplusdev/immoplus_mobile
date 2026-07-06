import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/widgets/recommande_badge.dart';
import 'package:immoplus/svgs_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';

class SuggestResultCard extends StatelessWidget {
  final dynamic item; // Can be ResidenceModel or BienImmobilierModel

  const SuggestResultCard({super.key, required this.item})
      : assert(item is ResidenceModel || item is BienImmobilierModel);

  String get name => item is ResidenceModel
      ? (item as ResidenceModel).nom
      : (item as BienImmobilierModel).nom;

  String get location => item is ResidenceModel
      ? ((item as ResidenceModel).communeModel?.name ??
          (item as ResidenceModel).adresse)
      : ((item as BienImmobilierModel).communeModel?.name ??
          (item as BienImmobilierModel).adresse);

  List<String> get images {
    final rawList = item is ResidenceModel
        ? (item as ResidenceModel).images
        : (item as BienImmobilierModel).images;
    return rawList.where((img) {
      final s = img.trim().toLowerCase();
      return s.isNotEmpty && s != 'string' && s != 'null' && s != 'undefined';
    }).toList();
  }

  int get maxOccupants => item is ResidenceModel
      ? (item as ResidenceModel).nombreMaxOccupants
      : ((item as BienImmobilierModel).nombreMaxOccupants ?? 0);

  int get price => item is ResidenceModel
      ? (item as ResidenceModel).prixReservation
      : (item as BienImmobilierModel).prix;

  bool get isResidence => item is ResidenceModel;

  String get priceText => Utils.formatCurrency(price);

  String get priceSuffix {
    if (isResidence) return '/nuit';
    if (item is BienImmobilierModel) {
      final b = item as BienImmobilierModel;
      return b.aLouer ? '/mois' : '';
    }
    return '';
  }

  String get formattedDuration {
    if (isResidence) {
      final now = DateTime.now();
      final min = (item as ResidenceModel).dureeMinSejour;
      final duration = min > 0 ? min : 1;
      final end = now.add(Duration(days: duration));

      const frenchMonths = [
        'janv.',
        'févr.',
        'mars',
        'avr.',
        'mai',
        'juin',
        'juil.',
        'août',
        'sept.',
        'oct.',
        'nov.',
        'déc.'
      ];

      if (now.month == end.month) {
        return "${now.day}-${end.day} ${frenchMonths[now.month - 1]}";
      } else {
        return "${now.day} ${frenchMonths[now.month - 1]} - ${end.day} ${frenchMonths[end.month - 1]}";
      }
    }
    if (item is BienImmobilierModel) {
      final b = item as BienImmobilierModel;
      return b.aLouer ? "Location" : "Vente";
    }
    return "Disponible";
  }

  // String get durationText {
  //   if (isResidence) {
  //     // Formats stay info or default stay dates
  //     final min = (item as ResidenceModel).dureeMinSejour;
  //     return min > 0 ? "Min. $min nuits" : "Flexible";
  //   }
  //   if (item is BienImmobilierModel) {
  //     final b = item as BienImmobilierModel;
  //     return b.aLouer ? "Location" : "Vente";
  //   }
  //   return "Disponible";
  // }

  @override
  Widget build(BuildContext context) {
    final list = item is ResidenceModel
        ? (item as ResidenceModel).commodites
        : (item as BienImmobilierModel).amentities;
    final displayList = list.take(3).toList();

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Constantes.tempPage = Utils.getCurrentLocation();
          if (isResidence) {
            context.push(ResidencePage.route((item as ResidenceModel).id),
                extra: item);
          } else {
            context.push('/estate_detail/${(item as BienImmobilierModel).id}');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Image Collage (strictly 3 images)
              _buildImageCollage(images),

              const Gap(14),

              // Right Info Details
              Expanded(
                child: SizedBox(
                  height: SuggestCardConstants.imageSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        name,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const Gap(2),

                      // Location / Commune
                      Text(
                        location,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const Gap(6),

                      // Icons row (first 3 amenities/commodities)
                      Row(
                        children: [
                          for (int i = 0; i < displayList.length; i++) ...[
                            _buildAmenityIcon(displayList[i].icon),
                            if (i < displayList.length - 1) const Gap(8),
                          ],
                        ],
                      ),

                      const Spacer(),

                      const RecommandeBadge(),

                      // Divider
                      const Gap(8),
                      Divider(height: 1, color: Colors.grey.withOpacity(.4)),
                      const Gap(8),
                      // Bottom Row: Date / Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            formattedDuration,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13),
                          ),
                          const Gap(8),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Flexible(
                                  child: Text(
                                    priceText,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (priceSuffix.isNotEmpty)
                                  Text(
                                    priceSuffix,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCollage(List<String> images) {
    if (images.isEmpty) {
      return SizedBox(
        width: SuggestCardConstants.imageSize,
        height: SuggestCardConstants.imageSize,
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(SuggestCardConstants.borderRadius),
          child: _buildImageWidget(''),
        ),
      );
    }

    if (images.length == 1) {
      return SizedBox(
        width: SuggestCardConstants.imageSize,
        height: SuggestCardConstants.imageSize,
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(SuggestCardConstants.borderRadius),
          child: _buildImageWidget(images[0]),
        ),
      );
    }

    if (images.length == 2) {
      return SizedBox(
        width: SuggestCardConstants.imageSize,
        height: SuggestCardConstants.imageSize,
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(SuggestCardConstants.borderRadius),
          child: Column(
            children: [
              Expanded(child: _buildImageWidget(images[0])),
              const Gap(2),
              Expanded(child: _buildImageWidget(images[1])),
            ],
          ),
        ),
      );
    }

    // 3 or more images
    final img1 = images[0];
    final img2 = images[1];
    final img3 = images[2];

    return Container(
      width: SuggestCardConstants.imageSize,
      height: SuggestCardConstants.imageSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SuggestCardConstants.borderRadius),
        child: Column(
          children: [
            // Top large image
            Expanded(
              child: _buildImageWidget(img1),
            ),
            const Gap(2),
            // Bottom row (two smaller images)
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildImageWidget(img2)),
                  const Gap(2),
                  Expanded(child: _buildImageWidget(img3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imageId) {
    if (imageId.isEmpty) {
      return Container(
        color: Colors.grey.shade100,
        child: const Icon(Icons.image_outlined, color: Colors.grey, size: 20),
      );
    }
    return CachedNetworkImage(
      imageUrl: Utils.getImagePath(id: imageId),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Container(
        color: Colors.grey.shade100,
        child: const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.broken_image_outlined,
          color: Colors.grey,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildAmenityIcon(String iconKey) {
    final iconsaxIcon = SVGMap.iconsaxMap[iconKey];
    final svgPath = SVGMap.map[iconKey];

    if (iconsaxIcon != null) {
      return Icon(
        iconsaxIcon,
        size: 15,
        color: Colors.grey.shade700,
      );
    } else if (svgPath != null) {
      return SvgPicture.asset(
        svgPath,
        height: 15,
        width: 15,
        colorFilter: ColorFilter.mode(
          Colors.grey.shade700,
          BlendMode.srcIn,
        ),
      );
    } else {
      return Icon(Iconsax.element_4, size: 15, color: Colors.grey.shade700);
    }
  }
}

class SuggestCardConstants {
  static const double imageSize = 170.0;
  static const double borderRadius = 14.0;
}
