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
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/furniture_detail/furniture_detail_page.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/widgets/image_collage.dart';

class UnifiedPropertyCard extends StatelessWidget {
  final dynamic
      item; // Can be ResidenceModel, BienImmobilierModel or FurnitureModel
  final VoidCallback? onTap;

  const UnifiedPropertyCard({
    super.key,
    required this.item,
    this.onTap,
  }) : assert(item is ResidenceModel ||
            item is BienImmobilierModel ||
            item is FurnitureModel);

  String get name => switch (item) {
        ResidenceModel r => r.nom,
        BienImmobilierModel b => b.nom,
        FurnitureModel f => f.titre,
        _ => '',
      };

  String get location => switch (item) {
        ResidenceModel r => r.communeModel?.name ?? r.adresse,
        BienImmobilierModel b => b.communeModel?.name ?? b.adresse,
        FurnitureModel f => f.communeModel?.name ?? f.adresse,
        _ => '',
      };

  List<String> get images {
    final rawList = switch (item) {
      ResidenceModel r => r.images,
      BienImmobilierModel b => b.images,
      FurnitureModel f => f.images,
      _ => <String>[],
    };
    return rawList.where((img) {
      final s = img.trim().toLowerCase();
      return s.isNotEmpty && s != 'string' && s != 'null' && s != 'undefined';
    }).toList();
  }

  int get price => switch (item) {
        ResidenceModel r => r.prixReservation,
        BienImmobilierModel b => b.prix,
        FurnitureModel f => f.prix,
        _ => 0,
      };

  bool get isResidence => item is ResidenceModel;
  bool get isFurniture => item is FurnitureModel;

  bool get hasReduction => isResidence && (item as ResidenceModel).hasReduction;

  /// Prix effectivement affiché en avant (réduit si une réduction existe).
  int get displayPrice =>
      hasReduction ? (item as ResidenceModel).prixReduit : price;

  String _formatPrice(int value) {
    if (value >= 1000000000) {
      final double val = value / 1000000000;
      final cleanVal =
          val.toStringAsFixed(val.truncateToDouble() == val ? 0 : 1);
      return "$cleanVal Mrd F";
    } else if (value >= 1000000) {
      final double val = value / 1000000;
      final cleanVal =
          val.toStringAsFixed(val.truncateToDouble() == val ? 0 : 1);
      return "$cleanVal M F";
    }
    return Utils.formatCurrency(value);
  }

  String get priceText => _formatPrice(displayPrice);

  /// Prix normal (barré), affiché uniquement quand une réduction est active.
  String get originalPriceText => _formatPrice(price);

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
    if (isFurniture) return "Meubles";
    return "Disponible";
  }

  @override
  Widget build(BuildContext context) {
    final list = switch (item) {
      ResidenceModel r => r.commodites,
      BienImmobilierModel b => b.amentities,
      _ => const [],
    };
    final displayList = list.take(3).toList();

    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
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
        onTap: onTap ?? () {
          Constantes.tempPage = Utils.getCurrentLocation();
          if (isResidence) {
            context.push(ResidencePage.route((item as ResidenceModel).id),
                extra: item);
          } else if (isFurniture) {
            context.push(FurnitureDetailPage.route((item as FurnitureModel).id),
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
              // Left Image Collage
              ImageCollage(
                images: images,
                width: SuggestCardConstants.imageSize,
                height: SuggestCardConstants.imageSize,
                borderRadius: SuggestCardConstants.borderRadius,
              ),

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
                        name.capitalize(),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                        maxLines: 2,
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
                                color: Colors.grey.shade600, fontSize: 11),
                          ),
                          const Gap(8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (hasReduction)
                                  Text(
                                    originalPriceText,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        priceText,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: hasReduction
                                              ? Colors.redAccent
                                              : Colors.black,
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
