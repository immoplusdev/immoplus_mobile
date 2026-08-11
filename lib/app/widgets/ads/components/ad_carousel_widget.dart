import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/utils/ad_action_handler.dart';
import 'package:immoplus/app/utils/utils.dart';

class _Constants {
  static const double borderRadius = 20.0;
  static const double badgeRadius = 6.0;
  static const double badgePaddingHorizontal = 8.0;
  static const double badgePaddingVertical = 4.0;
  static const double spacing = 8.0;
  static const double carouselHeight = 200.0;
  static const double titleFontSizeCollapsed = 12.0;
  static const double titleFontSizeExpanded = 14.0;
  static const double subtitleFontSize = 11.0;
  static const double badgeFontSize = 10.0;
  static const double ctaFontSize = 10.0;

  static const double expandedFlexRatio = 0.60;
  static const double collapsedFlexRatioBase = 0.40;

  static const int animationDurationMs = 350;
  static const int opacityDurationMs = 300;

  static const Color primaryBlue = Color(0xFF2548E5);
  static const Color darkText = Color(0xFF222222);
}

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
  int _expandedCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.campaign.media.images;
    if (images.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                if (widget.campaign.content.badge != null &&
                    widget.campaign.content.badge!.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _Constants.badgePaddingHorizontal,
                      vertical: _Constants.badgePaddingVertical,
                    ),
                    decoration: BoxDecoration(
                      color: _Constants.primaryBlue.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(_Constants.badgeRadius),
                    ),
                    child: Text(
                      widget.campaign.content.badge!,
                      style: GoogleFonts.dmSans(
                        color: _Constants.primaryBlue,
                        fontSize: _Constants.badgeFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Gap(8),
                ],
                Expanded(
                  child: Text(
                    widget.campaign.content.title ?? '',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _Constants.darkText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: _Constants.carouselHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth -
                      (_Constants.spacing * (images.length - 1));

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < images.length; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_expandedCarouselIndex == i) {
                                AdActionHandler.handleAdAction(
                                    context, widget.campaign);
                              } else {
                                _expandedCarouselIndex = i;
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(
                                milliseconds: _Constants.animationDurationMs),
                            curve: Curves.fastOutSlowIn,
                            width: i == _expandedCarouselIndex
                                ? availableWidth * _Constants.expandedFlexRatio
                                : availableWidth *
                                    (_Constants.collapsedFlexRatioBase /
                                        (images.length - 1)),
                            margin: EdgeInsets.only(
                                right: i == images.length - 1
                                    ? 0
                                    : _Constants.spacing),
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    _Constants.borderRadius),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          Utils.getImagePath(id: images[i]),
                                      fit: BoxFit.cover,
                                      color: Colors.black.withOpacity(0.35),
                                      colorBlendMode: BlendMode.srcOver,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AnimatedRotation(
                                            turns: i == _expandedCarouselIndex
                                                ? 0
                                                : -0.25,
                                            duration: const Duration(
                                                milliseconds: _Constants
                                                    .animationDurationMs),
                                            curve: Curves.fastOutSlowIn,
                                            child: Text(
                                              widget.campaign.content.title ??
                                                  'Ad',
                                              style: GoogleFonts.dmSans(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: i ==
                                                        _expandedCarouselIndex
                                                    ? _Constants
                                                        .titleFontSizeExpanded
                                                    : _Constants
                                                        .titleFontSizeCollapsed,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (i == _expandedCarouselIndex) ...[
                                            const SizedBox(height: 4),
                                            AnimatedOpacity(
                                              opacity:
                                                  i == _expandedCarouselIndex
                                                      ? 1.0
                                                      : 0.0,
                                              duration: const Duration(
                                                  milliseconds: _Constants
                                                      .opacityDurationMs),
                                              child: Text(
                                                widget.campaign.content
                                                        .subtitle ??
                                                    '',
                                                style: GoogleFonts.dmSans(
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  fontSize: _Constants
                                                      .subtitleFontSize,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (widget.campaign.content
                                                        .ctaLabel !=
                                                    null &&
                                                widget.campaign.content
                                                    .ctaLabel!.isNotEmpty) ...[
                                              const Gap(8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  widget.campaign.content
                                                      .ctaLabel!,
                                                  style: GoogleFonts.dmSans(
                                                    color:
                                                        _Constants.primaryBlue,
                                                    fontSize:
                                                        _Constants.ctaFontSize,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
