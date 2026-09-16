import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

/// Une section titrée ("À venir (3)") + scroll horizontal de cartes —
/// partagé par "Pour moi", "Mes intérêts" et "Reçues" ("Je déménage"),
/// chacun groupant ses items par statut au lieu d'une seule liste plate.
class RelaisStatusSection<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(T item) itemBuilder;

  const RelaisStatusSection({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$title (${items.length})',
              style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const Gap(12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const Gap(12),
                  itemBuilder(items[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
