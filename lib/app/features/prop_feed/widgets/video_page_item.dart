import 'dart:async';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:instagram_like_animation_button/instagram_like_animation_button.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:immoplus/app/features/prop_feed/feed_controller.dart';
import 'package:immoplus/app/features/prop_feed/video_model.dart';
import 'package:lottie/lottie.dart';
import 'package:immoplus/app/features/prop_feed/widgets/entity_action_button.dart';
import 'package:immoplus/app/features/prop_feed/widgets/side_action_button.dart';
import 'package:go_router/go_router.dart';

import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/furniture_detail/furniture_detail_page.dart';
import 'package:immoplus/app/features/prop_feed/widgets/reservation_bottom_sheet.dart';
import 'package:immoplus/app/features/prop_feed/widgets/social_post_header.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/utils/request_path.dart';

class VideoPageItem extends StatefulWidget {
  const VideoPageItem({
    super.key,
    required this.index,
    required this.controller,
    this.username,
    this.avatarUrl,
    this.avatarPath,
  });

  final int index;
  final VideoFeedController controller;
  final String? username;
  final String? avatarUrl;
  final String? avatarPath;

  @override
  State<VideoPageItem> createState() => _VideoPageItemState();
}

class _VideoPageItemState extends State<VideoPageItem>
    with SingleTickerProviderStateMixin {
  static String? _lastKnownThumbnail;

  bool _showPlayIcon = false;
  bool _isDescriptionExpanded = false;
  TapDownDetails? _tapDetails;
  final GlobalKey _likeKey = GlobalKey();
  late final AnimationController _iconAnim;
  Timer? _viewTimer;

  // static const double _overlayBottom = 1.0;

  @override
  void initState() {
    super.initState();
    _iconAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _cancelViewTimer();
    _iconAnim.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Timer de vue (3 s de lecture → video:view)
  // ---------------------------------------------------------------------------

  void _startViewTimer(String videoId) {
    _cancelViewTimer();
    _viewTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      widget.controller.sendViewEvent(videoId, 3000);
    });
  }

  void _cancelViewTimer() {
    _viewTimer?.cancel();
    _viewTimer = null;
  }

  // ---------------------------------------------------------------------------
  // Interactions
  // ---------------------------------------------------------------------------

  void _onTapPlayPause() {
    widget.controller.togglePlayPause(widget.index);
    setState(() {
      _showPlayIcon = true;
      _iconAnim.forward(from: 0.0);
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _showPlayIcon = false);
    });
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction >= 0.8 &&
        widget.controller.isVisible &&
        widget.controller.currentIndex == widget.index) {
      widget.controller.playAt(widget.index);
      final video = widget.controller.videos[widget.index];
      _startViewTimer(video.id);
    }
    if (info.visibleFraction < 0.1) {
      _cancelViewTimer();
      if (widget.controller.currentIndex != widget.index) {
        widget.controller.pauseAt(widget.index);
      }
    }
  }

  void _onShareTap(String videoId) {
    widget.controller.shareVideo(videoId);
  }

  /// Ouvre le bottom sheet Réserver avec récupération automatique des données via l'API.
  void _showReservationSheet(VideoModel video) {
    final entity = video.relatedTo?.entity;
    final id = video.relatedTo?.id;
    if (id == null || id.isEmpty) return;

    ReservationBottomSheet.showWithEntityData(
      context: context,
      entityId: id,
      entityType: entity ?? '',
      videoId: video.id,
      onReserve: () {
        // TODO: logique de réservation
      },
      onViewDetail: () {
        final String? route;
        switch (entity) {
          case 'residence':
            route = ResidencePage.route(id);
          case 'bien_immobilier':
            route = EstatePage.route(id);
          case 'furniture':
            route = FurnitureDetailPage.route(id);
          default:
            route = null;
        }
        if (route != null) context.push(route);
      },
      size: ReservationSheetSize(
        heightFactor: 0.40,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoFeedController>(
      id: 'video_${widget.index}',
      init: widget.controller,
      builder: (_) {
        final videoController =
            widget.controller.getVideoController(widget.index);
        final video = widget.controller.videos[widget.index];
        final isReady = widget.controller.isReadyAt(widget.index);
        final isPlaying = widget.controller.isPlayingAt(widget.index);
        final isLiked = widget.controller.getIsLikedForVideo(video.id);
        final likesCount = widget.controller.getLikesCountForVideo(video.id);

        return Stack(
          fit: StackFit.expand,
          children: [
            // Couche 1 : thumbnail précédent (fond permanent, jamais noir)
            if (_lastKnownThumbnail != null)
              CachedNetworkImage(
                imageUrl: _lastKnownThumbnail!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (_, __) => _buildImmoLoadingLayer(),
                errorWidget: (_, __, ___) => _buildImmoLoadingLayer(),
              )
            else
              _buildImmoLoadingLayer(),
            // Couche 2 : thumbnail actuel
            _buildThumbnail(video),
            // Couche 3 : vidéo (en dessous de l'overlay pour ne pas montrer du noir)
            Positioned.fill(
              child: VisibilityDetector(
                key: Key('video_${widget.index}'),
                onVisibilityChanged: _onVisibilityChanged,
                child: videoController == null
                    ? const SizedBox.expand()
                    : Video(
                        controller: videoController,
                        fit: BoxFit.contain,
                        fill: Colors.transparent,
                        controls: NoVideoControls,
                      ),
              ),
            ),
            // Couche 4 : overlay ImmoLoading PAR-DESSUS la vidéo
            // Disparaît dès que le player est prêt (preloaded → pas de loading)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: isReady,
                child: AnimatedOpacity(
                  opacity: isReady ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  child: _buildImmoLoadingLayer(),
                ),
              ),
            ),
            Positioned.fill(
              child: DoubleTapDetector(
                onTap: _onTapPlayPause,
                onDoubleTap: (details) =>
                    setState(() => _tapDetails = details),
                behavior: HitTestBehavior.translucent,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _showPlayIcon ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _iconAnim,
                          curve: Curves.easeOutBack,
                        ),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_tapDetails != null)
              ReelAnimationLike(
                key: ValueKey(_tapDetails),
                likeKey: _likeKey,
                position: _tapDetails!.globalPosition,
                config: const LikeAnimationConfig(
                  duration: Duration(milliseconds: 600),
                  hapticType: HapticFeedbackType.light,
                  scaleMax: 1.8,
                ),
                style: const LikeAnimationStyle(
                  iconSize: Size(70, 70),
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF2D55), Color(0xFFFF6B6B)],
                  ),
                ),
                onLikeCall: () {
                  if (!isLiked) {
                    widget.controller.toggleLike(video.id);
                  }
                },
                onCompleteAnimation: () =>
                    setState(() => _tapDetails = null),
              ),
            Positioned(
              left: 0,
              right: 72,
              bottom:-7,
              child: LayoutBuilder(
                builder: (context, constraints) => SocialPostHeader(
                  username: widget.username ??
                      video.author?.name ??
                      'Immoplus',
                  avatarUrl: widget.avatarUrl ?? video.author?.avatar,
                  avatarPath: widget.avatarPath,
                  date: _formatDate(video.createdAt),
                  verify: true,
                  caption: video.content?.description ??
                      video.content?.title ??
                      '',
                  hashtags: const [],
                  isExpanded: _isDescriptionExpanded,
                  contentMaxWidth: constraints.maxWidth,
                  contentMaxLines: 2,
                  onMoreTap: () => setState(
                      () => _isDescriptionExpanded = !_isDescriptionExpanded),
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  const SizedBox(height: 12),
                  GestureDetector(
                    key: _likeKey,
                    onTap: () => widget.controller.toggleLike(video.id),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isLiked ? Iconsax.heart5 : Iconsax.heart,
                          color: isLiked
                              ? const Color(0xFFFF2D55)
                              : Colors.white,
                          size: 24,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          _formatCount(likesCount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                color: Color(0x40000000),
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SideActionButton(
                    icon: Iconsax.link,
                    label: 'Partager',
                    onTap: () => _onShareTap(video.id),
                  ),
                  const SizedBox(height: 12),
                  _buildPriceBadge(video),
                  const SizedBox(height: 10),
                  if (video.relatedTo?.id != null)
                    EntityActionButton(
                      relatedTo: video.relatedTo,
                      onTap: () => _showReservationSheet(video),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String? _formatDate(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return null;
    try {
      final dt = DateTime.tryParse(createdAt);
      return dt != null ? DateFormat('yyyy-MM-dd').format(dt) : null;
    } catch (_) {
      return null;
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }

  Widget _buildPriceBadge(VideoModel video) {
    final price = video.content?.price;
    if (price == null || price.isEmpty) return const SizedBox.shrink();
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Fond noir + ImmoLoading Lottie (réutilisé pour éviter flash noir).
  Widget _buildImmoLoadingLayer() {
    return Container(
      color: const Color(0xFF111111),
      child: Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Lottie.asset(
            'assets/animations/immo-loading.json',
            fit: BoxFit.contain,
            repeat: true,
            reverse: false,
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(VideoModel video) {
    final thumbnailUrl = _getThumbnailUrl(video);
    if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: thumbnailUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (_, __) => _buildImmoLoadingLayer(),
        errorWidget: (_, __, ___) => _buildImmoLoadingLayer(),
        imageBuilder: (_, imageProvider) {
          _lastKnownThumbnail = thumbnailUrl;
          return Image(image: imageProvider, fit: BoxFit.cover);
        },
      );
    }
    return _buildImmoLoadingLayer();
  }

  /// Retourne l'URL de la miniature : thumbnailUrl si présent, sinon URL construite depuis miniature (UUID).
  static String? _getThumbnailUrl(VideoModel video) {
    if (video.thumbnailUrl != null && video.thumbnailUrl!.trim().isNotEmpty) {
      return video.thumbnailUrl;
    }
    if (video.miniature != null && video.miniature!.trim().isNotEmpty) {
      final baseUrl = RequestPath.baseUrl.trim();
      if (baseUrl.isNotEmpty) {
        return '$baseUrl/files/raw/public/${video.miniature}';
      }
    }
    return null;
  }
}
