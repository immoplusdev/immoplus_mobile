import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RatingComponent extends StatelessWidget {
  final double rating;

  const RatingComponent({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue.shade50, // Couleur d'arrière-plan
        borderRadius: BorderRadius.circular(20), // Bordures arrondies
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            FontAwesomeIcons.solidStar, // Icône étoile
            color: Colors.orange, // Couleur de l'étoile
            size: 16, // Taille de l'icône
          ),
          const SizedBox(width: 5), // Espace entre l'étoile et la note
          Text(
            rating.toStringAsFixed(
                1), // Affiche la note avec un seul chiffre après la virgule
            style: const TextStyle(
              color: Colors.black, // Couleur du texte
              fontSize: 14, // Taille de la police
              fontWeight: FontWeight.w500, // Poids de la police
            ),
          ),
        ],
      ),
    );
  }
}
