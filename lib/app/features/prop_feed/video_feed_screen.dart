import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'package:immoplus/app/features/prop_feed/feed_controller.dart';
import 'package:immoplus/app/features/prop_feed/widgets/top_nav_bar.dart';
import 'package:immoplus/app/features/prop_feed/widgets/video_page_item.dart';

/// Style de la barre d'état : icônes blanches sur fond noir.
const _statusBarStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

/// Écran principal du feed vidéo (Vivre). Scroll infini : boucle à la fin.
class VideoFeedView extends StatefulWidget {
  const VideoFeedView({super.key});

  @override
  State<VideoFeedView> createState() => _VideoFeedViewState();
}

class _VideoFeedViewState extends State<VideoFeedView>
    with WidgetsBindingObserver {
  static const int _loopMultiplier = 300;

  late final PreloadPageController _pageController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final controller = Get.isRegistered<VideoFeedController>()
        ? Get.find<VideoFeedController>()
        : Get.put(VideoFeedController(), permanent: true);
    controller.onFeedVisible();
    final n = controller.videos.length;
    final mid = n > 0 ? n * (_loopMultiplier ~/ 2) : 0;
    _pageController = PreloadPageController(initialPage: mid);
    if (controller.hasBeenHidden) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _jumpToRandomPage();
        controller.clearHasBeenHidden();
      });
    }
  }

  void _jumpToRandomPage() {
    final controller = Get.find<VideoFeedController>();
    final n = controller.videos.length;
    if (n == 0) return;
    final randomVideoIndex = controller.getRandomNextIndex();
    final mid = n * (_loopMultiplier ~/ 2);
    final base = (mid ~/ n) * n + randomVideoIndex;
    final targetPage = base >= mid ? base : base + n;
    _pageController.jumpToPage(targetPage);
    controller.onPageChanged(randomVideoIndex);
  }

  void onFeedVisible() {
    final controller = Get.find<VideoFeedController>();
    controller.onFeedVisible();
    if (controller.hasBeenHidden) {
      _jumpToRandomPage();
      controller.clearHasBeenHidden();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    if (Get.isRegistered<VideoFeedController>()) {
      Get.find<VideoFeedController>().onFeedHidden();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!Get.isRegistered<VideoFeedController>()) return;
    final controller = Get.find<VideoFeedController>();
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        controller.onFeedHidden();
        controller.saveSessionTimestamp(); // fire-and-forget
        break;
      case AppLifecycleState.resumed:
        _handleAppResumed();
        break;
    }
  }

  Future<void> _handleAppResumed() async {
    if (!Get.isRegistered<VideoFeedController>()) return;
    final controller = Get.find<VideoFeedController>();
    await controller.onAppResumed();
    if (!mounted) return;
    // _refreshFeed() laisse _hasBeenHidden=true → saut aléatoire
    // _resumeCurrentPlayer() le met à false → pas de saut
    if (controller.hasBeenHidden) {
      _jumpToRandomPage();
      controller.clearHasBeenHidden();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoFeedController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusBarStyle,
      child: Scaffold(
        backgroundColor: const Color(0xFF111111),
        body: SafeArea(
          top: true,
          bottom: true,
          right: false,
          left: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Obx(() {
                final n = controller.videos.length;
                final count = n > 0 ? n * _loopMultiplier : 0;
                if (count == 0) {
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
                return PreloadPageView.builder(
                  controller: _pageController,
                  preloadPagesCount: 2,
                  scrollDirection: Axis.vertical,
                  itemCount: count,
                  onPageChanged: (pageIndex) =>
                      controller.onPageChanged(pageIndex % n),
                  itemBuilder: (context, pageIndex) {
                    final videoIndex = pageIndex % n;
                    return VideoPageItem(
                      key: ValueKey<int>(videoIndex),
                      index: videoIndex,
                      controller: controller,
                    );
                  },
                );
              }),
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: TopNavBar(
                  initialIndex: 1,
                  onSearchTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
