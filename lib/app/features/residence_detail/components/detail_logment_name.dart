import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/immo_icons.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/rating_component.dart';

class DetailLogmentName extends StatelessWidget {
  const DetailLogmentName({super.key, required this.residenceModel});
  final ResidenceModel residenceModel;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8)
            .copyWith(top: 15, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    residenceModel.nom,
                    maxLines: 2,
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
                          residenceModel.adresse,
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
                    "${CurrencyFormatter().format(residenceModel.prixReservation.toString())} F",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              TextSpan(
                text: '/nuitée',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                    ),
              )
            ])),
            const Gap(8),
          ],
        ),
      ),
    );
  }
}
