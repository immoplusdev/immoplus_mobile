import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/features/home_page/logic/home_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/immo_icons.dart';

class _Constants {
  static const double menuHeight = 50.0;
  static const double horizontalPadding = 8.0;
  static const double itemSpacing = 8.0;
  static const double itemHorizontalPadding = 6.0;
  static const double itemVerticalPadding = 5.0;
  static const double borderRadius = 20.0;
  static const double borderWidth = 1.0;
  static const double borderOpacity = 0.3;
  static const double iconContainerPadding = 6.0;
  static const double iconSize = 16.0;
  static const double textIconGap = 4.0;
}

class MenuOption {
  final String label;
  final ImmoIcons icon;

  MenuOption({required this.label, required this.icon});
}

class HomeChoiceMenu extends StatelessWidget {
  HomeChoiceMenu({super.key});

  final List<MenuOption> _choices = [
    MenuOption(label: 'Résidences', icon: ImmoIcons.home),
    MenuOption(label: 'Locations', icon: ImmoIcons.location),
    MenuOption(label: 'Meubles', icon: ImmoIcons.meubles),
    MenuOption(label: 'Achats', icon: ImmoIcons.terrain),
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
                        // Conteneur pour l'icône
                        Container(
                          padding: const EdgeInsets.all(
                            _Constants.iconContainerPadding,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              _Constants.borderRadius,
                            ),
                            color: isSelected ? Colors.white : null,
                          ),
                          child: ImmoIcon(
                            choice.icon,
                            color: AppColors.primary,
                            size: _Constants.iconSize,
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