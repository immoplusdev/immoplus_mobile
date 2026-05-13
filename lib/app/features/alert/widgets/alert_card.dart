import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_model.dart';
import 'package:immoplus/app/data/models/remote/alert/property_type.dart';
import 'package:immoplus/app/features/alert/pages/alert_propositions_page.dart';
import 'package:immoplus/app/features/alert/pages/alert_create_edit_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/features/alert/pages/alert_detail_page.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class AlertCard extends StatelessWidget {
  final AlertModel alert;
  final VoidCallback? onRefresh;
  const AlertCard({super.key, required this.alert, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final status = alert.statusEnum;
    return InkWell(
      onTap: () async {
        if (status == AlertStatus.pending) {
          await context.pushNamed(AlertDetailPage.name, extra: alert);
          onRefresh?.call();
        } else if ((alert.unreadMatchCount ?? 0) > 0) {
          await context.pushNamed(
            AlertPropositionsPage.name,
            pathParameters: {'id': alert.id},
            extra: alert.unreadMatchCount ?? 0,
          );
          onRefresh?.call();
        }
      },
      borderRadius: BorderRadius.circular(16),
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
              children: [
                _buildTypeIcon(alert.criteria.propertyTypeObj),
                const Gap(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${(alert.criteria.propertyTypeObj?.label ?? '').capitalize()} · ${alert.criteria.location ?? 'Abidjan'}',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (alert.createdAt != null)
                        Text(
                          'Envoyée le ${DateFormat('dd MMMM yyyy', 'fr_FR').format(alert.createdAt!)}',
                          style: GoogleFonts.dmSans(
                              fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
            const Gap(16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTag((alert.criteria.transactionType ?? '').capitalize()),
                _buildTag('${alert.criteria.roomsMin ?? 0} pièces'),
                _buildTag(
                    '${NumberFormat.compact().format(alert.criteria.priceMin ?? 0)} - ${NumberFormat.compact().format(alert.criteria.priceMax ?? 0)} fcfa'),
              ],
            ),
            if ((alert.unreadMatchCount ?? 0) > 0) ...[
              const Gap(16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${alert.unreadMatchCount} ${(alert.unreadMatchCount ?? 0) > 1 ? 'nouvelles propositions disponibles' : 'nouvelle proposition disponible'}',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if ((alert.unreadMatchCount ?? 0) > 0)
                  ElevatedButton(
                    onPressed: () => context.pushNamed(
                      AlertPropositionsPage.name,
                      pathParameters: {'id': alert.id},
                      extra: alert.unreadMatchCount ?? 0,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Row(
                      children: [
                        Text('Consulté',
                            style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        const Gap(8),
                        const Icon(Icons.arrow_forward_ios, size: 12),
                      ],
                    ),
                  )
                else if (status == AlertStatus.closed)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Archivée',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                  )
                else
                  OutlinedButton(
                    onPressed: () async {
                      if (status == AlertStatus.pending) {
                        await context.pushNamed(
                          AlertDetailPage.name,
                          extra: alert,
                        );
                      } else {
                        await context.pushNamed(
                          AlertCreateEditPage.name,
                          extra: alert,
                        );
                      }
                      onRefresh?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide.none,
                      backgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Row(
                      children: [
                        Text('Voir détails',
                            style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        const Gap(8),
                        const Icon(Icons.arrow_forward_ios, size: 12),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeIcon(AlertPropertyType? type) {
    return SvgPicture.asset(
      type?.icon ?? '',
      width: 33,
      height: 33,
    );
  }

  Widget _buildTag(String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade700),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
