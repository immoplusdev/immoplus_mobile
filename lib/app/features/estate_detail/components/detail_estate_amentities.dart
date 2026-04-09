import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/svgs_icons.dart';

class DetailEstateAmentities extends StatelessWidget {
  const DetailEstateAmentities({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;

  @override
  Widget build(BuildContext context) {
    if (bienImmobilier.amentities.isEmpty) return const SliverToBoxAdapter();

    // Show max 6 items in the overview
    final displayCount = bienImmobilier.amentities.length.clamp(0, 6);
    final rowCount = (displayCount / 2).ceil();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: appPadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final leftIdx = index * 2;
            final rightIdx = index * 2 + 1;

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leftIdx < displayCount)
                      Expanded(
                        child: _AmenityItem(
                          icon: bienImmobilier.amentities[leftIdx].icon,
                          text: bienImmobilier.amentities[leftIdx].text,
                        ),
                      )
                    else
                      const Expanded(child: SizedBox()),
                    const SizedBox(width: 12),
                    if (rightIdx < displayCount)
                      Expanded(
                        child: _AmenityItem(
                          icon: bienImmobilier.amentities[rightIdx].icon,
                          text: bienImmobilier.amentities[rightIdx].text,
                        ),
                      )
                    else
                      const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            );
          },
          childCount: rowCount,
        ),
      ),
    );
  }
}

class _AmenityItem extends StatelessWidget {
  const _AmenityItem({required this.icon, required this.text});
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final iconsaxIcon = SVGMap.iconsaxMap[icon];
    final svgPath = SVGMap.map[icon];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          if (iconsaxIcon != null)
            Icon(iconsaxIcon, size: 22, color: Colors.grey.shade700)
          else if (svgPath != null)
            SvgPicture.asset(
              svgPath,
              height: 22,
              width: 22,
              colorFilter: ColorFilter.mode(
                Colors.grey.shade700,
                BlendMode.srcIn,
              ),
            )
          else
            Icon(Iconsax.element_4, size: 22, color: Colors.grey.shade700),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3A3A3A),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
