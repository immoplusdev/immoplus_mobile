import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:shimmer/shimmer.dart';

/// Squelette du résumé (galerie + titre + badge), de même hauteur que le
/// contenu réel pour éviter un saut de mise en page au chargement.
class PaymentSummarySkeleton extends StatelessWidget {
  const PaymentSummarySkeleton({super.key, this.galleryHeight = 160});

  final double galleryHeight;

  Widget _box({double? width, required double height, double radius = 20}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.gray200,
      highlightColor: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: galleryHeight,
            child: Row(
              children: [
                Expanded(flex: 735, child: _box(height: galleryHeight)),
                const SizedBox(width: 6),
                Expanded(
                  flex: 370,
                  child: Column(
                    children: [
                      Expanded(child: _box(height: double.infinity)),
                      const SizedBox(height: 6),
                      Expanded(child: _box(height: double.infinity)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(width: 180, height: 22, radius: 6),
                    const SizedBox(height: 6),
                    _box(width: 120, height: 14, radius: 6),
                  ],
                ),
              ),
              _box(width: 72, height: 32),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
