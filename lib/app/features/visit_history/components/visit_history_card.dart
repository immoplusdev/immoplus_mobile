import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/appli/widgets/date_creation_widget.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus/app/features/visits/visit_pending_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:intl/intl.dart';

class VisitHistoryCard extends StatelessWidget {
  VisitHistoryCard({super.key, required this.demandeVisiteModel});
  final DemandeVisiteModel demandeVisiteModel;
  final DateFormat formatDate = DateFormat('d MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    final isExpress = demandeVisiteModel.typeDemandeVisite == 'express';
    final hasDates = demandeVisiteModel.datesDemandeVisite.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (demandeVisiteModel.bienImmobilier == null) return;
          context.pushNamed(
            VisitPendingPage.name,
            extra: VisitPendingPage(
              bienImmo: demandeVisiteModel.bienImmobilier!,
              visitType: demandeVisiteModel.typeDemandeVisite ?? '',
              visitId: demandeVisiteModel.id,
              fromHistory: true,
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: const Color(0xFFF2F4F7)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Type badge + Nom du bien
              Row(
                children: [
                  // Badge type visite
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isExpress
                          ? const Color(0xFFFEF3F2)
                          : const Color(0xFFF4F3FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isExpress ? Iconsax.flash_1 : Iconsax.calendar_1,
                          size: 14,
                          color: isExpress
                              ? const Color(0xFFF04438)
                              : const Color(0xFF7A5AF8),
                        ),
                        const Gap(4),
                        Text(
                          demandeVisiteModel.typeDemandeVisite
                              .toString()
                              .toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isExpress
                                ? const Color(0xFFF04438)
                                : const Color(0xFF7A5AF8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Montant
                  AutoSizeText(
                    maxLines: 1,
                    Utils.formatCurrency(
                        demandeVisiteModel.montantTotalDemandeVisite),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              const Gap(12),

              // Nom du bien immobilier
              if (demandeVisiteModel.bienImmobilier != null) ...[
                Text(
                  demandeVisiteModel.bienImmobilier!.nom,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Gap(4),
                Row(
                  children: [
                    Icon(
                      Iconsax.location,
                      size: 14,
                      color: const Color(0xFF667085),
                    ),
                    const Gap(4),
                    Expanded(
                      child: Text(
                        demandeVisiteModel.bienImmobilier!.adresse,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF667085),
                            ),
                      ),
                    ),
                  ],
                ),
              ],

              const Gap(12),
              Divider(thickness: 0.5, color: Colors.grey.shade200, height: 1),
              const Gap(12),

              // Date de visite ou message "pas de date"
              if (!hasDates)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFAEB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.calendar_remove,
                        size: 16,
                        color: Color(0xFFF79009),
                      ),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          "Aucune date de visite planifiée",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFFB54708),
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (hasDates)
                Row(
                  children: [
                    // Date
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.calendar_1,
                              size: 14, color: AppColors.primary),
                          const Gap(6),
                          Text(
                            Utils.formatDatOnly(
                                dateTime: demandeVisiteModel
                                    .datesDemandeVisite.first.date!),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(8),
                    // Heure
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.clock,
                              size: 14, color: AppColors.primary),
                          const Gap(6),
                          Text(
                            Utils.formatTimeOnly(
                                dateTime: demandeVisiteModel
                                    .datesDemandeVisite.first.date!),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Voir plus
                    Row(
                      children: [
                        Text(
                          "Détails",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        const Gap(4),
                        Icon(
                          Iconsax.arrow_right_3,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),

              // Date de création
              const Gap(8),
              DateCreationWidget(
                createdAt: demandeVisiteModel.createdAt,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
