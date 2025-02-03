import 'package:flutter/material.dart';

class DetailDivider extends StatelessWidget {
  const DetailDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Divider(
        endIndent: 10,
        indent: 10,
        color: Colors.grey,
      ),
    );
  }
}
