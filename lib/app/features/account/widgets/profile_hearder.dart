import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/contact_utils.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHearder extends StatelessWidget {
  final UserModelSchema? currentUser;
  const ProfileHearder({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true, // Garde le header en haut lors du scroll
      floating: false,
      delegate: _HeaderDelegate(currentUser: currentUser),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final UserModelSchema? currentUser;

  _HeaderDelegate({this.currentUser});

  @override
  double get minExtent => 80; // Hauteur minimale
  @override
  double get maxExtent =>
      80; // Hauteur maximale (doit correspondre à la hauteur réelle)

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      height: 80, // Assurez-vous que c'est bien la même hauteur que `maxExtent`
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Gap(8),
          SizedBox(
            height: 70,
            width: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: CachedNetworkImage(
                imageUrl: (currentUser!.avatar != null)
                    ? Utils.getImagePath(id: currentUser!.avatar!)
                    : "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg",
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade400,
                  period: const Duration(milliseconds: 500),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentUser!.firstName.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  currentUser!.lastName.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              ContactUtils.showContact();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.green.shade50,
                  child: const Icon(Icons.phone, color: Colors.green),
                ),
                const SizedBox(height: 4),
                Text(
                  'Support Client',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // const Gap(8),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
