import 'dart:io';

import 'package:flutter/material.dart';

import 'package:immoplus/app/widgets/monogram_avatar.dart';

/// Avatar de profil réutilisable avec bordure.
/// Utilise MonogramAvatar en interne (image ou initiales).
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.avatarUrl,
    this.avatarPath,
    this.username = '',
    this.size = 30.0,
    this.borderWidth = 1.5,
    this.verify = false,
  });

  final String? avatarUrl;
  final String? avatarPath;
  final String username;
  final double size;
  final double borderWidth;
  final bool verify;

  @override
  Widget build(BuildContext context) {
    final imageProvider = avatarPath != null && avatarPath!.isNotEmpty
        ? FileImage(File(avatarPath!))
        : null;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: borderWidth,
        ),
      ),
      child: MonogramAvatar(
        name: username.isNotEmpty ? username : '?',
        size: size,
        imageUrl: avatarUrl,
        imageProvider: imageProvider,
        verify: false,
      ),
    );
  }
}
