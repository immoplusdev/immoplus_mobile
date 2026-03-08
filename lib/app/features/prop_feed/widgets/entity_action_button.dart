import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:immoplus/app/features/prop_feed/video_model.dart';
import 'package:immoplus/app/features/prop_feed/widgets/bounce_side_action_button.dart';

/// Configuration label + icône selon le type d'entité liée.
class EntityActionConfig {
  const EntityActionConfig({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  /// Retourne la config selon [entity].
  /// - furniture → Contacter (icône appel)
  /// - residence → Visiter (icône localisation)
  /// - bien_immobilier → Reserver (icône calendrier)
  static EntityActionConfig fromEntity(String? entity) {
    switch (entity?.toLowerCase()) {
      case 'furniture':
        return const EntityActionConfig(
          label: 'Contacter',
          icon: Iconsax.like_dislike,
        );
      case 'residence':
        return const EntityActionConfig(
          label: 'Réserver',
          icon: Iconsax.calendar_tick,
        );
      case 'bien_immobilier':
        return const EntityActionConfig(
          label: 'Visiter',
          icon: Iconsax.map_1,
        );
      default:
        return const EntityActionConfig(
          label: 'Reserver',
          icon: Iconsax.calendar_tick,
        );
    }
  }
}

/// Bouton d'action CTA du feed vidéo, adapté au type d'entité liée.
/// Affiche le bon label et la bonne icône selon [relatedTo.entity].
class EntityActionButton extends StatelessWidget {
  const EntityActionButton({
    super.key,
    required this.relatedTo,
    required this.onTap,
  });

  final FeedItemRelatedTo? relatedTo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final config = EntityActionConfig.fromEntity(relatedTo?.entity);
    return BounceSideActionButton(
      label: config.label,
      icon: config.icon,
      onTap: onTap,
    );
  }
}
