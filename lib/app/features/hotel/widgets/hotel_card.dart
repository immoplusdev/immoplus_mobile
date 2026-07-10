import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_model.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_detail_page.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';

class HotelCard extends StatelessWidget {
  final HotelModel hotel;

  const HotelCard({
    super.key,
    required this.hotel,
  });

  static String formatPrice(double price) {
    if (price >= 1000000000) {
      final double val = price / 1000000000;
      final cleanVal =
          val.toStringAsFixed(val.truncateToDouble() == val ? 0 : 1);
      return "$cleanVal Mrd F";
    } else if (price >= 1000000) {
      final double val = price / 1000000;
      final cleanVal =
          val.toStringAsFixed(val.truncateToDouble() == val ? 0 : 1);
      return "$cleanVal M F";
    }
    return CurrencyFormatter().format(price.toInt().toString());
  }

  @override
  Widget build(BuildContext context) {
    final double price = hotel.firstRoomPrice;

    final imageUrl = Utils.getImagePath(id: hotel.coverFileId);

    return Container(
      width: 240,
      height: 250,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.push(HotelDetailPage.route(hotel.id));
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              hotel.coverFileId.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey.shade200),
                    )
                  : Container(color: Colors.grey.shade200),

              // Shadow overlay from top to bottom for contrast
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Float overlay panel at the bottom (mockup inspired)
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.9, sigmaY: 2.9),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: const Color(0xFF1A1423).withOpacity(0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  hotel.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(3),
                                child: const Icon(Icons.star,
                                    color: Colors.white, size: 10),
                              ),
                            ],
                          ),
                          const Gap(6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.amber.shade400, width: 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                child: const Text(
                                  "Annulation gratuite",
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "${formatPrice(price)} F/nuit",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
