import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/immo_icons.dart';

class DetailLogmentName extends StatelessWidget {
  const DetailLogmentName({super.key, required this.residenceModel});
  final ResidenceModel residenceModel;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: appPadding)
            .copyWith(top: 15, bottom: 10),
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
                    maxLines: maxLineAdress,
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
    );
  }
}
