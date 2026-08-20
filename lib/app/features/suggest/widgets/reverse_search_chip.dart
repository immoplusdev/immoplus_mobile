import 'package:flutter/material.dart';

class ReverseSearchChip extends StatelessWidget {
  final String text;
  final String? badge;
  final VoidCallback onTap;

  const ReverseSearchChip({
    super.key,
    required this.text,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFC0CAFF),
          borderRadius: BorderRadius.circular(20),
          border: const Border(
            bottom: BorderSide(color: Color(0xFF2744DE), width: 2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (badge != null && badge!.isNotEmpty) ...[
              const SizedBox(width: 2),
              Transform.translate(
                offset: const Offset(0, -6),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2744DE),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
