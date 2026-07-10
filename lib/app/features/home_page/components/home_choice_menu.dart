import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/enums/home_tab.dart';
import 'package:immoplus/app/features/home_page/logic/home_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class _Constants {
  static const double menuHeight = 50.0;
  static const double horizontalPadding = 8.0;
  static const double itemSpacing = 8.0;
  static const double itemHorizontalPadding = 6.0;
  static const double itemVerticalPadding = 5.0;
  static const double borderRadius = 20.0;
  static const double borderWidth = 1.0;
  static const double borderOpacity = 0.3;
  static const double imageSize = 32.0;
  static const double textIconGap = 6.0;
}

class HomeChoiceMenu extends StatelessWidget {
  const HomeChoiceMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        return Container(
          height: _Constants.menuHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: _Constants.horizontalPadding,
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: HomeTab.values.length,
            separatorBuilder: (context, index) => const SizedBox(
              width: _Constants.itemSpacing,
            ),
            itemBuilder: (context, index) {
              final tab = HomeTab.values[index];
              bool isSelected = state.indexPage == tab.value;

              return GestureDetector(
                onTap: () {
                  context.read<HomePageCubit>().changeIndex(tab.value);
                },
                child: UnconstrainedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _Constants.itemHorizontalPadding,
                      vertical: _Constants.itemVerticalPadding,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        _Constants.borderRadius,
                      ),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(
                          _Constants.borderOpacity,
                        ),
                        width: _Constants.borderWidth,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: _Constants.imageSize,
                          height: _Constants.imageSize,
                          child: ClipOval(
                            child: Image.asset(
                              tab.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: AppColors.primary.withOpacity(0.15),
                              ),
                            ),
                          ),
                        ),
                        const Gap(_Constants.textIconGap),
                        // Label
                        Text(
                          tab.label,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.primary,
                                  ),
                        ),
                        const Gap(_Constants.textIconGap),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
