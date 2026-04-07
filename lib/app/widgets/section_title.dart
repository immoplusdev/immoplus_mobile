import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool useCalSans;
  const SectionTitle({super.key, required this.title, this.useCalSans = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: useCalSans
          ? GoogleFonts.getFont(
              'Cal Sans',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1a1a2e),
            )
          : Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
    );
  }
}
