import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';

class DetailLogmentRooms extends StatelessWidget {
  const DetailLogmentRooms({super.key, required this.logmentModel});
  final ResidenceModel logmentModel;

  @override
  Widget build(BuildContext context) {
    // Filter out pieces with 0 count
    final validPieces =
        logmentModel.pieces.where((p) => p.nombre > 0).toList();

    if (validPieces.isEmpty) return const SliverToBoxAdapter();

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 140,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: appPadding),
          physics: const BouncingScrollPhysics(),
          itemCount: validPieces.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            final piece = validPieces[index];
            return _RoomCard(
              name: piece.nom,
              count: piece.nombre,
            );
          },
        ),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.name, required this.count});
  final String name;
  final int count;

  IconData get _icon {
    final lower = name.toLowerCase();
    if (lower.contains('chambre') || lower.contains('bedroom')) {
      return Iconsax.lamp;
    }
    if (lower.contains('salon') || lower.contains('living') || lower.contains('séjour')) {
      return Iconsax.home_2;
    }
    if (lower.contains('cuisine') || lower.contains('kitchen')) {
      return Iconsax.coffee;
    }
    if (lower.contains('salle') || lower.contains('bain') || lower.contains('douche')) {
      return Iconsax.house;
    }
    if (lower.contains('toilette') || lower.contains('wc')) {
      return Iconsax.shield_tick;
    }
    if (lower.contains('balcon') || lower.contains('terrasse')) {
      return Iconsax.sun_1;
    }
    if (lower.contains('garage') || lower.contains('parking')) {
      return Iconsax.car;
    }
    return Iconsax.building;
  }

  String get _subtitle {
    if (count == 1) return '1 pièce';
    return '$count pièces';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _icon,
              size: 24,
              color: Colors.grey.shade800,
            ),
          ),
          const Spacer(),
          Text(
            name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF222222),
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            _subtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}