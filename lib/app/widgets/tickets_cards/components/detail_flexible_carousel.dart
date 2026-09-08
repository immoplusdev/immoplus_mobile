import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
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
  final Map<int, int> _retryKeys = {};
  int _lastPreloadedIndex = -1;
  int? _targetWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_targetWidth == null) {
      final dpr = MediaQuery.devicePixelRatioOf(context);
      final width = MediaQuery.sizeOf(context).width;
      // Detailed view can use slightly higher resolution but still limited to save memory
      _targetWidth = (width * dpr).toInt().clamp(0, 1200);
    }
    if (_lastPreloadedIndex == -1) {
      _preloadBatch(0);
    }
  }

  @override
  void didUpdateWidget(DetailFlexibleCarousel oldWidget) {
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
    final end = (start + 3).clamp(0, widget.images.length);

    final List<Future<void>> preloads = [];
    final List<String> newlyPreloaded = [];

    for (int i = start; i < end; i++) {
      final url = Utils.getImagePath(id: widget.images[i]);
      if (!_preloaded.contains(url)) {
        preloads.add(
          precacheImage(
            CachedNetworkImageProvider(url, maxWidth: _targetWidth),
            context,
          ).then((_) {
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
      fit: StackFit.expand,
      children: [
        FlutterCarousel.builder(
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            final imageId = widget.images[index];
            final url = Utils.getImagePath(id: imageId);
            final retryCount = _retryKeys[index] ?? 0;

            return GestureDetector(
              onTap: widget.onImageTap != null
                  ? () => widget.onImageTap!(imageId)
                  : null,
              onLongPress: () async {
                // TODO TO DEBUG
                await Clipboard.setData(ClipboardData(text: url));
              },
              child: Hero(
                tag: imageId,
                child: Container(
                  key: ValueKey('${url}_$retryCount'),
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.black.withOpacity(0.5),
                        AppColors.transparent
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0, 0.3],
                    ),
                  ),
                  width: double.infinity,
                  color: AppColors.grey100,
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
      baseColor: AppColors.grey300,
      highlightColor: AppColors.grey100,
      child: Container(color: AppColors.white),
    );
  }

  Widget _buildProgressIndicator(double? progress, String url) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildPlaceholder(),
      ],
    );
  }

  Widget _buildErrorWidget(int index) {
    return GestureDetector(
      onTap: () => _onRetry(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: AppColors.grey200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 50,
              color: AppColors.grey,
            ),
            SizedBox(height: 8),
            Text(
              "Erreur de chargement\nAppuyez pour réessayer",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
