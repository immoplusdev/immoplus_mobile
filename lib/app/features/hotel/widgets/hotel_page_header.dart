import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// En-tête commun (bouton retour + titre "Hôtel" centré) affiché sur le
/// bandeau bleu de la page Hôtel, que ce soit à l'état skeleton, "coming
/// soon" ou une fois le contenu réel affiché.
class HotelPageHeader extends StatelessWidget {
  const HotelPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "Hôtel",
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/homePage');
                  }
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
