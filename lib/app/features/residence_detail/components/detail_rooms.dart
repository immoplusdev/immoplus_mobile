import 'package:flutter/material.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class DetailLogmentRooms extends StatelessWidget {
  const DetailLogmentRooms({super.key, required this.logmentModel});
  final ResidenceModel logmentModel;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: appPadding),
      child: Wrap(
          spacing: 5,
          children: logmentModel.pieces
              .map(
                (piece) => Chip(
                  backgroundColor: AppColors.primaryLite,
                  label: Text("${piece.nombre} ${piece.nom}"),
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  labelStyle: Theme.of(context).textTheme.labelMedium,
                ),
              )
              .toList()),
    ));
  }
}
