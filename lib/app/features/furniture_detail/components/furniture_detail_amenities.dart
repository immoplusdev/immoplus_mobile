import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';

class FurnitureDetailAmenities extends StatelessWidget {
  const FurnitureDetailAmenities({super.key, required this.furnitureModel});
  final FurnitureModel furnitureModel;

  @override
  Widget build(BuildContext context) {
    // Keep this widget as a sliver and ensure all its children are RenderBox.
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Center(
            child: Text(
              'Caractéristiques du meuble',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Gap(15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _buildChip(furnitureModel.status ?? 'Normal'),
              if (furnitureModel.available) _buildChip('Disponible'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
