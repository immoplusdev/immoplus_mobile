import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_model.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_detail_page.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';

class HotelCardSponsorise extends StatelessWidget {
  final HotelModel hotel;

  const HotelCardSponsorise({
    super.key,
    required this.hotel,
  });

  @override
  Widget build(BuildContext context) {
    final double price = hotel.firstRoomPrice;

    final imageUrl = Utils.getImagePath(id: hotel.coverFileId);

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.push(HotelDetailPage.route(hotel.id));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                height: 140,
                width: double.infinity,
                color: Colors.grey.shade100,
                child: hotel.coverFileId.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey.shade200),
                      )
                    : Container(color: Colors.grey.shade200),
              ),

              // Content Area
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(6),

                    // Pills row
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade800, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: const Text(
                            "Annulation gratuite",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Gap(8),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.amber.shade700, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: const Text(
                            "VIP",
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),

                    // Description Short
                    Text(
                      hotel.descriptionShort,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
