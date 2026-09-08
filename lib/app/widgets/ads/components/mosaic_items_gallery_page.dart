import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/configs/app_typography.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/image_collage.dart';
import 'package:shimmer/shimmer.dart';

class MosaicGalleryExtra {
  final List<CollageItem> items;
  final String? title;
  final String? tag;

  const MosaicGalleryExtra({
    required this.items,
    this.title,
    this.tag,
  });
}

class MosaicItemsGalleryPage extends StatefulWidget {
  static const String routeName = 'mosaic_gallery';
  static const String routePath = '/mosaic_gallery';

  final List<CollageItem> items;
  final String? title;
  final String? tag;

  const MosaicItemsGalleryPage({
    super.key,
    required this.items,
    this.title,
    this.tag,
  });

  @override
  State<MosaicItemsGalleryPage> createState() => _MosaicItemsGalleryPageState();
}

class _MosaicItemsGalleryPageState extends State<MosaicItemsGalleryPage> {
  final Random _random = Random(42); // Deterministic seed for consistent layout
  int _previousWidth = 1;

  @override
  Widget build(BuildContext context) {
    final body = Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: AppColors.borderLight,
            radius: 18,
            child: const Icon(
              CupertinoIcons.chevron_back,
              color: AppColors.black,
              size: 20,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: widget.title?.isNotEmpty == true
            ? Text(
                widget.title!,
                style: AppTypography.h4.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textNavyDeep,
                ),
              )
            : null,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          physics: const BouncingScrollPhysics(),
          child: StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: widget.items.asMap().entries.map((entry) {
              final item = entry.value;

              final width = (_previousWidth == 2)
                  ? 2
                  : _random.nextBool()
                      ? 2
                      : 4;
              _previousWidth = width;
              final mainAxisCount = _random.nextInt(2) + 2;

              return StaggeredGridTile.count(
                crossAxisCellCount: width,
                mainAxisCellCount: mainAxisCount,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GestureDetector(
                    onTap: item.onTap,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: AppColors.grey200,
                            highlightColor: AppColors.grey100,
                            child: Container(
                              color: AppColors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.grey200,
                            child: const Icon(
                              Icons.broken_image,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );

    if (widget.tag != null) {
      return Hero(tag: widget.tag!, child: body);
    }

    return body;
  }
}
