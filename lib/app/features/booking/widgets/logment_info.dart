import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/utils/utils.dart';

class LogmentInfo extends StatelessWidget {
  const LogmentInfo({super.key, required this.logmentModel});
  final ResidenceModel logmentModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.immoFeedbackNeutralSubtle),
      ),
      child: Row(
        children: [
          // Image résidence
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 56,
              height: 56,
              child: logmentModel.images.isNotEmpty
                  ? Image(
                      image: Utils.getImage(id: logmentModel.images.first),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.primaryLite,
                        child: Icon(Iconsax.home_1,
                            color: AppColors.primary, size: 24),
                      ),
                    )
                  : Container(
                      color: AppColors.primaryLite,
                      child: Icon(Iconsax.home_1,
                          color: AppColors.primary, size: 24),
                    ),
            ),
          ),
          const Gap(12),
          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  logmentModel.nom,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(4),
                Row(
                  children: [
                    Text(
                      Utils.formatCurrency(logmentModel.prixReservation),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                    ),
                    Text(
                      ' / nuit',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.immoTextSecondary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
