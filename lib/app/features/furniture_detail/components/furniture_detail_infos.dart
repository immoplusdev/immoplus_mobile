import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class FurnitureDetailInfos extends StatelessWidget {
  const FurnitureDetailInfos({super.key, required this.furnitureModel});
  final FurnitureModel furnitureModel;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Divider(),
            const Gap(10),
            Row(
              children: [
                Expanded(child: _buildInfoItem(context, "Type", furnitureModel.type ?? "-")),
                Expanded(child: _buildInfoItem(context, "Catégorie", furnitureModel.category ?? "-")),
                Expanded(child: _buildInfoItem(context, "Etat", furnitureModel.etat ?? "-")),
              ],
            ),
            const Gap(14),
            
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const Gap(5),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

 
}
