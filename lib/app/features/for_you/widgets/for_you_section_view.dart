import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_section.dart';
import 'package:immoplus/app/features/for_you/factories/section_view_factory.dart';

/// Dispatche une entrée de `sections[]` vers le widget adapté à son `type`
/// via une [SectionViewFactory].
///
/// Par défaut, utilise [CarouselSectionViewFactory] pour l'accueil "Pour vous".
/// Pour un affichage vertical (ex: "Trouver un logement", "Acheter un bien"),
/// utiliser le constructeur [ForYouSectionView.vertical] ou injecter une factory personnalisée.
class ForYouSectionView extends StatelessWidget {
  final HomeFeedSection section;
  final SectionViewFactory factory;

  const ForYouSectionView({
    super.key,
    required this.section,
    this.factory = const SectionViewFactory.carousel(),
  });

  /// Constructeur pour l'affichage classique en carrousel horizontal ("Pour vous")
  const ForYouSectionView.carousel({
    super.key,
    required this.section,
  }) : factory = const SectionViewFactory.carousel();

  /// Constructeur pour l'affichage en liste verticale avec cartes détaillées
  /// ("Trouver un logement", "Acheter un bien", "Séjour")
  ForYouSectionView.vertical({
    super.key,
    required this.section,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20),
    double itemSpacing = 16.0,
  }) : factory = VerticalListSectionViewFactory(
          padding: padding,
          itemSpacing: itemSpacing,
        );

  /// Constructeur pour une factory personnalisée
  const ForYouSectionView.custom({
    super.key,
    required this.section,
    required this.factory,
  });

  @override
  Widget build(BuildContext context) {
    if (section.isEmpty) return const SizedBox.shrink();
    return factory.buildSection(context, section);
  }
}
