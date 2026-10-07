import 'package:immoplus/app/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class EmptyIndicator extends StatelessWidget {
  const EmptyIndicator({super.key});

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
                  text: 'Aucun ',
                  style: AppTypography.font(
                    color: AppColors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'favori disponible',
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
            'Ajoutez vos favoris pour accéder rapidement\nà vos contenus préférés à tout moment.',
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
