import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/immo_icons.dart';

class DetailEstateName extends StatelessWidget {
  const DetailEstateName({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8)
            .copyWith(top: 15, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    bienImmobilier.nom,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      const ImmoIcon(
                        ImmoIcons.marker,
                        size: 10,
                      ),
                      const Gap(3),
                      Expanded(
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          bienImmobilier.adresse,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text:
                    "${CurrencyFormatter().format(bienImmobilier.prix.toString())} Fcfa",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              TextSpan(
                text: '/${bienImmobilier.typeLocation}',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                    ),
              )
            ])),
          ],
        ),
      ),
    );
  }
}
