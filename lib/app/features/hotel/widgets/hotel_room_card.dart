import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_detail_model.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:intl/intl.dart';

class HotelRoomCard extends StatelessWidget {
  final String hotelId;
  final RoomTypeModel room;
  final VoidCallback onTap;

  const HotelRoomCard({
    super.key,
    required this.hotelId,
    required this.room,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Formats price with dot separators: 45000 -> "45.000"
    final formattedPrice = NumberFormat('#,###', 'fr_FR')
        .format(room.prixAPartirDe)
        .replaceAll(RegExp(r'\s+'), '.')
        .replaceAll('\u00a0', '.');

    return SizedBox(
      width: 184,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    height: 125,
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: room.images.isNotEmpty &&
                            room.images.first.trim().isNotEmpty
                        ? Image.network(
                            Utils.getImagePath(id: room.images.first),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: Colors.grey.shade300),
                          )
                        : Container(color: Colors.grey.shade300),
                  ),
                ),
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "${room.nombreChambres} chambre${room.nombreChambres > 1 ? 's' : ''}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(7),
            Text(
              room.nom,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF111111),
                letterSpacing: -0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(2),
            Text(
              "$formattedPrice fcfa /nuits",
              style: TextStyle(
                color: Colors.black.withOpacity(0.45),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
