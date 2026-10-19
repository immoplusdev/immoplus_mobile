import 'package:immoplus/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class EmptyElementsIndicator extends StatelessWidget {
  const EmptyElementsIndicator({
    super.key,
    required this.titlePrefix,
    required this.titleSufix,
    required this.subTitle,
  });
  final String titlePrefix;
  final String titleSufix;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const RippleAnimation(
            color: AppColors.blue,
            delay: Duration(milliseconds: 300),
            repeat: true,
            minRadius: 50,
            ripplesCount: 6,
            duration: Duration(seconds: 3),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.blue,
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: AppColors.white,
              ),
            ),
          ),
          SizedBox(height: 40),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$titlePrefix ',
                  style: AppTypography.font(
                    color: AppColors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: titleSufix,
                  style: AppTypography.font(
                    color: AppColors.blue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: AppTypography.font(
              color: AppColors.immoTextSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
