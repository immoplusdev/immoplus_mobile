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
            color: Colors.blue,
            delay: Duration(milliseconds: 300),
            repeat: true,
            minRadius: 50,
            ripplesCount: 6,
            duration: Duration(seconds: 3),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 40),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$titlePrefix ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: titleSufix,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
