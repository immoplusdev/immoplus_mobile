import 'package:flutter/material.dart';

class DiscoverCard extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onTap;

  const DiscoverCard({super.key, required this.assetPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 156,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: DecorationImage(
              image: AssetImage(assetPath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
