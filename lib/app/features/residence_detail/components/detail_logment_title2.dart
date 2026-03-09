import 'package:flutter/material.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';

class DetailLogmentTitle2 extends StatelessWidget {
  const DetailLogmentTitle2({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: appPadding)
            .copyWith(bottom: 5),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!,
        ),
      ),
    );
  }
}
