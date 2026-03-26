import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';

/// Highlights section for estate — icon | title bold + subtitle grey
/// Adapted from DetailHighlights (residence).
class DetailEstateHighlights extends StatelessWidget {
  const DetailEstateHighlights({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;

  List<_HighlightData> _buildHighlights() {
    final highlights = <_HighlightData>[];

    // Type de bien
    if (bienImmobilier.typeBienImmobilier.isNotEmpty) {
      highlights.add(
        _HighlightData(
          icon: Iconsax.building,
          title: bienImmobilier.typeBienImmobilier,
          subtitle: 'Type de bien immobilier.',
        ),
      );
    }

    // Occupants max
    if ((bienImmobilier.nombreMaxOccupants ?? 0) > 0) {
      highlights.add(
        _HighlightData(
          icon: Iconsax.people,
          title: '${bienImmobilier.nombreMaxOccupants} occupants maximum',
          subtitle:
              'Ce bien peut accueillir jusqu\'à ${bienImmobilier.nombreMaxOccupants} personnes.',
        ),
      );
    }

    // Fêtes autorisées
    if (bienImmobilier.fetesAutorises == true) {
      highlights.add(
        const _HighlightData(
          icon: Iconsax.music,
          title: 'Événements autorisés',
          subtitle: 'Les événements sont les bienvenus dans ce bien.',
        ),
      );
    } else {
      highlights.add(
        const _HighlightData(
          icon: Iconsax.music,
          title: 'Événements non autorisés',
          subtitle: 'Les événements ne sont pas acceptés dans ce bien.',
        ),
      );
    }

    return highlights.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final highlights = _buildHighlights();
    if (highlights.isEmpty) return const SliverToBoxAdapter();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: appPadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                top: index == 0 ? 0 : 6,
                bottom: index == highlights.length - 1 ? 0 : 6,
              ),
              child: _HighlightTile(data: highlights[index]),
            );
          },
          childCount: highlights.length,
        ),
      ),
    );
  }
}

class _HighlightData {
  final IconData icon;
  final String title;
  final String subtitle;
  const _HighlightData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _HighlightTile extends StatelessWidget {
  const _HighlightTile({required this.data});
  final _HighlightData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              data.icon,
              size: 22,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222222),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
