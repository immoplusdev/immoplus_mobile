import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/enums/relais_property_type.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_model.dart';
import 'package:immoplus/app/features/immo_relais/pages/relais_detail_page.dart';
import 'package:immoplus/app/features/immo_relais/widgets/express_interest_sheet.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';

/// Carte d'un relais découvert dans le Marketplace ("Autour de moi") — un
/// logement publié par quelqu'un d'autre, identité anonymisée côté
/// serveur. Photo pleine largeur + bouton "Je suis intéressé" direct sur
/// la carte (pas besoin d'ouvrir le détail pour agir).
class MarketplaceRelaisCard extends StatelessWidget {
  final RelaisModel relais;

  const MarketplaceRelaisCard({super.key, required this.relais});

  @override
  Widget build(BuildContext context) {
    final imageUrl = relais.photos.isNotEmpty ? Utils.getImagePath(id: relais.photos.first) : '';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.pushNamed(
        RelaisDetailPage.name,
        extra: RelaisDetailArgs(relais, false),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary, width: .2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: imageUrl.isEmpty
                  ? Container(
                      color: Colors.grey.shade100,
                      alignment: Alignment.center,
                      child: Icon(Icons.home_outlined, color: Colors.grey.shade400, size: 32),
                    )
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(color: Colors.grey.shade100),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${relaisPropertyTypeLabel(relais.propertyType)} · ${relais.rooms} ch.',
                    style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(2),
                  Text(
                    relais.location,
                    style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (relais.interestedCount > 0) ...[
                    const Gap(4),
                    Text(
                      '${relais.interestedCount} intéressé${relais.interestedCount > 1 ? 's' : ''}',
                      style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                  const Gap(8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => showExpressRelaisInterestSheet(context, relaisId: relais.id),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        'Je suis intéressé',
                        style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
