import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailLogmentTitle2 extends StatelessWidget {
  const DetailLogmentTitle2({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 5),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!,
        ),
      ),
    );
  }
}
