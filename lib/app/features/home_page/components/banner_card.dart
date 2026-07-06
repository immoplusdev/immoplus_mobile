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
  final VoidCallback? onDismiss;

  const BannerCard({
    super.key,
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

        // Pas de bannières ou fermée par l'utilisateur : rien à afficher, la
        // banniere est totalement dissociée de la barre de recherche.
        if (apiBanners.isEmpty || _isDismissed) {
          return const SizedBox.shrink(key: ValueKey('banner_hidden'));
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
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(apiBanners),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CarouselSlider.builder(
                      carouselController: _carouselController,
                      itemCount: apiBanners.length,
                      options: CarouselOptions(
                        height: 52,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: BannerItem(banner: apiBanners[index]),
                        );
                      },
                    ),
                    const Gap(2),
                    _buildDots(apiBanners.length),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 15),
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
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
          width: _currentIndex == index ? 14 : 5,
          height: 3,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(_currentIndex == index ? 1.0 : 0.4),
            borderRadius: BorderRadius.circular(1.5),
          ),
        );
      }),
    );
  }
}
