import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';

class RatingLogmentSection extends StatelessWidget {
  const RatingLogmentSection({super.key, required this.residenceModel});
  final ResidenceModel residenceModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Note et avis'),
        RatingBar.builder(
          initialRating: 3,
          unratedColor: Colors.grey,
          minRating: 2,
          maxRating: 5,
          itemSize: 15,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          tapOnlyMode: true,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        )
      ],
    );
  }
}
