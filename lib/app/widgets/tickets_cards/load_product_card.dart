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
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          children: [
            Container(
              decoration: _deco,
              height: 220,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: _deco,
                      height: 15,
                      width: 200,
                    ),
                    for (int i = 1; i <= 2; i++)
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: _deco,
                        height: 13,
                        width: 130,
                      ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: _deco,
                  height: 25,
                  width: 100,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
