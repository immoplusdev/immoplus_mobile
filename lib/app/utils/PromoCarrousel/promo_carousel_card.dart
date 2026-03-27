import 'package:flutter/material.dart';

/// Couleur principale de l'application
const Color kPrimaryColor = Color(0xff2744de);

/// Couleurs complémentaires dérivées
class AppComplementaryColors {
  // Orange complémentaire (opposé au bleu sur le cercle chromatique)
  static const Color orange = Color(0xffDE5827);
  
  // Variantes de l'orange
  static const Color orangeLight = Color(0xffE87A52);
  static const Color orangeDark = Color(0xffC44A1D);
  
  // Couleur corail/saumon (plus douce)
  static const Color coral = Color(0xffDE7B44);
  
  // Jaune-orange (analogue complémentaire)
  static const Color amber = Color(0xffDEA227);
  
  // Rouge-orange (comme dans l'image)
  static const Color redOrange = Color(0xffE23C2C);
  // Variantes plus claires
  static const Color primary50 = Color(0xffEEF1FC);   // Très clair (backgrounds)
  static const Color primary100 = Color(0xffC5CFF5);  // Clair
  static const Color primary200 = Color(0xff9BADEF);  // 
  static const Color primary300 = Color(0xff6B85E6);  // 
  static const Color primary400 = Color(0xff4A64E2);  // Légèrement plus clair
  
  // Variantes plus foncées
  static const Color primary600 = Color(0xff1E35B8);  // Plus foncé
  static const Color primary700 = Color(0xff182A92);  // Foncé
  static const Color primary800 = Color(0xff121F6C);  // Très foncé
  static const Color primary900 = Color(0xff0C1446);  // Extra foncé
}

/// Modèle de données pour une carte du carrousel
class PromoCardData {
  final String title;
  final String description;
  final String linkText;
  final VoidCallback? onLinkTap;
  final Widget? bottomWidget;
  final Color? backgroundColor;
  final String? imagePath;
  final String? backgroundImage;

  const PromoCardData({
    this.title = '',
    this.description = '',
    this.linkText = '',
    this.onLinkTap,
    this.bottomWidget,
    this.backgroundColor,
    this.imagePath,
    this.backgroundImage,
  });
}

/// Carte promotionnelle réutilisable
/// Carte promotionnelle réutilisable
class PromoCarouselCard extends StatelessWidget {
  final PromoCardData data;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double? width;
  final double? height;

  const PromoCarouselCard({
    super.key,
    required this.data,
    this.backgroundColor = AppComplementaryColors.redOrange,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 20,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Mode image de fond : juste l'image, pas de texte
    if (data.backgroundImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          width: width,
          height: height,
          child: Image.asset(
            data.backgroundImage!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Mode classique avec couleur de fond + texte
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: data.backgroundColor ?? backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: Text(
                      data.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: data.onLinkTap,
                    child: Text(
                      data.linkText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (data.imagePath != null)
            Positioned(
              bottom: 16,
              right: 16,
              child: Image.asset(
                data.imagePath!,
                height: 150,
                fit: BoxFit.contain,
              ),
            )
          else if (data.bottomWidget != null)
            Positioned(
              bottom: 16,
              right: 16,
              child: data.bottomWidget!,
            ),
        ],
      ),
    );
  }
}

/// Carrousel horizontal de cartes promotionnelles
class PromoCarousel extends StatelessWidget {
  final List<PromoCardData> items;
  final double cardWidth;
  final double cardHeight;
  final double spacing;
  final EdgeInsetsGeometry carouselPadding;
  final List<Color>? cardColors;

  const PromoCarousel({
    super.key,
    required this.items,
    this.cardWidth = 290,
    this.cardHeight = 325,
    this.spacing = 16,
    this.carouselPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.cardColors,
  });

  // Couleurs par défaut pour alterner
  static const List<Color> defaultColors = [
    AppComplementaryColors.redOrange,
    AppComplementaryColors.orange,
    AppComplementaryColors.coral,
    AppComplementaryColors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = cardColors ?? defaultColors;

    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        padding: carouselPadding,
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          return PromoCarouselCard(
            data: items[index],
            backgroundColor: colors[index % colors.length],
            width: cardWidth,
            height: cardHeight,
          );
        },
      ),
    );
  }
}

/// Version avec PageView et indicateurs
class PromoCarouselWithIndicators extends StatefulWidget {
  final List<PromoCardData> items;
  final double cardHeight;
  final EdgeInsetsGeometry cardPadding;
  final List<Color>? cardColors;
  final Color indicatorActiveColor;
  final Color indicatorInactiveColor;

  const PromoCarouselWithIndicators({
    super.key,
    required this.items,
    this.cardHeight = 325,
    this.cardPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.cardColors,
    this.indicatorActiveColor = kPrimaryColor,
    this.indicatorInactiveColor = const Color(0xFFE0E0E0),
  });

  @override
  State<PromoCarouselWithIndicators> createState() =>
      _PromoCarouselWithIndicatorsState();
}

class _PromoCarouselWithIndicatorsState
    extends State<PromoCarouselWithIndicators> {
  late PageController _pageController;
  int _currentPage = 0;

  static const List<Color> defaultColors = [
    AppComplementaryColors.redOrange,
    AppComplementaryColors.orange,
    AppComplementaryColors.coral,
    AppComplementaryColors.amber,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.cardColors ?? defaultColors;

    return Column(
      children: [
        SizedBox(
          height: widget.cardHeight,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: PromoCarouselCard(
                  data: widget.items[index],
                  backgroundColor: colors[index % colors.length],
                  height: widget.cardHeight,
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Indicateurs
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.items.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? widget.indicatorActiveColor
                    : widget.indicatorInactiveColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}