import 'package:flutter/material.dart';
import './promo_carousel_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Promo Carousel Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
        useMaterial3: true,
      ),
      home: const CarouselDemoPage(),
    );
  }
}

class CarouselDemoPage extends StatelessWidget {
  const CarouselDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Données des cartes - personnalisez avec vos propres textes!
    final List<PromoCardData> promoItems = [
      PromoCardData(
        title: 'Économisez maintenant ou plus tard',
        description:
            'Les membres économisent instantanément ou accumulent des points pour le futur. Votre voyage, votre choix.',
        linkText: 'Comment ça marche',
        onLinkTap: () {
          debugPrint('Lien cliqué: Comment ça marche');
        },
        // Vous pouvez ajouter une mascotte ou image ici
        bottomWidget: const Icon(
          Icons.savings,
          size: 60,
          color: Colors.white70,
        ),
      ),
      PromoCardData(
        title: 'Gagnez des récompenses',
        description:
            'Gagnez des points sur chaque réservation que vous faites, où que vous alliez.',
        linkText: 'En savoir plus',
        onLinkTap: () {
          debugPrint('Lien cliqué: En savoir plus');
        },
        bottomWidget: const Icon(
          Icons.card_giftcard,
          size: 60,
          color: Colors.white70,
        ),
      ),
      PromoCardData(
        title: 'Offres exclusives',
        description:
            'Accédez à des tarifs spéciaux réservés uniquement aux membres.',
        linkText: 'Voir les offres',
        onLinkTap: () {
          debugPrint('Lien cliqué: Voir les offres');
        },
        bottomWidget: const Icon(
          Icons.local_offer,
          size: 60,
          color: Colors.white70,
        ),
      ),
      PromoCardData(
        title: 'Support 24/7',
        description:
            'Notre équipe est disponible à tout moment pour vous aider.',
        linkText: 'Nous contacter',
        onLinkTap: () {
          debugPrint('Lien cliqué: Nous contacter');
        },
        bottomWidget: const Icon(
          Icons.support_agent,
          size: 60,
          color: Colors.white70,
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Carrousel Promo'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            
            // Titre de section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Version ListView (scroll horizontal)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Carrousel simple avec ListView
            PromoCarousel(
              items: promoItems,
              cardWidth: 290,
              cardHeight: 325,
              spacing: 16,
            ),
            
            const SizedBox(height: 40),
            
            // Titre de section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Version PageView avec indicateurs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Carrousel avec PageView et indicateurs
            PromoCarouselWithIndicators(
              items: promoItems,
              cardHeight: 325,
              indicatorActiveColor: kPrimaryColor,
            ),
            
            const SizedBox(height: 40),
            
            // Titre de section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Carte individuelle',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Carte individuelle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PromoCarouselCard(
                data: PromoCardData(
                  title: 'Carte personnalisée',
                  description: 'Vous pouvez utiliser la carte seule avec vos propres couleurs.',
                  linkText: 'Action',
                  backgroundColor: AppComplementaryColors.coral,
                  onLinkTap: () {},
                ),
                width: double.infinity,
                height: 280,
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}