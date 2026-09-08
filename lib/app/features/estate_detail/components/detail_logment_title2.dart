import 'package:flutter/cupertino.dart';
import 'package:immoplus/app/configs/app_typography.dart';

class DetailEstateTitle2 extends StatelessWidget {
  const DetailEstateTitle2({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 5),
        child: Text(
          title,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
