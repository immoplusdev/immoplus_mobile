import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:immoplus/app/data/models/remote/banners/banner_model.dart';
import 'package:immoplus/app/features/home_page/components/banner_item.dart';
import 'package:immoplus/app/logic/banners/banners_cubit.dart';
import 'package:immoplus/app/logic/banners/banners_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
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
        final activeBanners = apiBanners;
        // Remplacez par testBanners pour tester localement

        // Pas de bannières ou fermée par l'utilisateur : rien à afficher
        if (activeBanners.isEmpty || _isDismissed) {
          return const SizedBox.shrink(key: ValueKey('banner_hidden'));
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: AnimatedContainer(
            key: const ValueKey('banner_visible'),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(
              color: _getBackgroundColor(activeBanners),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: activeBanners.length,
                  options: CarouselOptions(
                    height: 24,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return BannerItem(
                      banner: activeBanners[index],
                      onDismiss: () {
                        setState(() {
                          _isDismissed = true;
                        });
                        widget.onDismiss?.call();
                      },
                    );
                  },
                ),
                const Gap(2),
                _buildDots(activeBanners.length),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(List<BannerModel> apiBanners) {
    if (_currentIndex >= 0 && _currentIndex < apiBanners.length) {
      return Utils.parseColor(apiBanners[_currentIndex].bgColor) ??
          AppColors.customBlue;
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
            color: Colors.white
                .withValues(alpha: _currentIndex == index ? 1.0 : 0.4),
            borderRadius: BorderRadius.circular(1.5),
          ),
        );
      }),
    );
  }
}
