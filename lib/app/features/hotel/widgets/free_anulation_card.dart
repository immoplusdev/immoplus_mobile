import 'package:flutter/material.dart';

class FreeAnulationCard extends StatelessWidget {
  final Color? color;

  const FreeAnulationCard({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color ?? Color(0xffFFD609), width: .2),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        "Annulation gratuite",
        style: TextStyle(
          color: color ?? Color(0xffFFD609),
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
