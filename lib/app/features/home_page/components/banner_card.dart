import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:immoplus/app/data/models/remote/banners/banner_model.dart';
import 'package:immoplus/app/features/home_page/components/banner_item.dart';
import 'package:immoplus/app/logic/banners/banners_cubit.dart';
import 'package:immoplus/app/logic/banners/banners_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:gap/gap.dart';

class BannerCard extends StatefulWidget {
  final Widget child;
  final Widget? secondChild;
  final VoidCallback? onDismiss;

  const BannerCard({
    super.key,
    required this.child,
    this.secondChild,
    this.onDismiss,
  });

  @override
  State<BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {
  int _currentIndex = 0;
  bool _isDismissed = false;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannersCubit, BannersState>(
      builder: (context, state) {
        final apiBanners = state.maybeWhen(
          success: (banners) => banners,
          orElse: () => <BannerModel>[],
        );

        // Si pas de bannières ou si l'utilisateur a fermé, on affiche le secondChild ou le child par défaut
        if (apiBanners.isEmpty || _isDismissed) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: widget.secondChild ?? widget.child,
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOutQuart,
          switchOutCurve: Curves.easeInQuart,
          child: Stack(
            key: const ValueKey('banner_active'),
            children: [
              Container(
                width: double.infinity,
                height: 190,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(apiBanners),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CarouselSlider.builder(
                      carouselController: _carouselController,
                      itemCount: apiBanners.length,
                      options: CarouselOptions(
                        height: 90,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return BannerItem(banner: apiBanners[index]);
                      },
                    ),
                    const Gap(2),
                    _buildDots(apiBanners.length),
                    const Gap(10),
                    widget.child,
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 15),
                  onPressed: () {
                    setState(() {
                      _isDismissed = true;
                    });
                    widget.onDismiss?.call();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(List<BannerModel> apiBanners) {
    if (_currentIndex >= 0 && _currentIndex < apiBanners.length) {
      final colorStr = apiBanners[_currentIndex].bgColor;
      if (colorStr != null && colorStr.isNotEmpty) {
        try {
          return Color(int.parse(colorStr.replaceAll('#', '0xFF')));
        } catch (_) {
          return AppColors.customBlue;
        }
      }
    }
    return AppColors.customBlue;
  }

  Widget _buildDots(int count) {
    if (count <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _currentIndex == index ? 20 : 8,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(_currentIndex == index ? 1.0 : 0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
