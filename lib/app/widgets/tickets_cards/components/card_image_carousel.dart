import 'dart:developer';

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
  // Track retry count per image index to force reload on error
  final Map<int, int> _retryKeys = {};
  int _lastPreloadedIndex = -1;

  // Target width for memory optimization (approx. screen width * dpr)
  int? _targetWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_targetWidth == null) {
      final dpr = MediaQuery.devicePixelRatioOf(context);
      final width = MediaQuery.sizeOf(context).width;
      // We limit to approx 1000px for carousels to save RAM while keeping quality
      _targetWidth = (width * dpr).toInt().clamp(0, 1000);
    }
    if (_lastPreloadedIndex == -1) {
      _preloadBatch(0);
    }
  }

  @override
  void didUpdateWidget(CardImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.images, oldWidget.images)) {
      _preloaded.clear();
      _retryKeys.clear();
      _lastPreloadedIndex = -1;
      _preloadBatch(0);
    }
  }

  Future<void> _preloadBatch(int start) async {
    if (widget.images.isEmpty) return;
    final end = (start + 3)
        .clamp(0, widget.images.length); // Reduced to 3 to be less aggressive

    final List<Future<void>> preloads = [];
    final List<String> newlyPreloaded = [];

    for (int i = start; i < end; i++) {
      final url = Utils.getImagePath(id: widget.images[i]);
      if (!_preloaded.contains(url)) {
        final provider = CachedNetworkImageProvider(
          url,
          maxWidth: _targetWidth, // Optimization: only preload what we need
        );

        preloads.add(
          precacheImage(provider, context).then((_) {
            newlyPreloaded.add(url);
          }).catchError((e) {
            debugPrint('Error preloading image: $e');
          }),
        );
      }
    }

    if (preloads.isNotEmpty) {
      await Future.wait(preloads);
      if (mounted && newlyPreloaded.isNotEmpty) {
        // Only one setState for the whole batch
        setState(() => _preloaded.addAll(newlyPreloaded));
      }
    }
    _lastPreloadedIndex = end - 1;
  }

  void _onRetry(int index) {
    setState(() {
      _retryKeys[index] = (_retryKeys[index] ?? 0) + 1;
    });
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
                final retryCount = _retryKeys[index] ?? 0;

                return Container(
                  key: ValueKey('${url}_$retryCount'),
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: CachedNetworkImage(
                    imageUrl: url,
                    memCacheWidth: _targetWidth,
                    fadeInDuration: const Duration(milliseconds: 200),
                    progressIndicatorBuilder: (context, url, progress) =>
                        _buildProgressIndicator(progress.progress, url),
                    errorWidget: (context, url, error) =>
                        _buildErrorWidget(index),
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
                onPageChanged: (index, _) {
                  _currentIndex.value = index;
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

  Widget _buildProgressIndicator(double? progress, String url) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildPlaceholder(),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     SizedBox(
        //       width: 30,
        //       height: 30,
        //       child: CircularProgressIndicator(
        //         value: progress,
        //         strokeWidth: 2,
        //         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
        //       ),
        //     ),
        //     const SizedBox(height: 10),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20),
        //       child: SelectableText(
        //         url,
        //         textAlign: TextAlign.center,
        //         style: const TextStyle(
        //           fontSize: 8,
        //           color: Colors.black54,
        //           backgroundColor: Colors.white70,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildErrorWidget(int index) {
    return GestureDetector(
      onTap: () => _onRetry(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.grey.shade200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.circleExclamation.data,
              size: 40,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              "Erreur de chargement\nAppuyez pour réessayer",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
