import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_model.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_detail_page.dart';
import 'package:immoplus/app/features/hotel/widgets/free_anulation_card.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class HotelCardSponsorise extends StatelessWidget {
  final HotelModel hotel;

  const HotelCardSponsorise({
    super.key,
    required this.hotel,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = Utils.getImagePath(id: hotel.coverFileId);

    return Container(
      width: 373,
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
                height: 200,
                width: double.infinity,
                color: Colors.grey.shade100,
                child: hotel.coverFileId.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) =>
                            Container(color: Colors.grey.shade200),
                      )
                    : Container(color: Colors.grey.shade200),
              ),
              // Content Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotel.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(6),
                      Row(
                        children: [
                          FreeAnulationCard(
                            color: AppColors.black,
                          ),
                          const Gap(8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffFFC400)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: const Text(
                              "VIP",
                              style: TextStyle(
                                color: Color(0xffFFC400),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),

                      // Description Short
                      Expanded(
                        child: Text(
                          hotel.descriptionShort,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.4,
                          ),
                          // maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
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
