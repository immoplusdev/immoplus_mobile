import 'package:cached_network_image/cached_network_image.dart';
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

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: AspectRatio(
            aspectRatio: 1.70,
            child: FlutterCarousel(
              items: widget.images
                  .map((e) => Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey.shade200),
                        child: CachedNetworkImage(
                          imageUrl: Utils.getImagePath(id: e),
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            period: const Duration(milliseconds: 500),
                            child: Container(color: Colors.white),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            FontAwesomeIcons.images,
                            size: 100,
                            color: Colors.grey.shade400,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ))
                  .toList(),
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
                onPageChanged: (index, _) => _currentIndex.value = index,
              ),
            ),
          ),
        ),
        if (widget.images.isNotEmpty)
          Positioned(
            bottom: 10,
            right: 10,
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
