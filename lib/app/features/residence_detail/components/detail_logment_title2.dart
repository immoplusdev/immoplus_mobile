import 'package:flutter/material.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';

class DetailLogmentTitle2 extends StatelessWidget {
  const DetailLogmentTitle2({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: appPadding,
          right: appPadding,
          bottom: 4,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            height: 1.2,
            color: Color(0xFF222222),
          ),
        ),
      ),
    );
  }
}