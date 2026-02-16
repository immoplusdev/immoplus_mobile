import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/immo_icons.dart';

class FurnitureDetailName extends StatelessWidget {
  const FurnitureDetailName({super.key, required this.furnitureModel});
  final FurnitureModel furnitureModel;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20)
            .copyWith(top: 15, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AutoSizeText(
                    furnitureModel.titre,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Gap(10),
                Text(
                  "${CurrencyFormatter().format(furnitureModel.prix.toString())} Fcfa",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
            const Gap(5),
            Row(
              children: [
                const ImmoIcon(
                  ImmoIcons.marker,
                  size: 10,
                ),
                const Gap(5),
                Expanded(
                  child: Text(
                    maxLines: maxLineAdress,
                    overflow: TextOverflow.clip,
                    "${furnitureModel.adresse} ${furnitureModel.communeModel?.name ?? ""}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
            const Gap(5),
            Row(
              children: _resolveAvailableColors().asMap().entries.map((entry) {
                final index = entry.key;
                final color = entry.value;

                return Transform.translate(
                  offset: Offset(index * -8, 0),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  List<Color> _resolveAvailableColors() {
    return (furnitureModel.metadata?.colors ?? const <String>[])
        .map(_parseApiColor)
        .whereType<Color>()
        .toList();
  }

  Color? _parseApiColor(String rawColor) {
    var hex = rawColor.trim().toUpperCase().replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    if (hex.length != 8) {
      return null;
    }
    final value = int.tryParse(hex, radix: 16);
    if (value == null) {
      return null;
    }
    return Color(value);
  }
}
