import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';

class FurnitureDetailInfos extends StatelessWidget {
  const FurnitureDetailInfos({super.key, required this.furnitureModel});
  final FurnitureModel furnitureModel;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const Gap(16),
            Text(
              'Informations du meuble',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Gap(14),
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 12.0;
                final itemWidth = (constraints.maxWidth - spacing) / 2;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    _buildInfoItem(
                      context,
                      width: itemWidth,
                      label: "Type",
                      value: furnitureModel.type ?? "-",
                    ),
                    _buildInfoItem(
                      context,
                      width: itemWidth,
                      label: "Catégorie",
                      value: furnitureModel.category ?? "-",
                    ),
                    _buildInfoItem(
                      context,
                      width: itemWidth,
                      label: "Etat",
                      value: furnitureModel.etat ?? "-",
                    ),
                  ],
                );
              },
            ),
            const Gap(18),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required double width,
    required String label,
    required String value,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFEAECEF),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11.5,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const Gap(7),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
