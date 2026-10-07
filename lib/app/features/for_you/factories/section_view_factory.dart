import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_section.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_ad_banner.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_bien_groups_section.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_item_carousel.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_item_vertical_list.dart';
import 'package:immoplus/app/features/for_you/widgets/poll_banner_card.dart';

/// Contrat pour la factory de rendu des sections de flux ([HomeFeedSection]).
/// Permet de changer la disposition visuelle (carrousel horizontal, liste verticale,
/// ou rendu personnalisé) selon l'écran ou le contexte d'utilisation, sans modifier
/// la logique métier ni le modèle de données.
abstract class SectionViewFactory {
  const SectionViewFactory();

  /// Construit le widget associé à une section
  Widget buildSection(BuildContext context, HomeFeedSection section);

  /// Factory par défaut : mode Carrousel horizontal (utilisé pour "Pour vous")
  const factory SectionViewFactory.carousel() = CarouselSectionViewFactory;

  /// Factory Liste Verticale : cartes complètes empilées verticalement
  /// (ex: pour "Trouver un logement", "Acheter un bien", "Séjour")
  const factory SectionViewFactory.verticalList({
    EdgeInsetsGeometry padding,
    double itemSpacing,
  }) = VerticalListSectionViewFactory;

  /// Factory Personnalisée : permet d'injecter des constructeurs spécifiques
  /// par type de section pour une flexibilité maximale.
  const factory SectionViewFactory.custom({
    Widget Function(BuildContext context, HomeFeedSection section)?
        residenceListBuilder,
    Widget Function(BuildContext context, HomeFeedSection section)?
        bienListBuilder,
    Widget Function(BuildContext context, HomeFeedSection section)?
        bienGroupsBuilder,
    Widget Function(BuildContext context, HomeFeedSection section)?
        adBannerBuilder,
    Widget Function(BuildContext context, HomeFeedSection section)?
        pollBannerBuilder,
  }) = CustomSectionViewFactory;
}

/// Implémentation Carousel horizontal classique (écran d'accueil "Pour vous")
class CarouselSectionViewFactory extends SectionViewFactory {
  const CarouselSectionViewFactory();

  @override
  Widget buildSection(BuildContext context, HomeFeedSection section) {
    switch (section.type) {
      case HomeFeedSectionType.residenceList:
      case HomeFeedSectionType.bienList:
        return ForYouItemCarousel(section: section);
      case HomeFeedSectionType.bienGroupsByLocation:
        return ForYouBienGroupsSection(section: section);
      case HomeFeedSectionType.adBanner:
        return ForYouAdBanner(section: section);
      case HomeFeedSectionType.pollBanner:
        if (section.poll == null) return const SizedBox.shrink();
        return PollBannerCard(
          key: ValueKey(section.poll!.pollId),
          poll: section.poll!,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

/// Implémentation Liste Verticale avec cartes détaillées ("Trouver un logement", "Acheter un bien")
class VerticalListSectionViewFactory extends SectionViewFactory {
  final EdgeInsetsGeometry padding;
  final double itemSpacing;

  const VerticalListSectionViewFactory({
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.itemSpacing = 16.0,
  });

  @override
  Widget buildSection(BuildContext context, HomeFeedSection section) {
    switch (section.type) {
      case HomeFeedSectionType.residenceList:
      case HomeFeedSectionType.bienList:
        return ForYouItemVerticalList(
          section: section,
          padding: padding,
          itemSpacing: itemSpacing,
        );
      case HomeFeedSectionType.bienGroupsByLocation:
        return ForYouBienGroupsSection(section: section);
      case HomeFeedSectionType.adBanner:
        return ForYouAdBanner(section: section);
      case HomeFeedSectionType.pollBanner:
        if (section.poll == null) return const SizedBox.shrink();
        return PollBannerCard(
          key: ValueKey(section.poll!.pollId),
          poll: section.poll!,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

/// Implémentation Personnalisée avec builders configurables par type de section
class CustomSectionViewFactory extends SectionViewFactory {
  final Widget Function(BuildContext context, HomeFeedSection section)?
      residenceListBuilder;
  final Widget Function(BuildContext context, HomeFeedSection section)?
      bienListBuilder;
  final Widget Function(BuildContext context, HomeFeedSection section)?
      bienGroupsBuilder;
  final Widget Function(BuildContext context, HomeFeedSection section)?
      adBannerBuilder;
  final Widget Function(BuildContext context, HomeFeedSection section)?
      pollBannerBuilder;

  const CustomSectionViewFactory({
    this.residenceListBuilder,
    this.bienListBuilder,
    this.bienGroupsBuilder,
    this.adBannerBuilder,
    this.pollBannerBuilder,
  });

  @override
  Widget buildSection(BuildContext context, HomeFeedSection section) {
    switch (section.type) {
      case HomeFeedSectionType.residenceList:
        if (residenceListBuilder != null)
          return residenceListBuilder!(context, section);
        return ForYouItemCarousel(section: section);
      case HomeFeedSectionType.bienList:
        if (bienListBuilder != null) return bienListBuilder!(context, section);
        return ForYouItemCarousel(section: section);
      case HomeFeedSectionType.bienGroupsByLocation:
        if (bienGroupsBuilder != null)
          return bienGroupsBuilder!(context, section);
        return ForYouBienGroupsSection(section: section);
      case HomeFeedSectionType.adBanner:
        if (adBannerBuilder != null) return adBannerBuilder!(context, section);
        return ForYouAdBanner(section: section);
      case HomeFeedSectionType.pollBanner:
        if (pollBannerBuilder != null)
          return pollBannerBuilder!(context, section);
        if (section.poll == null) return const SizedBox.shrink();
        return PollBannerCard(
          key: ValueKey(section.poll!.pollId),
          poll: section.poll!,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
