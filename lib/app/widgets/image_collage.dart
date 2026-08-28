import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';

class CollageItem {
  final String image;
  final VoidCallback? onTap;

  const CollageItem({
    required this.image,
    this.onTap,
  });

  bool get isUrl => image.startsWith('http');

  String get imageUrl =>
      image.isEmpty ? '' : (isUrl ? image : Utils.getImagePath(id: image));
}

class ImageCollage extends StatelessWidget {
  final List<String>? images;
  final List<CollageItem>? items;
  final double width;
  final double height;
  final double borderRadius;
  final double spacing;
  final VoidCallback? onTap;

  const ImageCollage({
    super.key,
    this.images,
    this.items,
    this.width = double.infinity,
    this.height = 300,
    this.borderRadius = 16,
    this.spacing = 2,
    this.onTap,
  }) : assert(
          (images != null && items == null) || (items != null && images == null),
          'Provide either images or items, but not both.',
        );

  List<CollageItem> get _effectiveItems {
    if (items != null) return items!;
    if (images != null) {
      return images!.map((img) => CollageItem(image: img)).toList();
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final effectiveItems = _effectiveItems;
    Widget content;

    if (effectiveItems.isEmpty) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: _buildItemWidget(const CollageItem(image: '')),
      );
    } else if (effectiveItems.length == 1) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: _buildItemWidget(effectiveItems[0]),
      );
    } else if (effectiveItems.length == 2) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Column(
          children: [
            Expanded(child: _buildItemWidget(effectiveItems[0])),
            Gap(spacing),
            Expanded(child: _buildItemWidget(effectiveItems[1])),
          ],
        ),
      );
    } else if (effectiveItems.length == 3) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Column(
          children: [
            Expanded(child: _buildItemWidget(effectiveItems[0])),
            Gap(spacing),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildItemWidget(effectiveItems[1])),
                  Gap(spacing),
                  Expanded(child: _buildItemWidget(effectiveItems[2])),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // 4 or more images: 2x2 asymmetric grid
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Column(
          children: [
            // Row 1 (60% / 40%)
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  Expanded(flex: 6, child: _buildItemWidget(effectiveItems[0])),
                  Gap(spacing),
                  Expanded(flex: 4, child: _buildItemWidget(effectiveItems[1])),
                ],
              ),
            ),
            Gap(spacing),
            // Row 2 (35% / 65%)
            Expanded(
              flex: 11,
              child: Row(
                children: [
                  Expanded(flex: 35, child: _buildItemWidget(effectiveItems[2])),
                  Gap(spacing),
                  Expanded(
                    flex: 65,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildItemWidget(effectiveItems[3]),
                        if (effectiveItems.length > 4)
                          Container(
                            color: Colors.black.withValues(alpha: 0.4),
                            child: Center(
                              child: Text(
                                '+${effectiveItems.length - 4}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: content,
      ),
    );
  }

  Widget _buildItemWidget(CollageItem item) {
    final imageWidget = _buildImageWidget(item);
    if (item.onTap != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: item.onTap,
        child: imageWidget,
      );
    }
    return imageWidget;
  }

  Widget _buildImageWidget(CollageItem item) {
    if (item.image.isEmpty) {
      return Container(
        color: Colors.grey.shade100,
        child: const Icon(Icons.image_outlined, color: Colors.grey, size: 20),
      );
    }

    return CachedNetworkImage(
      imageUrl: item.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Container(
        color: Colors.grey.shade100,
        child: const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.broken_image_outlined,
          color: Colors.grey,
          size: 16,
        ),
      ),
    );
  }
}
