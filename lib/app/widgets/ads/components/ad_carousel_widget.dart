import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/widgets/ads/components/ad_tap.dart';
import 'package:shimmer/shimmer.dart';

import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/utils/utils.dart';

class AdCarouselWidget extends StatefulWidget {
  final AdCampaignModel campaign;

  const AdCarouselWidget({
    super.key,
    required this.campaign,
  });

  @override
  State<AdCarouselWidget> createState() => _AdCarouselWidgetState();
}

class _AdCarouselWidgetState extends State<AdCarouselWidget> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // viewportFraction < 1 → neighboring cards are partially visible.
    _pageController = PageController(viewportFraction: 0.72);
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) setState(() => _currentPage = page);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.campaign.media.images;
    if (images.isEmpty) return const SizedBox.shrink();

    // TODO: revert to real images once testing is done.
    final displayImages = images;
    // final displayImages = [
    //   "f15367ed-ae6d-487b-8452-c2ad0fc75926",
    //   "f15367ed-ae6d-487b-8452-c2ad0fc75926",
    //   "f15367ed-ae6d-487b-8452-c2ad0fc75926",
    //   "f15367ed-ae6d-487b-8452-c2ad0fc75926",
    //   "f15367ed-ae6d-487b-8452-c2ad0fc75926",
    // ];

    return Column(
      children: [
        // Title
        if (widget.campaign.content.title?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              widget.campaign.content.title!,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
                letterSpacing: -0.3,
              ),
            ),
          ),

        // Swipeable fan carousel
        SizedBox(
          height: 225,
          child: PageView.builder(
            controller: _pageController,
            itemCount: displayImages.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double pageOffset = 0;
                  if (_pageController.hasClients &&
                      _pageController.page != null) {
                    pageOffset =
                        (_pageController.page! - index).clamp(-1.0, 1.0);
                  }

                  // Left cards tilt left (−2.82°), right cards tilt right (+5.6°).
                  final rotationDeg = pageOffset > 0
                      ? -pageOffset * 2.82 // card is to the left of center
                      : -pageOffset * 5.6; // card is to the right of center

                  // Slight scale-down for non-center cards.
                  final scale = 1.0 - pageOffset.abs() * 0.06;

                  return Transform.scale(
                    scale: scale,
                    child: Transform.rotate(
                      angle: rotationDeg * math.pi / 180,
                      child: child,
                    ),
                  );
                },
                // child is rebuilt only when the image changes, not on every
                // scroll frame — keeps performance smooth.
                child: AdTap(
                  campaign: widget.campaign,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      imageUrl: Utils.getImagePath(id: displayImages[index]),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child:
                            const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Animated dots indicator
        if (displayImages.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(displayImages.length, (i) {
              final isActive = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF898989) : Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
