import 'package:flutter/material.dart';

class DetailLogmentTitleCentered extends StatelessWidget {
  const DetailLogmentTitleCentered({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!,
        ),
      ),
    );
  }
}
