import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/utils/ad_action_handler.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

/// Angles de rotation fixes par carte, pour l'effet "photos éparpillées"
const List<double> _kScatterAngles = [3.7, -2.82, 5.6];

/// Ratio hauteur/largeur des cartes du design Figma (192.19 / 168.53).
const double _kCardAspectRatio = 200.18636202070945 / 168.53266132511646;

const double _kCardViewportFraction = 0.42;

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
  final ScrollController _scrollController = ScrollController();
  bool _hasCentered = false;
  double _step = 0;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_step <= 0) return;
    final index = (_scrollController.offset / _step).round().clamp(0, 2);
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  /// Centre la carte du milieu (index 1) au premier affichage, pour que les
  /// cartes 1 et 3 débordent visiblement des bords de l'écran.
  void _centerMiddleCardOnce(double cardWidth, double gap) {
    if (_hasCentered) return;
    _hasCentered = true;
    final targetOffset = cardWidth + gap;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final maxOffset = _scrollController.position.maxScrollExtent;
      _scrollController.jumpTo(targetOffset.clamp(0, maxOffset));
    });
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.campaign.media.images.take(3).toList();
    if (images.isEmpty) return const SizedBox.shrink();

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
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
                letterSpacing: -0.3,
              ),
            ),
          ),

        // Photos éparpillées : cartes agrandies, scrollables horizontalement,
        // la 1ère et la dernière débordent des bords, celle du milieu est
        // centrée et entièrement visible par défaut.
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = 16.0;
            final viewportWidth = constraints.maxWidth;
            final cardWidth = viewportWidth * _kCardViewportFraction;
            final cardHeight = cardWidth * _kCardAspectRatio;
            final sidePadding = (viewportWidth - cardWidth) / 2;

            _step = cardWidth + gap;
            _centerMiddleCardOnce(cardWidth, gap);

            return SizedBox(
              // Marge verticale supplémentaire pour laisser respirer les
              // coins des cartes tournées (Transform.rotate ne change pas
              // la taille de layout, seulement le rendu).
              height: cardHeight + 24,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: sidePadding),
                    for (var i = 0; i < images.length; i++) ...[
                      if (i > 0) SizedBox(width: gap),
                      Transform.rotate(
                        angle: _kScatterAngles[i % _kScatterAngles.length] *
                            math.pi /
                            180,
                        child: Builder(builder: (cardContext) {
                          final card = Container(
                            width: cardWidth,
                            height: cardHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              // border: Border.all(
                              //   color: Colors.black.withValues(alpha: 0.06),
                              //   width: 0.5,
                              // ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              imageUrl: Utils.getImagePath(id: images[i]),
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
                                child: const Icon(Icons.broken_image,
                                    color: Colors.grey),
                              ),
                            ),
                          );

                          return GestureDetector(
                            onTap: () => AdActionHandler.handleCardAction(
                              cardContext,
                              widget.campaign,
                              cardIndex: i,
                            ),
                            child: card,
                          );
                        }),
                      ),
                    ],
                    SizedBox(width: sidePadding),
                  ],
                ),
              ),
            );
          },
        ),

        // Dots indicator
        if (images.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) {
              final isActive = i == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF898989)
                      : const Color(0xffD9D9D9),
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
