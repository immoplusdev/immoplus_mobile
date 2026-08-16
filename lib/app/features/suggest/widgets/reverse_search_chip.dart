import 'package:flutter/material.dart';

class ReverseSearchChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ReverseSearchChip({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFC0CAFF),
          borderRadius: BorderRadius.circular(16),
          border: const Border(
            bottom: BorderSide(color: Color(0xFF2744DE), width: 2),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
