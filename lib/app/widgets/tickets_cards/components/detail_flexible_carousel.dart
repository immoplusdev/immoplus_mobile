import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
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
  final Set<String> _preloaded = {};
  int _lastPreloadedIndex = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_lastPreloadedIndex == -1) {
      _preloadBatch(0);
    }
  }

  @override
  void didUpdateWidget(DetailFlexibleCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.images, oldWidget.images)) {
      _preloaded.clear();
      _lastPreloadedIndex = -1;
      _preloadBatch(0);
    }
  }

  void _preloadBatch(int start) {
    if (widget.images.isEmpty) return;
    final end = (start + 5).clamp(0, widget.images.length);
    for (int i = start; i < end; i++) {
      final url = Utils.getImagePath(id: widget.images[i]);
      if (!_preloaded.contains(url)) {
        precacheImage(
          CachedNetworkImageProvider(url),
          context,
        ).then((_) {
          if (mounted) {
            setState(() => _preloaded.add(url));
          }
        }).catchError((e) {
          debugPrint('Error preloading image: $e');
        });
      }
    }
    _lastPreloadedIndex = end - 1;
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FlutterCarousel.builder(
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            final imageId = widget.images[index];
            final url = Utils.getImagePath(id: imageId);
            final isCached = _preloaded.contains(url);

            return GestureDetector(
              onTap: widget.onImageTap != null
                  ? () => widget.onImageTap!(imageId)
                  : null,
              child: Hero(
                tag: imageId,
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
                  color: Colors.grey.shade100,
                  child: isCached
                      ? Image(
                          image: CachedNetworkImageProvider(url),
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildErrorWidget(),
                        )
                      : CachedNetworkImage(
                          imageUrl: url,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          placeholder: (context, url) => _buildPlaceholder(),
                          errorWidget: (context, url, error) =>
                              _buildErrorWidget(),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            );
          },
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
            onPageChanged: (index, _) {
              _currentIndex.value = index;
              if (index >= _lastPreloadedIndex - 1 &&
                  _lastPreloadedIndex < widget.images.length - 1) {
                _preloadBatch(_lastPreloadedIndex + 1);
              }
            },
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: ValueListenableBuilder<int>(
            valueListenable: _currentIndex,
            builder: (context, index, _) => ImageCounterBadge(
              current: (index % widget.images.length) + 1,
              total: widget.images.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(color: Colors.white),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.error,
        size: 50,
        color: Colors.grey,
      ),
    );
  }
}
