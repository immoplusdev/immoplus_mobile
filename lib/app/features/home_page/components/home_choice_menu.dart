import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
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
  static const double imageBorderWidth = 2.0;
  static const double textIconGap = 6.0;
}

class MenuOption {
  final String label;
  final String imagePath;

  MenuOption({required this.label, required this.imagePath});
}

class HomeChoiceMenu extends StatelessWidget {
  HomeChoiceMenu({super.key});

  final List<MenuOption> _choices = [
    MenuOption(label: 'Résidences', imagePath: 'assets/img/menu_residence.jpg'),
    MenuOption(label: 'Locations', imagePath: 'assets/img/menu_location.png'),
    MenuOption(label: 'Meubles', imagePath: 'assets/img/menu_meubles.jpg'),
    MenuOption(label: 'Biens', imagePath: 'assets/img/menu_biens.jpg'),
  ];

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
            itemCount: _choices.length,
            separatorBuilder: (context, index) => const SizedBox(
              width: _Constants.itemSpacing,
            ),
            itemBuilder: (context, index) {
              MenuOption choice = _choices[index];
              bool isSelected = state.indexPage == index;

              return GestureDetector(
                onTap: () {
                  context.read<HomePageCubit>().changeIndex(index);
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
                        Container(
                          width: _Constants.imageSize,
                          height: _Constants.imageSize,
                          // decoration: BoxDecoration(
                          //   shape: BoxShape.circle,
                          //   border: Border.all(
                          //     color: Colors.white,
                          //     width: _Constants.imageBorderWidth,
                          //   ),
                          // ),
                          child: ClipOval(
                            child: Image.asset(
                              choice.imagePath,
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
                          choice.label,
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