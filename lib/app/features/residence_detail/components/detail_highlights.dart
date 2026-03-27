import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';

/// Premium highlights section — icon | title bold + subtitle grey
/// Matches the Airbnb/Roomer pattern.
class DetailHighlights extends StatelessWidget {
  const DetailHighlights({super.key, required this.residenceModel});
  final ResidenceModel residenceModel;

  List<_HighlightData> _buildHighlights() {
    final highlights = <_HighlightData>[];

    // Arrivée autonome
    if (residenceModel.heureEntree.isNotEmpty) {
      highlights.add(
        _HighlightData(
          icon: Iconsax.key,
          title: 'Arrivée autonome',
          subtitle:
              'Entrez dans les lieux à partir de ${residenceModel.heureEntree}.',
        ),
      );
    }

    // Occupants max
    if (residenceModel.nombreMaxOccupants > 0) {
      highlights.add(
        _HighlightData(
          icon: Iconsax.people,
          title: '${residenceModel.nombreMaxOccupants} voyageurs maximum',
          subtitle:
              'Ce logement accueille jusqu\'à ${residenceModel.nombreMaxOccupants} personnes.',
        ),
      );
    }

    // Animaux
    if (residenceModel.animauxAutorises) {
      highlights.add(
        const _HighlightData(
          icon: Iconsax.pet,
          title: 'Animaux acceptés',
          subtitle: 'Vos compagnons sont les bienvenus dans ce logement.',
        ),
      );
    } else {
      highlights.add(
        const _HighlightData(
          icon: Iconsax.pet,
          title: 'Animaux non autorisés',
          subtitle: 'Les animaux de compagnie ne sont pas acceptés.',
        ),
      );
    }

    // Durée min séjour
    if (residenceModel.dureeMinSejour > 0) {
      highlights.add(
        _HighlightData(
          icon: Iconsax.calendar_tick,
          title: 'Séjour min. ${residenceModel.dureeMinSejour} nuit${residenceModel.dureeMinSejour > 1 ? 's' : ''}',
          subtitle: 'Le propriétaire requiert un séjour minimum.',
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