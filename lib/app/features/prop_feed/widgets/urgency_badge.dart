import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Type d'urgence pour le badge (likes, réservations, satisfaction).
enum UrgencyBadgeType {
  likes,
  reservations,
  satisfaction,
}

/// Badge d'urgence réutilisable avec délai d'apparition et disparition.
///
/// Exemples d'utilisation :
/// - Likes : "Plus de 10k aiment cette résidence" (orange)
/// - Réservations : "Plus de 132 ont réservé cette résidence" (vert)
/// - Satisfaction : "Plus de 123 personnes sont satisfaites" (bleu)
class UrgencyBadgeWithDelay extends StatefulWidget {
  const UrgencyBadgeWithDelay({
    super.key,
    required this.count,
    required this.type,
    this.delayBeforeShow = const Duration(seconds: 3),
    this.visibleDuration = const Duration(seconds: 3),
    this.customLabel,
  });

  final int count;
  final UrgencyBadgeType type;
  final Duration delayBeforeShow;
  final Duration visibleDuration;
  final String? customLabel;

  @override
  State<UrgencyBadgeWithDelay> createState() => _UrgencyBadgeWithDelayState();
}

class _UrgencyBadgeWithDelayState extends State<UrgencyBadgeWithDelay> {
  bool _visible = false;
  bool _gone = false;
  Timer? _showTimer;

  static Color _colorForType(UrgencyBadgeType type) {
    switch (type) {
      case UrgencyBadgeType.likes:
        return const Color(0xFFF97316); // Orange
      case UrgencyBadgeType.reservations:
        return const Color(0xFF22C55E); // Vert
      case UrgencyBadgeType.satisfaction:
        return const Color(0xFF3B82F6); // Bleu
    }
  }

  static IconData _iconForType(UrgencyBadgeType type) {
    switch (type) {
      case UrgencyBadgeType.likes:
        return Iconsax.heart5;
      case UrgencyBadgeType.reservations:
        return Iconsax.calendar_tick;
      case UrgencyBadgeType.satisfaction:
        return Iconsax.like_15;
    }
  }

  static String _defaultLabel(UrgencyBadgeType type, String countStr) {
    switch (type) {
      case UrgencyBadgeType.likes:
        return 'Plus de $countStr aiment cette résidence';
      case UrgencyBadgeType.reservations:
        return 'Plus de $countStr ont réservé cette résidence';
      case UrgencyBadgeType.satisfaction:
        return 'Plus de $countStr personnes sont satisfaites';
    }
  }

  static String _formatCount(int count) {
    if (count >= 1000) {
      final k = count ~/ 1000;
      return '${k}k';
    }
    return count.toString();
  }

  @override
  void initState() {
    super.initState();
    _showTimer = Timer(widget.delayBeforeShow, () {
      if (!mounted) return;
      setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _showTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gone) return const SizedBox.shrink();
    if (!_visible) return const SizedBox.shrink();

    final countStr = _formatCount(widget.count);
    final label = widget.customLabel ?? _defaultLabel(widget.type, countStr);
    final color = _colorForType(widget.type);
    final icon = _iconForType(widget.type);

    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: FadeOut(
        delay: widget.visibleDuration,
        duration: const Duration(milliseconds: 500),
        onFinish: (_) {
          if (mounted) setState(() => _gone = true);
        },
        child: _buildBadge(label: label, color: color, icon: icon),
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
