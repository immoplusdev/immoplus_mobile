import 'package:immoplus/app/design_system/design_system.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingLoadingCard extends StatelessWidget {
  const BookingLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 10),
      child: Shimmer.fromColors(
        baseColor: AppColors.immoBorderStrong,
        highlightColor: AppColors.immoBgSurfaceMuted,
        child: ListTile(
          tileColor: AppColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 70,
              height: 50,
              child: CachedNetworkImage(
                imageUrl:
                    "https://i.pinimg.com/736x/be/d5/8e/bed58e0fea0bec4c3924858a2a13cd5d.jpg", // Utils.getImagePath( ),

                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.immoBorderStrong,
                  highlightColor: AppColors.immoTextDisabled,
                  period: const Duration(milliseconds: 500),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: AppColors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover, // or other BoxFit values as per your design
              ),
            ),
          ),
          title: Text('••••••••'),
          subtitle: Text("••••••••••••••••••"),
          trailing: Text("••••"),
          titleTextStyle: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
          subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
