import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:immoplus/app/data/enums/relais_property_type.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_model.dart';
import 'package:immoplus/app/features/immo_relais/pages/relais_detail_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

/// Carte résumé d'un relais existant, dans la liste `GET /relais` de
/// l'onglet "Je déménage". Tap → `RelaisDetailPage` (`GET /relais/:id`).
class RelaisCard extends StatelessWidget {
  final RelaisModel relais;
  final VoidCallback? onChanged;

  const RelaisCard({super.key, required this.relais, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final status = relais.statusEnum;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final result = await context.pushNamed(RelaisDetailPage.name, extra: relais);
        if (result == true) onChanged?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary, width: .2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${relaisPropertyTypeLabel(relais.propertyType)} · ${relais.rooms} chambre${relais.rooms > 1 ? 's' : ''}',
                        style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const Gap(2),
                      Text(
                        relais.landmark ?? relais.location,
                        style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: status.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: status.textColor,
                    ),
                  ),
                ),
              ],
            ),
            if (relais.availabilityDate != null) ...[
              const Gap(12),
              Text(
                'Disponible à partir du ${DateFormat('dd MMMM yyyy', 'fr_FR').format(relais.availabilityDate!)}',
                style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
            if (relais.interestedCount > 0) ...[
              const Gap(12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${relais.interestedCount} personne${relais.interestedCount > 1 ? 's' : ''} intéressée${relais.interestedCount > 1 ? 's' : ''}',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
