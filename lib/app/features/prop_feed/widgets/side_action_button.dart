import 'package:flutter/material.dart';

/// Bouton d'action latéral du feed vidéo (like, commentaire, partage).
class SideActionButton extends StatelessWidget {
  const SideActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor = Colors.white,
    this.iconSize = 24.0,
    this.iconRadius = 18.0,
    this.onTap,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final double iconSize;
  final double iconRadius;
  final VoidCallback? onTap;

  /// Affiche un spinner à la place de l'icône pendant un traitement.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: iconRadius,
            child: isLoading
                ? SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: iconColor,
                    ),
                  )
                : Icon(icon, color: iconColor, size: iconSize),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              color: iconColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
