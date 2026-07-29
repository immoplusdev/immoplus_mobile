import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_circle_avatar/ez_circle_avatar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:immoplus/app/extensions/string_extension.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class ProfileHearder extends StatelessWidget {
  final UserModelSchema? currentUser;
  final VoidCallback? onServiceClientPressed;

  const ProfileHearder({
    super.key,
    this.currentUser,
    this.onServiceClientPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: false, // Garde le header en haut lors du scroll
      floating: false,
      delegate: _HeaderDelegate(
        currentUser: currentUser,
        onServiceClientPressed: onServiceClientPressed,
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final UserModelSchema? currentUser;
  final VoidCallback? onServiceClientPressed;

  _HeaderDelegate({this.currentUser, this.onServiceClientPressed});

  /// Deux cas : avec photo → image (monogramme en placeholder pour éviter le fond bleu). Sans photo → monogramme.
  Widget _buildAvatar(
      {required String? imageUrl, required String monogramName}) {
    final monogram = EzCircleAvatar(
      name: monogramName,
      radius: 26,
    );
    final hasPhoto = imageUrl != null && imageUrl.isNotEmpty;
    if (!hasPhoto) {
      return monogram;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        memCacheWidth: 104,
        memCacheHeight: 104,
        fit: BoxFit.cover,
        width: 52,
        height: 52,
        placeholder: (context, url) => monogram,
        errorWidget: (context, url, error) => monogram,
      ),
    );
  }

  @override
  double get minExtent => 80; // Hauteur minimale
  @override
  double get maxExtent =>
      80; // Hauteur maximale (doit correspondre à la hauteur réelle)

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final fullName =
        '${currentUser?.firstName ?? ''} ${currentUser?.lastName ?? ''}'.trim();
    final imageUrl = currentUser?.avatar != null
        ? Utils.getImagePath(id: currentUser!.avatar!)
        : null;
    final email = currentUser?.email?.trim() ?? '';
    // Utilisateur inscrit uniquement : nom ou email pour l’affichage et le monogramme (si pas de photo).
    final displayLabel =
        fullName.isNotEmpty ? fullName : (email.isNotEmpty ? email : 'Invité');
    final monogramName =
        fullName.isNotEmpty ? fullName : (email.isNotEmpty ? email : 'Invité');

    return Container(
      alignment: Alignment.center,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(imageUrl: imageUrl, monogramName: monogramName),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      displayLabel.capitalizeFirst(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (email.isNotEmpty)
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF1E1E1E).withValues(alpha: 0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onServiceClientPressed,
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.headset,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Service client',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
