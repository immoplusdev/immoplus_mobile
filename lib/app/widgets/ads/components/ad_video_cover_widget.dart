import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

import 'package:immoplus/app/features/prop_feed/video_repository.dart';
import 'package:immoplus/app/utils/utils.dart';

/// Affiche la miniature d'une vidéo du feed dans une carte de carrousel.
class AdVideoCoverWidget extends StatefulWidget {
  final String videoId;
  final Widget Function(VoidCallback retry)? buildErrorWidget;
  final VoidCallback? onTap;

  const AdVideoCoverWidget({
    super.key,
    required this.videoId,
    this.buildErrorWidget,
    this.onTap,
  });

  @override
  State<AdVideoCoverWidget> createState() => _AdVideoCoverWidgetState();
}

class _AdVideoCoverWidgetState extends State<AdVideoCoverWidget> {
  final VideoRepository _repository = VideoRepository();
  String? _thumbnailUrl;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final video = await _repository.fetchVideoDetail(widget.videoId);
    if (!mounted) return;

    final url = video?.thumbnailUrl?.isNotEmpty == true
        ? video!.thumbnailUrl
        : (video?.miniature?.isNotEmpty == true
            ? Utils.getImagePath(id: video!.miniature!)
            : null);

    setState(() {
      _thumbnailUrl = url;
      _isLoading = false;
      _hasError = url == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_hasError || _thumbnailUrl == null) {
      if (widget.buildErrorWidget != null) {
        return widget.buildErrorWidget!(_loadThumbnail);
      }
      return const Center(child: Icon(Icons.error));
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: _thumbnailUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(color: Colors.white),
            ),
            errorWidget: (context, url, error) {
              if (widget.buildErrorWidget != null) {
                return widget.buildErrorWidget!(_loadThumbnail);
              }
              return const Center(child: Icon(Icons.error));
            },
          ),
          // Signale que la carte est cliquable pour lancer la vidéo dans
          // le feed — pas de pause, rien ne joue ici (simple miniature).
          Center(
            child: IgnorePointer(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.play,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
