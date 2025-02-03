import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/features/home_page/logic/home_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/immo_icons.dart';
import 'package:immoplus/main.dart';

class MenuOption {
  final String label;
  final ImmoIcons icon;

  MenuOption({required this.label, required this.icon});
}

class HomeChoiceMenu extends StatelessWidget {
  HomeChoiceMenu({super.key});
  final List<MenuOption> _choices = [
    MenuOption(label: 'Résidences', icon: ImmoIcons.home),
    MenuOption(label: 'Meubles', icon: ImmoIcons.meubles),
    MenuOption(label: 'Locations', icon: ImmoIcons.location),
    MenuOption(label: 'Achats', icon: ImmoIcons.terrain),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        return Container(
          height: 50,
          //color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _choices.asMap().entries.map((entry) {
              int index = entry.key;
              MenuOption choice = entry.value;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  avatar: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (state.indexPage == index)
                          ? AppColors.scafold
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: ImmoIcon(
                        choice.icon,
                        color: Colors.grey.shade700,
                        size: 15,
                      ),
                    ),
                  ),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 3),
                  label: Text(choice.label),
                  selected: state.indexPage == index,
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.grey.shade200,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                  labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: state.indexPage == index
                            ? Colors.white
                            : Colors.black,
                      ),
                  onSelected: (bool selected) {
                    context.read<HomePageCubit>().changeIndex(index);
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
