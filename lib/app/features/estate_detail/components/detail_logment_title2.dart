import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailEstateTitle2 extends StatelessWidget {
  const DetailEstateTitle2({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 5),
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
