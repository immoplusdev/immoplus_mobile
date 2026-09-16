import 'package:flutter/material.dart';
import 'package:immoplus/app/features/immo_relais/widgets/relais_marketplace_section.dart';

/// Page dédiée "Autour de moi" — découverte des relais des autres,
/// ouverte depuis la carte bento du hub "Je déménage".
class RelaisMarketplacePage extends StatelessWidget {
  const RelaisMarketplacePage({super.key});
  static const String name = 'RELAIS_MARKETPLACE_PAGE';
  static const String routePath = '/relais/marketplace';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Autour de moi'), centerTitle: true),
      body: const RelaisMarketplaceSection(),
    );
  }
}
