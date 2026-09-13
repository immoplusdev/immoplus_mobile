import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/remote/messaging/conversation_model.dart';
import '../../../data/models/remote/messaging/conversation_type_count.dart';
import '../../../utils/app_colors.dart';

/// Rangée d'onglets "pills" (spec §4.1) : Toutes / Réservation / Visite /
/// Support, calquée sur le pattern déjà utilisé pour les onglets d'alerte
/// (`alert_list_page.dart`).
class InboxTabs extends StatelessWidget {
  const InboxTabs({
    super.key,
    required this.activeType,
    required this.counts,
    required this.onSelect,
  });

  /// `null` = onglet "Toutes" actif.
  final ConversationType? activeType;
  final List<ConversationTypeCount> counts;
  final ValueChanged<ConversationType?> onSelect;

  int _unreadFor(ConversationType? type) {
    if (type == null) {
      return counts.fold<int>(0, (t, c) => t + c.unread);
    }
    return counts
        .firstWhere((c) => c.typeEnum == type,
            orElse: () => const ConversationTypeCount(type: ''))
        .unread;
  }

  @override
  Widget build(BuildContext context) {
    final items = <(ConversationType?, String)>[
      (null, 'Toutes'),
      (ConversationType.reservation, 'Réservation'),
      (ConversationType.visite, 'Visite'),
      (ConversationType.support, 'Support'),
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (type, label) = items[index];
          final isSelected = type == activeType;
          final unread = _unreadFor(type);
          return GestureDetector(
            onTap: () => onSelect(type),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.blue.shade100,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
                  if (unread > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        unread > 99 ? '99+' : '$unread',
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.primary : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
