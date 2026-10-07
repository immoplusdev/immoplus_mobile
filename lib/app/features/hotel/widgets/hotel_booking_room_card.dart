import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_detail_model.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';

class HotelBookingRoomCard extends StatelessWidget {
  final RoomTypeModel room;
  final bool isSelected;
  final VoidCallback onTap;

  const HotelBookingRoomCard({
    super.key,
    required this.room,
    required this.isSelected,
    required this.onTap,
  });

  String _getRoomShortCode(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('standard')) return 'STD';
    if (lower.contains('sup')) return 'SUP';
    if (lower.contains('presi')) return 'PRE';
    if (lower.contains('junior') || lower.contains('jr')) return 'JR';
    if (lower.contains('suite')) return 'STE';
    return name.length >= 3 ? name.substring(0, 3).toUpperCase() : 'RM';
  }

  @override
  Widget build(BuildContext context) {
    final shortCode = _getRoomShortCode(room.nom);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.immoBorderDefault,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Shortcode Badge Pill
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.white
                      : AppColors.immoBgSurfaceMuted,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? Border.all(
                          color: AppColors.primary.withOpacity(0.15), width: 1)
                      : null,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  shortCode,
                  style: AppTypography.font(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? AppColors.blue500
                        : const Color(0xFF666666),
                  ),
                ),
              ),
            ),
            const Gap(6),
            // Room Name
            Text(
              room.nom,
              style: AppTypography.font(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF111111),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Price info
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: AppTypography.font(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                children: [
                  TextSpan(
                    text: CurrencyFormatter()
                        .format(room.prixAPartirDe.toString()),
                  ),
                  TextSpan(
                    text: ' /nuit',
                    style: AppTypography.font(
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      color: AppColors.immoTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Availability count
            Text(
              "${room.nombreChambres} dispo.",
              style: AppTypography.font(
                color:
                    isSelected ? const Color(0xFF2E7D32) : AppColors.green500,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
