import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_match_model.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/immo_relais/widgets/express_interest_sheet.dart';
import 'package:immoplus/app/widgets/small_button.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Une entrée de `GET /alerts/:id/matches` : soit un bien pro
/// (`type: "bien"`, navigue vers `EstatePage`), soit un relais
/// (`type: "relais"` — un logement qu'un autre utilisateur libère). Ce 2e
/// cas n'a pas de fiche bien à visiter : l'action est d'exprimer un
/// intérêt (`POST /relais/:id/interests`), pas de naviguer avec l'id du
/// relais comme si c'était un id de bien.
class PropositionCard extends StatelessWidget {
  final AlertMatchModel property;
  const PropositionCard({super.key, required this.property});

  bool get _isRelais => property.type == 'relais';

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
        locale: 'fr_FR', symbol: 'fcfa', decimalDigits: 0);

    return GestureDetector(
      onTap: _isRelais
          ? null
          : () {
              context.pushNamed(
                EstatePage.name,
                pathParameters: {'idProduct': property.id},
              );
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: property.miniature ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[200]),
                    errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade100, child: Icon(Iconsax.image)),
                  ),
                  if (_isRelais)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Immo Relais',
                          style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Gap(12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.nom,
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.grey),
                        const Gap(4),
                        Expanded(
                          child: Text(
                            property.location,
                            style: GoogleFonts.dmSans(
                                fontSize: 13, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Gap(4),
                    if (property.prix > 0)
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: currencyFormat.format(property.prix),
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ' / mois',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _isRelais
                    ? showExpressRelaisInterestSheet(context, relaisId: property.id)
                    : context.pushNamed(
                        EstatePage.name,
                        pathParameters: {'idProduct': property.id},
                      ),
                child: SmallButton(
                  text: _isRelais ? 'Je suis intéressé' : 'Visiter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
