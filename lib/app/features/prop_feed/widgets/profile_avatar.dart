import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Avatar de profil réutilisable avec bordure.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.avatarUrl,
    this.avatarPath,
    this.username = '',
    this.size = 30.0,
    this.borderWidth = 1.5,
  });

  final String? avatarUrl;
  final String? avatarPath;
  final String username;
  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      image = CachedNetworkImage(
        imageUrl: avatarUrl!,
        fit: BoxFit.cover,
        placeholder: (_, __) => _buildPlaceholder(),
        errorWidget: (_, __, ___) => _buildPlaceholder(),
      );
    } else if (avatarPath != null && avatarPath!.isNotEmpty) {
      image = Image.file(
        File(avatarPath!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    } else {
      image = _buildPlaceholder();
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: borderWidth,
        ),
      ),
      child: ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: image,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade700,
      child: Center(
        child: Text(
          username.isNotEmpty ? username[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
