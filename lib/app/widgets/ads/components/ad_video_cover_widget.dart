import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:immoplus/app/utils/utils.dart';

class AdVideoCoverWidget extends StatefulWidget {
  final String videoID;
  final Widget Function(VoidCallback retry)? buildErrorWidget;

  const AdVideoCoverWidget({
    super.key,
    required this.videoID,
    this.buildErrorWidget,
  });

  @override
  State<AdVideoCoverWidget> createState() => _AdVideoCoverWidgetState();
}

class _AdVideoCoverWidgetState extends State<AdVideoCoverWidget> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final videoUrl = Utils.getVideoPath(id: widget.videoID);
    if (videoUrl == null || videoUrl.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'URL invalide';
        });
      }
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      await _controller!.initialize().timeout(const Duration(seconds: 15));
      
      if (!mounted) return;

      _controller!.setVolume(0); // Muted for autoplay carousel
      _controller!.setLooping(true);
      _controller!.play();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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

    if (_errorMessage != null || _controller == null) {
      if (widget.buildErrorWidget != null) {
        return widget.buildErrorWidget!(_initializeVideo);
      }
      return const Center(child: Icon(Icons.error));
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }
}
