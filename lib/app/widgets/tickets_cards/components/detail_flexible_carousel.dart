import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/image_counter_badge.dart';
import 'package:shimmer/shimmer.dart';

class DetailFlexibleCarousel extends StatefulWidget {
  final List<String> images;
  final void Function(String imageId)? onImageTap;

  const DetailFlexibleCarousel({
    super.key,
    required this.images,
    this.onImageTap,
  });

  @override
  State<DetailFlexibleCarousel> createState() => _DetailFlexibleCarouselState();
}

class _DetailFlexibleCarouselState extends State<DetailFlexibleCarousel> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        FlutterCarousel(
          items: widget.images.map<Widget>((e) {
            return GestureDetector(
              onTap: widget.onImageTap != null
                  ? () => widget.onImageTap!(e)
                  : null,
              child: Hero(
                tag: e,
                child: Container(
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade700, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0, 0.4],
                    ),
                  ),
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: Utils.getImagePath(id: e),
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade400,
                      period: const Duration(milliseconds: 500),
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (_, __, ___) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }).toList(),
          options: FlutterCarouselOptions(
            aspectRatio: 1,
            viewportFraction: 1.0,
            initialPage: 0,
            enableInfiniteScroll: widget.images.length > 1,
            autoPlay: false,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            showIndicator: false,
            floatingIndicator: false,
            indicatorMargin: 20,
            onPageChanged: (index, _) => _currentIndex.value = index,
          ),
        ),
        if (widget.images.isNotEmpty)
          Positioned(
            bottom: 12,
            right: 12,
            child: ValueListenableBuilder<int>(
              valueListenable: _currentIndex,
              builder: (context, index, _) => ImageCounterBadge(
                current: index + 1,
                total: widget.images.length,
              ),
            ),
          ),
      ],
    );
  }
}
