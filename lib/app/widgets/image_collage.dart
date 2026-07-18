import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';

class ImageCollage extends StatelessWidget {
  final List<String> images;
  final double width;
  final double height;
  final double borderRadius;
  final double spacing;
  final VoidCallback? onTap;

  const ImageCollage({
    super.key,
    required this.images,
    this.width = double.infinity,
    this.height = 300,
    this.borderRadius = 16,
    this.spacing = 2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (images.isEmpty) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: _buildImageWidget(''),
      );
    } else if (images.length == 1) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: _buildImageWidget(images[0]),
      );
    } else if (images.length == 2) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Column(
          children: [
            Expanded(child: _buildImageWidget(images[0])),
            Gap(spacing),
            Expanded(child: _buildImageWidget(images[1])),
          ],
        ),
      );
    } else {
      // 3 or more images
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Column(
          children: [
            Expanded(child: _buildImageWidget(images[0])),
            Gap(spacing),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildImageWidget(images[1])),
                  Gap(spacing),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildImageWidget(images[2]),
                        if (images.length > 3)
                          Container(
                            color: Colors.black.withOpacity(0.4),
                            child: Center(
                              child: Text(
                                '+${images.length - 3}',
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

  Widget _buildImageWidget(String imageId) {
    if (imageId.isEmpty) {
      return Container(
        color: Colors.grey.shade100,
        child: const Icon(Icons.image_outlined, color: Colors.grey, size: 20),
      );
    }
    return CachedNetworkImage(
      imageUrl: Utils.getImagePath(id: imageId),
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
