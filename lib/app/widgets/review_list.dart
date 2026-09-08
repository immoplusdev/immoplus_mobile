import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/app_colors.dart';

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
        style: const TextStyle(color: AppColors.grey600),
      ),
      trailing: Text(trailing,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
