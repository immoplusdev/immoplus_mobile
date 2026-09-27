import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/home_feed/for_you_bien_item.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

/// Carte bien immobilier pour les carousels de la home agrégée — même
/// gabarit visuel que `CompactBienCard`, construite à partir du résumé
/// léger `ForYouBienItem`.
class ForYouBienTile extends StatelessWidget {
  final ForYouBienItem bien;

  const ForYouBienTile({super.key, required this.bien});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: neirResidenceCardWidth,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('/estate_detail/${bien.bienId}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: double.infinity,
                height: 170,
                child: _buildImage(),
              ),
            ),
            const Gap(8),
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = bien.imageUrl != null ? Utils.getImagePath(id: bien.imageUrl!) : '';
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: 600,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        period: const Duration(milliseconds: 500),
        child: Container(color: Colors.white),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade200,
        child: Center(
          child: FaIcon(FontAwesomeIcons.images, size: 60, color: Colors.grey.shade400),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          bien.name,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (bien.location != null) ...[
          const Gap(3),
          Text(
            bien.location!,
            style: GoogleFonts.plusJakartaSans(color: Colors.grey.shade600, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const Gap(12),
        if (bien.price != null)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${CurrencyFormatter().format(bien.price.toString())} ${bien.currency ?? "Fcfa"}',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                if (bien.aLouer)
                  TextSpan(
                    text: '/mois',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w200,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
