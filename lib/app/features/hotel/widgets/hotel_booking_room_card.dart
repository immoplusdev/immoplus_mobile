import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_detail_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';
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
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
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
                  color: isSelected ? Colors.white : const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? Border.all(color: AppColors.primary.withOpacity(0.15), width: 1)
                      : null,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  shortCode,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primary : const Color(0xFF666666),
                  ),
                ),
              ),
            ),
            const Gap(6),
            // Room Name
            Text(
              room.nom,
              style: const TextStyle(
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: CurrencyFormatter().format(room.prixAPartirDe.toString()),
                  ),
                  const TextSpan(
                    text: ' /nuit',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Availability count
            Text(
              "${room.nombreChambres} dispo.",
              style: TextStyle(
                color: isSelected ? const Color(0xFF2E7D32) : Colors.green.shade600,
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
