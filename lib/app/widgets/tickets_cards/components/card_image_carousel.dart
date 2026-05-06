import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/image_counter_badge.dart';
import 'package:shimmer/shimmer.dart';

class CardImageCarousel extends StatefulWidget {
  final List<String> images;

  const CardImageCarousel({required this.images});

  @override
  State<CardImageCarousel> createState() => _CardImageCarouselState();
}

class _CardImageCarouselState extends State<CardImageCarousel> {
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
  void didUpdateWidget(CardImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Use listEquals to avoid clearing cache when the list content is the same
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
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: AspectRatio(
            aspectRatio: 1.70,
            child: FlutterCarousel.builder(
              itemCount: widget.images.length,
              itemBuilder: (context, index, realIndex) {
                final url = Utils.getImagePath(id: widget.images[index]);
                final isCached = _preloaded.contains(url);

                // Use Image.network with provider directly if already preloaded
                // to avoid CachedNetworkImage's internal state machine (shimmer/fade issues)
                return Container(
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
                );
              },
              options: FlutterCarouselOptions(
                aspectRatio: 1,
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: widget.images.length > 1,
                reverse: false,
                autoPlay: false,
                enlargeCenterPage: false,
                scrollDirection: Axis.horizontal,
                showIndicator: false,
                indicatorMargin: 20,
                slideIndicator: CircularSlideIndicator(
                  slideIndicatorOptions: const SlideIndicatorOptions(
                    indicatorRadius: 4,
                    enableHalo: true,
                    enableAnimation: true,
                    itemSpacing: 12,
                  ),
                ),
                onPageChanged: (index, _) {
                  _currentIndex.value = index;
                  // Preload next batch if we reach the second-to-last preloaded image
                  if (index >= _lastPreloadedIndex - 1 &&
                      _lastPreloadedIndex < widget.images.length - 1) {
                    _preloadBatch(_lastPreloadedIndex + 1);
                  }
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
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
      child: Icon(
        FontAwesomeIcons.images,
        size: 50,
        color: Colors.grey.shade400,
      ),
    );
  }
}
