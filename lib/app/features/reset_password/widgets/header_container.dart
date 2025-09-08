import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class HeaderContainer extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String subtitle;
  const HeaderContainer(
      {super.key,
      required this.iconData,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          Icon(
            iconData,
            size: 80,
            color: AppColors.lightBlue,
          ),
          const Gap(30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColors.white),
          ),
          const Gap(15),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.grey.shade300),
          ),
        ],
      ),
    );
  }
}
