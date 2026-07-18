import 'dart:async';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:instagram_like_animation_button/instagram_like_animation_button.dart'; // Commenté : package incompatible avec Dart SDK 3.8.0 (requiert ^3.10.7)
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/features/prop_feed/feed_controller.dart';
import 'package:immoplus/app/features/prop_feed/video_model.dart';
import 'package:lottie/lottie.dart';
import 'package:immoplus/app/features/prop_feed/widgets/entity_action_button.dart';
import 'package:go_router/go_router.dart';

import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/furniture_detail/furniture_detail_page.dart';
import 'package:immoplus/app/features/prop_feed/widgets/reservation_bottom_sheet.dart';
import 'package:immoplus/app/features/prop_feed/widgets/social_post_header.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/utils/request_path.dart';

// ---------------------------------------------------------------------------
// Lottie loading widget — cached composition, const constructor, RepaintBoundary
// Avoids re-parsing the JSON on every rebuild (#4 optimization)
// ---------------------------------------------------------------------------
class _ImmoLoadingLayer extends StatelessWidget {
  const _ImmoLoadingLayer();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
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
      ),
    );
  }
}

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
  // NON-static : chaque VideoPageItem garde son propre thumbnail de fallback
  // (static causait un partage cross-widget → flashes visuels incorrects en boucle ×300)
  String? _lastKnownThumbnail;

  static String _stableCacheKey(String url) {
    if (url.trim().isEmpty) return url;
    final uri = Uri.tryParse(url);
    if (uri == null) return url.split('#').first.split('?').first;
    return uri.replace(query: '', fragment: '').toString();
  }

  // #1 — Use ValueNotifiers instead of setState to avoid full-tree rebuilds
  final ValueNotifier<bool> _showPlayIcon = ValueNotifier(false);
  final ValueNotifier<bool> _isDescriptionExpanded = ValueNotifier(false);
  final ValueNotifier<TapDownDetails?> _tapDetails = ValueNotifier(null);

  final GlobalKey _likeKey = GlobalKey();
  late final AnimationController _iconAnim;
  Timer? _viewTimer;

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
    _showPlayIcon.dispose();
    _isDescriptionExpanded.dispose();
    _tapDetails.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Timer de vue (3 s de lecture → video:view)
  // ---------------------------------------------------------------------------

  void _startViewTimer(String videoId, {String? relatedEntityId}) {
    _cancelViewTimer();
    _viewTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      widget.controller.sendViewEvent(videoId, 3000);
      widget.controller.cacheVideoInBackground(videoId);
      getIt<AnalyticsService>().logResidenceVideoPlayed(
        residenceId: relatedEntityId ?? '',
        videoId: videoId,
      );
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
    // #1 — Only rebuilds the play/pause icon, not the entire tree
    _showPlayIcon.value = true;
    _iconAnim.forward(from: 0.0);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _showPlayIcon.value = false;
    });
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction >= 0.8 &&
        widget.controller.isVisible &&
        widget.controller.currentIndex == widget.index) {
      widget.controller.playAt(widget.index);
      final video = widget.controller.videos[widget.index];
      _startViewTimer(video.id, relatedEntityId: video.relatedTo?.id);
    }
    if (info.visibleFraction < 0.1) {
      _cancelViewTimer();
      if (widget.controller.currentIndex != widget.index) {
        widget.controller.pauseAt(widget.index);
      }
    }
  }

  void _onShareTap(String videoId) {
    HapticFeedback.lightImpact(); // #10 — haptic on action
    widget.controller.shareVideo(videoId);
  }

  /// Ouvre le bottom sheet Réserver avec récupération automatique des données via l'API.
  void _showReservationSheet(VideoModel video) {
    final entity = video.relatedTo?.entity;
    final id = video.relatedTo?.id;
    if (id == null || id.isEmpty) return;

    HapticFeedback.mediumImpact(); // #10 — haptic on CTA

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
            // #6 — Remove thumbnail widgets from tree entirely when video is ready
            // #5 — RepaintBoundary on static layers
            if (!isReady) ...[
              // Couche 1 : thumbnail précédent (fond permanent, jamais noir)
              RepaintBoundary(
                child: _lastKnownThumbnail != null
                    ? CachedNetworkImage(
                        imageUrl: _lastKnownThumbnail!,
                        cacheKey: _stableCacheKey(_lastKnownThumbnail!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        // #7 — Limit memory cache size
                        memCacheWidth: (MediaQuery.sizeOf(context).width *
                                MediaQuery.devicePixelRatioOf(context))
                            .toInt(),
                        fadeInDuration: const Duration(milliseconds: 100),
                        placeholder: (_, __) => const _ImmoLoadingLayer(),
                        errorWidget: (_, __, ___) => const _ImmoLoadingLayer(),
                      )
                    : const _ImmoLoadingLayer(),
              ),
              // Couche 2 : thumbnail actuel
              RepaintBoundary(child: _buildThumbnail(context, video)),
              // Couche 4 : overlay ImmoLoading PAR-DESSUS (disparaît dès ready)
              const Positioned.fill(child: _ImmoLoadingLayer()),
            ],
            // Couche 3 : vidéo
            Positioned.fill(
              child: VisibilityDetector(
                key: Key('video_${widget.index}'),
                onVisibilityChanged: _onVisibilityChanged,
                child: videoController == null ||
                        !videoController.value.isInitialized
                    ? const SizedBox.expand()
                    : _buildVideoFit(videoController),
              ),
            ),
            // #22 — Video progress bar synced to actual video position/duration
            // if (isReady && videoController != null)
            //   Positioned(
            //     bottom: 0,
            //     left: 0,
            //     right: 0,
            //     child: RepaintBoundary(
            //       child: _VideoProgressBar(controller: videoController),
            //     ),
            //   ),
            // #1 — Play/pause icon isolated in ValueListenableBuilder
            // Commenté : DoubleTapDetector & ReelAnimationLike proviennent du package instagram_like_animation_button (incompatible avec Dart SDK 3.8.0)
            // Remplacé par un GestureDetector standard (simple tap = play/pause, double-tap = like)
            Positioned.fill(
              child: GestureDetector(
                onTap: _onTapPlayPause,
                onDoubleTapDown: (details) => _tapDetails.value = details,
                behavior: HitTestBehavior.translucent,
                child: Center(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _showPlayIcon,
                    builder: (_, show, child) => AnimatedOpacity(
                      opacity: show ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: child,
                    ),
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
            // #1 — Double-tap heart isolated in ValueListenableBuilder
            // ReelAnimationLike commenté (nécessite instagram_like_animation_button)
            // ValueListenableBuilder<TapDownDetails?>(
            //   valueListenable: _tapDetails,
            //   builder: (_, details, __) {
            //     if (details == null) return const SizedBox.shrink();
            //     return ReelAnimationLike(
            //       key: ValueKey(details),
            //       likeKey: _likeKey,
            //       position: details.globalPosition,
            //       config: const LikeAnimationConfig(
            //         duration: Duration(milliseconds: 600),
            //         hapticType: HapticFeedbackType.light,
            //         scaleMax: 1.8,
            //       ),
            //       style: const LikeAnimationStyle(
            //         iconSize: Size(70, 70),
            //         gradient: LinearGradient(
            //           colors: [Color(0xFFFF2D55), Color(0xFFFF6B6B)],
            //         ),
            //       ),
            //       onLikeCall: () {
            //         if (!isLiked) {
            //           widget.controller.toggleLike(video.id);
            //         }
            //       },
            //       onCompleteAnimation: () => _tapDetails.value = null,
            //     );
            //   },
            // ),
            // #1 — Description isolated in ValueListenableBuilder
            Positioned(
              left: 0,
              right: 72,
              bottom: -7,
              child: ValueListenableBuilder<bool>(
                valueListenable: _isDescriptionExpanded,
                builder: (_, expanded, __) => LayoutBuilder(
                  builder: (context, constraints) => SocialPostHeader(
                    username: video.content?.title ?? 'Immo Plus',
                    avatarUrl: widget.avatarUrl ?? video.author?.avatar,
                    avatarPath: widget.avatarPath,
                    date: _formatDate(video.createdAt),
                    location: video.content?.location,
                    verify: true,
                    caption: video.content?.description ??
                        video.content?.title ??
                        '',
                    hashtags: const [],
                    isExpanded: expanded,
                    contentMaxWidth: constraints.maxWidth,
                    contentMaxLines: 2,
                    onMoreTap: () => _isDescriptionExpanded.value = !expanded,
                  ),
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
                  // #14 — Like button with elasticOut scale animation
                  GestureDetector(
                    key: _likeKey,
                    onTap: () {
                      HapticFeedback.lightImpact(); // #10 — haptic on like
                      widget.controller.toggleLike(video.id);
                    },
                    child: TweenAnimationBuilder<double>(
                      key: ValueKey('like_${video.id}_$isLiked'),
                      tween: Tween(begin: 0.8, end: 1.0),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.elasticOut,
                      builder: (_, scale, child) =>
                          Transform.scale(scale: scale, child: child),
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
                              // #18 — tabularFigures prevents counter "dancing"
                              fontFeatures: [FontFeature.tabularFigures()],
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
                  ),
                  const SizedBox(height: 16),
                  // #15 — SideActionButton now uses bounce wrapper
                  _BounceSideAction(
                    icon: Iconsax.link,
                    label: 'Partager',
                    onTap: () => _onShareTap(video.id),
                  ),
                  const SizedBox(height: 12),
                  _buildPriceBadge(video),
                  const SizedBox(height: 10),
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

  // #8 — Use ValueKey(video.id) to prevent FadeInUp from re-triggering on rebuild
  // #9 — Reduce BackdropFilter sigma from 12 to 8
  Widget _buildPriceBadge(VideoModel video) {
    final price = video.content?.price;
    if (price == null || price.isEmpty) return const SizedBox.shrink();
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
                // #18 — tabularFigures for price stability
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Affiche la vidéo en plein écran (cover) pour les vidéos verticales
  /// et en ratio natif (contain) pour les vidéos horizontales.
  Widget _buildVideoFit(VideoPlayerController controller) {
    final aspectRatio = controller.value.aspectRatio;
    final isVertical = aspectRatio <= 0 || aspectRatio < 1.0;

    if (isVertical) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller),
          ),
        ),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: VideoPlayer(controller),
      ),
    );
  }

  // #7 — CachedNetworkImage with memCacheWidth
  Widget _buildThumbnail(BuildContext context, VideoModel video) {
    final thumbnailUrl = _getThumbnailUrl(video);
    if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: thumbnailUrl,
        cacheKey: _stableCacheKey(thumbnailUrl),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        memCacheWidth: (MediaQuery.sizeOf(context).width *
                MediaQuery.devicePixelRatioOf(context))
            .toInt(),
        fadeInDuration: const Duration(milliseconds: 100),
        placeholder: (_, __) => const _ImmoLoadingLayer(),
        errorWidget: (_, __, ___) => const _ImmoLoadingLayer(),
        imageBuilder: (_, imageProvider) {
          _lastKnownThumbnail = thumbnailUrl;
          return Image(image: imageProvider, fit: BoxFit.cover);
        },
      );
    }
    return const _ImmoLoadingLayer();
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

// ---------------------------------------------------------------------------
// Progress bar synchronisée avec la position réelle de la vidéo.
// Écoute directement le VideoPlayerController via addListener → mise à jour
// frame par frame sans polling. Seule la barre est redessinée (ValueNotifier).
// ---------------------------------------------------------------------------
class _VideoProgressBar extends StatefulWidget {
  const _VideoProgressBar({required this.controller});
  final VideoPlayerController controller;

  @override
  State<_VideoProgressBar> createState() => _VideoProgressBarState();
}

class _VideoProgressBarState extends State<_VideoProgressBar> {
  final ValueNotifier<double> _progress = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onVideoUpdate);
  }

  @override
  void didUpdateWidget(_VideoProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onVideoUpdate);
      widget.controller.addListener(_onVideoUpdate);
      _progress.value = 0.0;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onVideoUpdate);
    _progress.dispose();
    super.dispose();
  }

  void _onVideoUpdate() {
    final duration = widget.controller.value.duration;
    final position = widget.controller.value.position;
    if (duration.inMilliseconds <= 0) {
      _progress.value = 0.0;
      return;
    }
    _progress.value =
        (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: _progress,
      builder: (_, value, __) => LinearProgressIndicator(
        value: value,
        backgroundColor: Colors.white.withValues(alpha: 0.15),
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.white.withValues(alpha: 0.85),
        ),
        minHeight: 2.5,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// #15 — Bounce wrapper for SideActionButton (was missing animation on Partager)
// #19 — Uses ValueNotifier<bool> instead of setState for the press state
// ---------------------------------------------------------------------------
class _BounceSideAction extends StatelessWidget {
  const _BounceSideAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _BounceWrapper(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 18,
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable bounce wrapper using ValueNotifier (no setState)
// ---------------------------------------------------------------------------
class _BounceWrapper extends StatefulWidget {
  const _BounceWrapper({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_BounceWrapper> createState() => _BounceWrapperState();
}

class _BounceWrapperState extends State<_BounceWrapper> {
  final ValueNotifier<bool> _pressed = ValueNotifier(false);

  @override
  void dispose() {
    _pressed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressed.value = true,
      onTapUp: (_) => _pressed.value = false,
      onTapCancel: () => _pressed.value = false,
      onTap: widget.onTap,
      child: ValueListenableBuilder<bool>(
        valueListenable: _pressed,
        builder: (_, pressed, child) => AnimatedScale(
          scale: pressed ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutBack,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
