import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class DetailEstateRooms extends StatelessWidget {
  const DetailEstateRooms({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 8),
        child: Wrap(
            children: bienImmobilier.pieces
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
                .toList()),
      ),
    );
  }
}
