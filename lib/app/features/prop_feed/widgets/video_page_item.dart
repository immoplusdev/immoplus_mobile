import 'dart:io';
import 'dart:ui';

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
import 'package:immoplus/app/features/prop_feed/widgets/bounce_side_action_button.dart';
import 'package:immoplus/app/features/prop_feed/widgets/side_action_button.dart';
import 'package:immoplus/app/features/prop_feed/widgets/social_post_header.dart';
// import 'package:immoplus/app/features/prop_feed/widgets/urgency_badge.dart';

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
  bool _showPlayIcon = false;
  bool _isDescriptionExpanded = false;
  bool _isLiked = false;
  TapDownDetails? _tapDetails;
  final GlobalKey _likeKey = GlobalKey();
  late final AnimationController _iconAnim;
  Future<String?>? _localThumbnailFuture;

  static const double _overlayBottom = 4.0;

  @override
  void initState() {
    super.initState();
    _iconAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    final video = widget.controller.videos[widget.index];
    if (video.thumbnailUrl == null || video.thumbnailUrl!.isEmpty) {
      _localThumbnailFuture =
          widget.controller.getThumbnailPathForVideo(video.url);
    }
  }

  @override
  void dispose() {
    _iconAnim.dispose();
    super.dispose();
  }

  void _onTapPlayPause() {
    widget.controller.togglePlayPause(widget.index);
    setState(() {
      _showPlayIcon = true;
      _iconAnim.forward(from: 0.0);
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() => _showPlayIcon = false);
      }
    });
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction >= 0.8 &&
        widget.controller.isVisible &&
        widget.controller.currentIndex == widget.index) {
      widget.controller.playAt(widget.index);
    }
    if (info.visibleFraction < 0.1 &&
        widget.controller.currentIndex != widget.index) {
      widget.controller.pauseAt(widget.index);
    }
  }

  void _showBookingSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.38,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Reserver une visite',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Confirmer'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoFeedController>(
      id: 'video_${widget.index}',
      init: widget.controller,
      builder: (_) {
        final videoController =
            widget.controller.getVideoController(widget.index);
        final video = widget.controller.videos[widget.index];
        final isPlaying = widget.controller.isPlayingAt(widget.index);
        final isReady = widget.controller.isReadyAt(widget.index);

        return Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.black),
            if (!isReady) _buildThumbnail(video),
            Positioned.fill(
              child: VisibilityDetector(
                key: Key('video_${widget.index}'),
                onVisibilityChanged: _onVisibilityChanged,
                child: videoController == null
                    ? const SizedBox.expand()
                    : Video(
                        controller: videoController,
                        fit: BoxFit.contain,
                        controls: NoVideoControls,
                      ),
              ),
            ),
            if (!isReady)
              const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                ),
              ),
            Positioned.fill(
              child: DoubleTapDetector(
                onTap: _onTapPlayPause,
                onDoubleTap: (details) => setState(() => _tapDetails = details),
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
                  if (!_isLiked) {
                    setState(() => _isLiked = true);
                  }
                },
                onCompleteAnimation: () => setState(() => _tapDetails = null),
              ),
            Positioned(
              left: 0,
              right: 72,
              bottom: _overlayBottom,
              child: SocialPostHeader(
                username: widget.username ?? 'user_${widget.index + 1}',
                caption:
                    "Perched in a sanctuary of glass and steel, the dinner feels like a private viewing of the world's heartbeat. The electric blue of the twilight reflects off the obsidian table surface. Below, the city is a sea of diamonds-neon signs and moving headlights blurring into a kinetic symphony of light.",
                hashtags: const ['#RestaurantView', '#UrbanEscape'],
                isExpanded: _isDescriptionExpanded,
                onMoreTap: () {
                  setState(
                    () => _isDescriptionExpanded = !_isDescriptionExpanded,
                  );
                },
              ),
            ),
            Positioned(
              right: 8,
              bottom: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 12),
                  GestureDetector(
                    key: _likeKey,
                    onTap: () => setState(() => _isLiked = !_isLiked),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isLiked ? Iconsax.heart5 : Iconsax.heart,
                          color:
                              _isLiked ? const Color(0xFFFF2D55) : Colors.white,
                          size: 24,
                        ),
                        const SizedBox(height: 1),
                        const Text(
                          '1.2k',
                          style: TextStyle(
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
                  const SizedBox(height: 18),
                  const SideActionButton(
                    icon: Iconsax.link,
                    label: 'Partager',
                  ),
                  const SizedBox(height: 30),
                  _buildPriceBadge(),
                  const SizedBox(height: 12),
                  BounceSideActionButton(
                    label: 'Reserver',
                    onTap: _showBookingSheet,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceBadge() {
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
            child: const Text(
              '25.000 F/nuit',
              style: TextStyle(
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

  Widget _buildThumbnail(VideoModel video) {
    if (video.thumbnailUrl != null && video.thumbnailUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: video.thumbnailUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (_, __) => Container(color: Colors.black),
        errorWidget: (_, __, ___) => Container(color: Colors.black),
      );
    }
    return FutureBuilder<String?>(
      future: _localThumbnailFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done &&
            snap.hasData &&
            snap.data != null) {
          return Image.file(
            File(snap.data!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            gaplessPlayback: true,
          );
        }
        return Container(color: Colors.black);
      },
    );
  }
}
