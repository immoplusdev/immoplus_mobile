import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:immoplus/app/extensions/monogram_extension.dart';
import 'package:immoplus/app/utils/app_colors.dart';

/// Rôle utilisateur pour le style de l'avatar.
enum UserRole {
  newUser,
  active,
  powerUser,
}

/// Avatar monogramme réutilisable et modulable.
/// Palette inspirée iOS avec dégradés, support image optionnelle.
/// [verify] : si true, affiche l'icône vérifiée en bas de l'avatar.
class MonogramAvatar extends StatelessWidget {
  const MonogramAvatar({
    super.key,
    required this.name,
    this.size = 64.0,
    this.role = UserRole.active,
    this.fontSize,
    this.imageUrl,
    this.imageProvider,
    this.verify = false,
  });

  final String name;
  final double size;
  final UserRole role;
  final double? fontSize;
  final String? imageUrl;
  final ImageProvider? imageProvider;
  final bool verify;

  /// Palette inspirée iOS (dégradés premium).
  static const List<List<Color>> _premiumPalettes = [
    [Color(0xFFB1B6BE), Color(0xFF9096A0)], // Gris
    [Color(0xFFFF89A3), Color(0xFFFF6B8B)], // Rose
    [Color(0xFFFF7161), Color(0xFFFF523D)], // Rouge
    [Color(0xFFFFBA53), Color(0xFFFFA023)], // Orange
    [Color(0xFFFFD15C), Color(0xFFFFBE28)], // Jaune
    [Color(0xFF80E08E), Color(0xFF5BCB6B)], // Vert
    [Color(0xFF7DD2FF), Color(0xFF55B9FF)], // Bleu
    [Color(0xFFB69BFF), Color(0xFF9872FF)], // Violet
  ];

  @override
  Widget build(BuildContext context) {
    final effectiveFontSize = fontSize ?? size * 0.375;
    final hasImage =
        imageUrl != null && imageUrl!.isNotEmpty || imageProvider != null;

    Widget avatar;
    if (hasImage) {
      avatar = _buildWithImage(effectiveFontSize);
    } else {
      avatar = _buildMonogram(effectiveFontSize);
    }

    if (verify) {
      final iconSize = size * 0.45;
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            avatar,
            Positioned(
              left: 12,
              bottom: -3,
              child: Icon(
                Iconsax.verify5,
                color: AppColors.primaryLite,
                size: iconSize,
              ),
            ),
          ],
        ),
      );
    }
    return avatar;
  }

  Widget _buildWithImage(double effectiveFontSize) {
    final monogram = _buildMonogram(effectiveFontSize);
    final provider =
        imageProvider ?? (imageUrl != null ? NetworkImage(imageUrl!) : null);

    if (provider == null) return monogram;

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                placeholder: (_, __) => monogram,
                errorWidget: (_, __, ___) => monogram,
              )
            : Image(
                image: provider,
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorBuilder: (_, __, ___) => monogram,
              ),
      ),
    );
  }

  Widget _buildMonogram(double effectiveFontSize) {
    final initials = name.initials;
    final colorIndex = name.colorHash % _premiumPalettes.length;
    final gradientColors = _premiumPalettes[colorIndex];

    BoxBorder? border;
    List<BoxShadow>? shadows;

    if (role == UserRole.newUser) {
      border = Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 2);
    } else if (role == UserRole.powerUser) {
      shadows = [
        BoxShadow(
          color: gradientColors.last.withValues(alpha: 0.6),
          blurRadius: 12,
          spreadRadius: 2,
        ),
      ];
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border,
        boxShadow: shadows,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: effectiveFontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

/// Avatar monogramme style skeuomorphique (effet 3D, vernis, ombre).
/// Dégradé radial, ombre de flottaison, highlight interne.
class SkeuomorphicAvatar extends StatelessWidget {
  const SkeuomorphicAvatar({
    super.key,
    required this.name,
    this.size = 64.0,
    this.fontSize,
    this.imageUrl,
    this.imageProvider,
  });

  final String name;
  final double size;
  final double? fontSize;
  final String? imageUrl;
  final ImageProvider? imageProvider;

  static const List<Color> _baseColors = [
    Color(0xFFB1B6BE), // Gris
    Color(0xFFFF89A3), // Rose
    Color(0xFFFF7161), // Rouge
    Color(0xFFFFBA53), // Orange
    Color(0xFFFFD15C), // Jaune
    Color(0xFF80E08E), // Vert
    Color(0xFF7DD2FF), // Bleu
    Color(0xFFB69BFF), // Violet
  ];

  @override
  Widget build(BuildContext context) {
    final effectiveFontSize = fontSize ?? size * 0.375;
    final hasImage =
        imageUrl != null && imageUrl!.isNotEmpty || imageProvider != null;

    if (hasImage) {
      return _buildWithImage(effectiveFontSize);
    }
    return _buildSkeuomorphic(effectiveFontSize);
  }

  Widget _buildWithImage(double effectiveFontSize) {
    final monogram = _buildSkeuomorphic(effectiveFontSize);
    final provider =
        imageProvider ?? (imageUrl != null ? NetworkImage(imageUrl!) : null);

    if (provider == null) return monogram;

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                placeholder: (_, __) => monogram,
                errorWidget: (_, __, ___) => monogram,
              )
            : Image(
                image: provider,
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorBuilder: (_, __, ___) => monogram,
              ),
      ),
    );
  }

  Widget _buildSkeuomorphic(double effectiveFontSize) {
    final initials = name.initials;
    final baseColor = _baseColors[name.colorHash % _baseColors.length];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(0.0, -0.2),
          radius: 1.0,
          colors: [
            Color.lerp(baseColor, Colors.white, 0.15)!,
            Color.lerp(baseColor, Colors.black, 0.05)!,
          ],
          stops: const [0.0, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2),
            blurRadius: 4,
            spreadRadius: -1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.15),
                Colors.transparent,
              ],
            ),
          ),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                color: const Color(0xFFFBFBFB),
                fontSize: effectiveFontSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
