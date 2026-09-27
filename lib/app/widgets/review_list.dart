import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/design_system.dart';

class ReviewListTile extends StatelessWidget {
  const ReviewListTile(
      {super.key, required this.title, required this.trailing});
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        title,
        style: AppTypography.font(color: AppColors.gray500),
      ),
      trailing: Text(trailing,
          style: AppTypography.font(
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
