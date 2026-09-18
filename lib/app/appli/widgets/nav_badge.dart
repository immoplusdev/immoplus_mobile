import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/utils.dart';

/// Pastille rouge avec compteur, à poser sur une icône de navigation.
/// Réactive à un [ValueNotifier<int>] : se cache automatiquement si count <= 0.
class NavBadge extends StatelessWidget {
  const NavBadge({super.key, required this.notifier});

  final ValueNotifier<int> notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: notifier,
      builder: (_, count, __) {
        final badgeText = Utils.formatBadgeCount(count);
        if (badgeText == null) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(3),
          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Text(
            badgeText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
