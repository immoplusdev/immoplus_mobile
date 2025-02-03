import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class DetailLogmentRooms extends StatelessWidget {
  const DetailLogmentRooms({super.key, required this.logmentModel});
  final ResidenceModel logmentModel;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 2),
      child: Wrap(
          children: logmentModel.pieces
              .map(
                (piece) => Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Chip(
                    backgroundColor: AppColors.primaryLite,
                    label: Text("${piece.nombre} ${piece.nom}"),
                    //labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              )
              .toList()
          //       .asMap()
          //       .map((index, piece) => MapEntry(
          //           index,
          //           AutoSizeText(
          //               "${piece.nombre} ${piece.nom} ${(index < logmentModel.pieces!.length - 1) ? '•' : ''} ")))
          //       .values
          //       .toList(),
          // ),
          ),
    ));
  }
}
