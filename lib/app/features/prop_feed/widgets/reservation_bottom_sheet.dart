import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/app_colors.dart';

/// Paramètres pour contrôler la taille du bottom sheet.
class ReservationSheetSize {
  const ReservationSheetSize({
    this.heightFactor,
    this.height,
    this.maxHeight,
    this.minHeight,
  }) : assert(
          heightFactor == null || (heightFactor > 0 && heightFactor <= 1),
          'heightFactor doit être entre 0 et 1',
        );

  /// Fraction de la hauteur de l'écran (0.0 à 1.0). Ex: 0.4 = 40% de l'écran.
  final double? heightFactor;

  /// Hauteur fixe en pixels (logical).
  final double? height;

  /// Hauteur maximale en pixels.
  final double? maxHeight;

  /// Hauteur minimale en pixels.
  final double? minHeight;
}

/// Données passées au bottom sheet Réserver pour personnaliser l'affichage.
class ReservationSheetData {
  const ReservationSheetData({
    required this.entity,
    required this.entityId,
    required this.videoId,
    this.title,
    this.description,
    this.price,
    this.location,
    this.authorName,
    this.authorAvatarUrl,
    this.thumbnailUrl,
  });

  /// Type d'entité : 'residence' | 'bien_immobilier' | 'furniture'
  final String entity;

  /// ID du bien (résidence, estate, meuble)
  final String entityId;

  /// ID de la vidéo du feed
  final String videoId;

  final String? title;
  final String? description;
  final String? price;
  final String? location;
  final String? authorName;
  final String? authorAvatarUrl;
  final String? thumbnailUrl;
}

/// Bottom sheet affiché au tap sur "Réserver" dans le feed vidéo.
/// Utilise [ReservationSheetData] pour afficher les infos du bien.
class ReservationBottomSheet extends StatelessWidget {
  const ReservationBottomSheet({
    super.key,
    required this.data,
    this.onReserve,
    this.onViewDetail,
  });

  final ReservationSheetData data;
  final VoidCallback? onReserve;
  final VoidCallback? onViewDetail;

  /// Affiche le bottom sheet Réserver. Le sheet vient du bas et s'affiche
  /// au-dessus de la navigation bar. Utilise [size] pour ajuster la hauteur.
  static Future<T?> show<T>({
    required BuildContext context,
    required ReservationSheetData data,
    VoidCallback? onReserve,
    VoidCallback? onViewDetail,
    ReservationSheetSize size = const ReservationSheetSize(),
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      //showDragHandle: true,
      builder: (context) {
        Widget content = ReservationBottomSheet(
          data: data,
          onReserve: onReserve,
          onViewDetail: onViewDetail,
        );
        if (size.heightFactor != null) {
          content = FractionallySizedBox(
            heightFactor: size.heightFactor!,
            child: content,
          );
        } else if (size.height != null) {
          content = SizedBox(height: size.height, child: content);
        }
        if (size.maxHeight != null || size.minHeight != null) {
          content = ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: size.maxHeight ?? double.infinity,
              minHeight: size.minHeight ?? 0,
            ),
            child: content,
          );
        }
        return Container(
          decoration: BoxDecoration(
            color: AppColors.scafold,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: content,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          if (data.title != null && data.title!.isNotEmpty)
            Text(
              data.title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          if (data.description != null && data.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              data.description!,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (data.price != null && data.price!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              data.price!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
          if (data.location != null && data.location!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              data.location!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onViewDetail?.call();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                  ),
                  child: const Text('Voir le détail'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onReserve?.call();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('Réserver'),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}
