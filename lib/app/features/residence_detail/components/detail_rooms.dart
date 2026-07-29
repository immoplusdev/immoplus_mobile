import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class DetailLogmentRooms extends StatelessWidget {
  const DetailLogmentRooms({super.key, required this.logmentModel});
  final ResidenceModel logmentModel;

  @override
  Widget build(BuildContext context) {
    final validPieces = logmentModel.pieces.where((p) => p.nombre > 0).toList();

    if (validPieces.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Wrap(
          spacing: 20,
          runSpacing: 12,
          children: validPieces
              .map((p) => _RoomItem(name: p.nom, count: p.nombre))
              .toList(),
        ),
      ),
    );
  }
}

class _RoomItem extends StatelessWidget {
  const _RoomItem({required this.name, required this.count});
  final String name;
  final int count;

  IconData get _icon {
    final lower = name.toLowerCase();

    if (lower.contains('chambre') || lower.contains('bedroom')) {
      return Iconsax.house;
    }
    if (lower.contains('salle') ||
        lower.contains('bain') ||
        lower.contains('douche') ||
        lower.contains('bathroom')) {
      return Iconsax.receipt_1;
    }

    if (lower.contains('salon') ||
        lower.contains('living') ||
        lower.contains('séjour')) {
      return Iconsax.lamp_charge;
    }
    if (lower.contains('cuisine') || lower.contains('kitchen')) {
      return Iconsax.coffee;
    }
    if (lower.contains('toilette') || lower.contains('wc')) {
      return Iconsax.drop;
    }
    if (lower.contains('balcon') || lower.contains('terrasse')) {
      return Iconsax.sun_1;
    }
    if (lower.contains('garage') || lower.contains('parking')) {
      return Iconsax.car;
    }

    return Iconsax.home_2;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _icon,
          size: 20,
          color: Color(0xff2744de),
        ),
        const SizedBox(width: 6),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3D4A5C),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF3D4A5C),
          ),
        ),
      ],
    );
  }
}
