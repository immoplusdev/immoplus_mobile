import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class RatingEstateSection extends StatelessWidget {
  const RatingEstateSection({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Note et avis'),
        RatingBar.builder(
          initialRating: 3,
          unratedColor: AppColors.grey,
          minRating: 2,
          maxRating: 5,
          itemSize: 15,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          tapOnlyMode: true,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: AppColors.amber,
          ),
          onRatingUpdate: (rating) {},
        )
      ],
    );
  }
}
