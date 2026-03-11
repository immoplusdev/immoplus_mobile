import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadProductCard extends StatelessWidget {
  LoadProductCard({super.key});

  final _deco = BoxDecoration(
    color: Colors.yellow,
    borderRadius: BorderRadius.circular(15),
  );

  @override
  Widget build(BuildContext context) {
    // ← MediaQuery à la place de LayoutBuilder
    final availableWidth = MediaQuery.sizeOf(context).width;

    final imageHeight = 220.0;
    final titleWidth = (availableWidth * 0.55).clamp(100.0, 200.0);
    final subtitleWidth = (availableWidth * 0.42).clamp(80.0, 130.0);
    final priceWidth = (availableWidth * 0.28).clamp(70.0, 100.0);

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: _deco,
              height: imageHeight,
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: _deco,
                        height: 15,
                        width: titleWidth,
                      ),
                      for (int i = 1; i <= 2; i++)
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: _deco,
                          height: 13,
                          width: subtitleWidth,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: _deco,
                      height: 25,
                      width: priceWidth,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
