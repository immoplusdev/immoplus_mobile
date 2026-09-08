import 'package:flutter/material.dart';
import 'package:immoplus/app/configs/app_typography.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/utils/utils.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({super.key, required this.bienImmobilierModel});
  final BienImmobilierModel bienImmobilierModel;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final period = FormUtils.getPeriod(value: bienImmobilierModel.typeLocation);

    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: primaryColor.withValues(alpha: 0.08),
        backgroundImage: Utils.getImage(id: bienImmobilierModel.images.first),
      ),
      title: Text(
        bienImmobilierModel.nom,
        style: AppTypography.labelLarge.copyWith(
          color: Colors.black87,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${bienImmobilierModel.prix} F',
              style: AppTypography.bodySmallSemiBold.copyWith(
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
            if (period != null && period.isNotEmpty)
              TextSpan(
                text: period,
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
