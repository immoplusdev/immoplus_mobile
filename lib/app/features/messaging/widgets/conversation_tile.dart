import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/injection.dart';
import '../../../data/enums/relais_property_type.dart';
import '../../../data/models/remote/messaging/conversation_model.dart';
import '../../../data/repositories/bien_immobilier_repository.dart';
import '../../../data/repositories/relais_repository.dart';
import '../../../data/repositories/residence_repository.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/utils.dart';
import '../utils/messaging_time_format.dart';

class _TileInfo {
  final String title;
  final String? photoUrl;
  const _TileInfo({required this.title, this.photoUrl});
}

/// Ligne de conversation (spec §4.2), calquée sur `NotificationTile` :
/// visuel à gauche selon le type, titre, aperçu, heure relative, pastille
/// non-lu.
///
/// Ni la résidence ni le bien immobilier ne sont inclus dans
/// `GET /conversations` (juste leurs ids) : on les résout ici via les
/// repositories existants, avec un cache mémoire partagé entre tuiles pour
/// éviter un fetch par ligne à chaque rebuild.
class ConversationTile extends StatefulWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  final ConversationModel conversation;
  final VoidCallback onTap;

  @override
  State<ConversationTile> createState() => _ConversationTileState();
}

class _ConversationTileState extends State<ConversationTile> {
  static final Map<String, Future<_TileInfo>> _cache = {};

  Future<_TileInfo> _infoFuture() {
    final conversation = widget.conversation;
    switch (conversation.typeEnum) {
      case ConversationType.support:
        return Future.value(const _TileInfo(title: 'Support ImmoPlus'));
      case ConversationType.visite:
        final id = conversation.visiteId ?? '';
        return _cache.putIfAbsent(
          'visite:$id',
          () async {
            try {
              final response =
                  await getIt<BienImmobilierRepository>().getVisit(id: id);
              final bien = response.data.bienImmobilier;
              final photoUrl = (bien?.images.isNotEmpty ?? false)
                  ? Utils.getImagePath(id: bien!.images.first)
                  : null;
              return _TileInfo(
                title: bien?.nom.isNotEmpty ?? false ? bien!.nom : 'Bien immobilier',
                photoUrl: photoUrl,
              );
            } catch (_) {
              return const _TileInfo(title: 'Bien immobilier');
            }
          },
        );
      case ConversationType.reservation:
        final id = conversation.residenceId ?? '';
        return _cache.putIfAbsent(
          'residence:$id',
          () async {
            try {
              final response = await getIt<ResidenceRepository>().getResidence(id);
              final residence = response.data;
              return _TileInfo(
                title: residence.nom.isNotEmpty ? residence.nom : 'Résidence',
                photoUrl: residence.images.isNotEmpty
                    ? Utils.getImagePath(id: residence.images.first)
                    : null,
              );
            } catch (_) {
              return const _TileInfo(title: 'Résidence');
            }
          },
        );
      case ConversationType.relais:
        final id = conversation.relaisId ?? '';
        return _cache.putIfAbsent(
          'relais:$id',
          () async {
            try {
              final response = await getIt<RelaisRepository>().getRelaisById(id);
              final relais = response.data;
              return _TileInfo(
                title: '${relaisPropertyTypeLabel(relais.propertyType)} · ${relais.location}',
                photoUrl: relais.photos.isNotEmpty
                    ? Utils.getImagePath(id: relais.photos.first)
                    : null,
              );
            } catch (_) {
              return const _TileInfo(title: 'Déménagement');
            }
          },
        );
    }
  }

  IconData get _fallbackIcon {
    switch (widget.conversation.typeEnum) {
      case ConversationType.support:
        return Icons.support_agent_outlined;
      case ConversationType.visite:
      case ConversationType.reservation:
      case ConversationType.relais:
        return Icons.home_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final conversation = widget.conversation;
    final isUnread = conversation.unreadCountClient > 0;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.primary.withValues(alpha: 0.03)
              : Colors.transparent,
          border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
        ),
        child: FutureBuilder<_TileInfo>(
          future: _infoFuture(),
          builder: (context, snapshot) {
            final info = snapshot.data;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: (info?.photoUrl?.isNotEmpty ?? false)
                        ? CachedNetworkImage(
                            imageUrl: info!.photoUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => _fallbackThumb(),
                          )
                        : _fallbackThumb(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              info?.title ?? '…',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                color: const Color(0xFF1F2937),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formatLastMessageRelative(conversation.lastMessageAt),
                            style: GoogleFonts.dmSans(
                                fontSize: 11, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation.lastMessagePreview ?? '',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: isUnread
                                    ? const Color(0xFF1F2937)
                                    : Colors.grey.shade500,
                                fontWeight:
                                    isUnread ? FontWeight.w600 : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isUnread) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                conversation.unreadCountClient > 99
                                    ? '99+'
                                    : '${conversation.unreadCountClient}',
                                style: GoogleFonts.dmSans(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (conversation.statusEnum == ConversationStatus.blocked) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Bloqué',
                              style: GoogleFonts.dmSans(
                                  fontSize: 10, color: Colors.grey.shade600)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _fallbackThumb() {
    return Container(
      color: Colors.grey.shade100,
      child: Icon(_fallbackIcon, color: Colors.grey.shade400),
    );
  }
}
