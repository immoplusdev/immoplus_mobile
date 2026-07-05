import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/widgets/recommande_badge.dart';
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

  bool get hasWifi {
    final list = item is ResidenceModel
        ? (item as ResidenceModel).commodites
        : (item as BienImmobilierModel).amentities;
    return list.any((c) =>
        c.icon.toLowerCase().contains('wifi') ||
        c.text.toLowerCase().contains('wifi'));
  }

  bool get hasAc {
    final list = item is ResidenceModel
        ? (item as ResidenceModel).commodites
        : (item as BienImmobilierModel).amentities;
    return list.any((c) =>
        c.icon.toLowerCase().contains('ac') ||
        c.text.toLowerCase().contains('clim'));
  }

  String get priceText => Utils.formatCurrency(price);

  String get priceSuffix {
    if (isResidence) return '/nuit';
    if (item is BienImmobilierModel) {
      final b = item as BienImmobilierModel;
      return b.aLouer ? '/mois' : '';
    }
    return '';
  }

  String get durationText {
    if (isResidence) {
      // Formats stay info or default stay dates
      final min = (item as ResidenceModel).dureeMinSejour;
      return min > 0 ? "Min. $min nuits" : "Flexible";
    }
    if (item is BienImmobilierModel) {
      final b = item as BienImmobilierModel;
      return b.aLouer ? "Location" : "Vente";
    }
    return "Disponible";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100, width: 1),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
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

                    // Icons row (Wifi, Air conditioning, Guests)
                    Row(
                      children: [
                        if (hasWifi) ...[
                          Icon(Icons.wifi_rounded,
                              size: 14, color: Colors.grey.shade700),
                          const Gap(8),
                        ],
                        if (hasAc) ...[
                          Icon(Icons.air_rounded,
                              size: 14, color: Colors.grey.shade700),
                          const Gap(8),
                        ],
                        Icon(Icons.people_outline_rounded,
                            size: 14, color: Colors.grey.shade700),
                        const Gap(4),
                        Text(
                          '$maxOccupants',
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 13),
                        ),
                      ],
                    ),

                    const Gap(10),

                    const RecommandeBadge(),

                    const Gap(12),

                    // Divider
                    Divider(height: 1, color: Colors.grey.shade200),

                    const Gap(10),

                    // Bottom Row: Date / Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Text(
                            durationText,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Gap(8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              priceText,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
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
                      ],
                    ),
                  ],
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
        width: 130,
        height: 130,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: _buildImageWidget(''),
        ),
      );
    }

    if (images.length == 1) {
      return SizedBox(
        width: 130,
        height: 130,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: _buildImageWidget(images[0]),
        ),
      );
    }

    if (images.length == 2) {
      return SizedBox(
        width: 130,
        height: 130,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
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
      width: 130,
      height: 130,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
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
}
