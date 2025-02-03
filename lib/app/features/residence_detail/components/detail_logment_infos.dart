import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class DetailLogmentInfos extends StatelessWidget {
  const DetailLogmentInfos({super.key, required this.reservation});
  final ResidenceModel reservation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 8, right: 8),
        child: SizedBox(
          width: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 15,
                color: AppColors.primary,
              ),
              Flexible(
                child: AutoSizeText(
                  reservation.adresse,
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
