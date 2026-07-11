import 'package:flutter/material.dart';

class DiscoverCard extends StatelessWidget {
  final String assetPath;

  const DiscoverCard({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
