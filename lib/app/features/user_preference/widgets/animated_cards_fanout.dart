import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Description d'un emplacement (slot) dans l'éventail de cartes
class _CardSlot {
  final double dx;
  final double dy;
  final double angle;
  final double scale;
  final double opacity;

  const _CardSlot({
    required this.dx,
    required this.dy,
    required this.angle,
    required this.scale,
    required this.opacity,
  });
}

/// Widget de l'éventail animé : transition fluide et continue des 3 cartes
/// avec rotation cyclique où chaque carte vient se placer au premier plan au centre.
class AnimatedCardsFanout extends StatefulWidget {
  const AnimatedCardsFanout({super.key});

  @override
  State<AnimatedCardsFanout> createState() => _AnimatedCardsFanoutState();
}

class _AnimatedCardsFanoutState extends State<AnimatedCardsFanout>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _cycleTimer;
  int _step = 0;

  static const List<_DiscoveryCardData> _cards = [
    _DiscoveryCardData(
      imagePath: 'assets/img/menu_residence.jpg',
      tag: 'Abidjan',
      tagIcon: Iconsax.location,
      title: 'Appartement lumineux',
      subtitle: 'Cocody, Riviera 3',
      detail: '2 chambres · 1 salon',
      action: 'Découvrir',
      accent: Color(0xFF2F5BFF),
    ),
    _DiscoveryCardData(
      imagePath: 'assets/img/login.jpg',
      tag: 'Visite',
      tagIcon: Iconsax.home_1,
      title: 'Le studio qui vous ressemble',
      subtitle: 'Cocody, Ambassade',
      detail: 'Très agréable pour un bon séjour',
      action: 'Réserver',
      accent: Color(0xFF2450E8),
    ),
    _DiscoveryCardData(
      imagePath: 'assets/img/terrain.png',
      tag: 'Terrain',
      tagIcon: Iconsax.map_1,
      title: 'Votre prochain projet',
      subtitle: 'Grand-Bassam',
      detail: 'Parcelles disponibles',
      action: 'Explorer',
      accent: Color(0xFF17A64A),
    ),
  ];

  // Slot 0: Gauche (incliné à gauche, en retrait)
  // Slot 1: Centre (au premier plan, droit)
  // Slot 2: Droite (incliné à droite, en retrait)
  static const _CardSlot _leftSlot = _CardSlot(
    dx: -82,
    dy: 14,
    angle: -0.15,
    scale: 0.84,
    opacity: 0.95,
  );

  static const _CardSlot _centerSlot = _CardSlot(
    dx: 0,
    dy: 0,
    angle: 0.0,
    scale: 1.0,
    opacity: 1.0,
  );

  static const _CardSlot _rightSlot = _CardSlot(
    dx: 82,
    dy: 14,
    angle: 0.15,
    scale: 0.84,
    opacity: 0.95,
  );

  static const List<_CardSlot> _slots = [
    _leftSlot,
    _centerSlot,
    _rightSlot,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _step = (_step + 1) % 3;
          _controller.reset();
        });
        _scheduleNextTransition();
      }
    });

    _scheduleNextTransition();
  }

  void _scheduleNextTransition() {
    _cycleTimer?.cancel();
    _cycleTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  int _getSlotIndex(int cardIndex, int step) {
    return (cardIndex + step) % 3;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final t = _animation.value;

        // Calcul des états interpolés et de l'ordre de profondeur (Z-Index)
        final cardRenderList = List.generate(3, (cardIndex) {
          final fromSlotIndex = _getSlotIndex(cardIndex, _step);
          final toSlotIndex = _getSlotIndex(cardIndex, _step + 1);

          final fromSlot = _slots[fromSlotIndex];
          final toSlot = _slots[toSlotIndex];

          double dx = lerpDouble(fromSlot.dx, toSlot.dx, t)!;
          double dy = lerpDouble(fromSlot.dy, toSlot.dy, t)!;
          double angle = lerpDouble(fromSlot.angle, toSlot.angle, t)!;
          double scale = lerpDouble(fromSlot.scale, toSlot.scale, t)!;
          double opacity = lerpDouble(fromSlot.opacity, toSlot.opacity, t)!;

          // Hiérarchie de profondeur Z :
          // - Au repos (t = 0), la carte du CENTRE (fromSlotIndex == 1) a zIndex = 10.0 (au premier plan absolu)
          // - La carte de GAUCHE (fromSlotIndex == 0) a zIndex = 1.0 (strictement en dessous / derrière le centre)
          // - La carte de DROITE (fromSlotIndex == 2) a zIndex = 0.5 (strictement en dessous / derrière le centre)
          // - Pendant la transition :
          //   * La carte centrale (fromSlotIndex == 1) glisse vers la droite en restant au-dessus
          //   * La carte de gauche (fromSlotIndex == 0) avance vers le centre et monte à zIndex = 10.0
          //   * La carte arrière (fromSlotIndex == 2) traverse en arrière-plan à zIndex = 0.5
          double zIndex;
          if (fromSlotIndex == 1) {
            // Carte quittant le centre
            zIndex = lerpDouble(10.0, 2.0, t)!;
            dy += 6 * (1 - (2 * (t - 0.5)).abs());
          } else if (fromSlotIndex == 0) {
            // Carte venant de la gauche vers le centre
            zIndex = lerpDouble(1.0, 10.0, t)!;
          } else {
            // Carte en arrière-plan
            zIndex = 0.5;
            dy += 8 * (1 - (2 * (t - 0.5)).abs());
          }

          return _CardRenderData(
            cardIndex: cardIndex,
            card: _cards[cardIndex],
            dx: dx,
            dy: dy,
            angle: angle,
            scale: scale,
            opacity: opacity,
            zIndex: zIndex,
          );
        });

        // Tri pour dessiner de l'arrière-plan vers le premier plan
        cardRenderList.sort((a, b) => a.zIndex.compareTo(b.zIndex));

        return SizedBox(
          height: 350,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: cardRenderList.map((item) {
              return Transform.translate(
                offset: Offset(item.dx, item.dy),
                child: Transform.rotate(
                  angle: item.angle,
                  child: Transform.scale(
                    scale: item.scale,
                    child: Opacity(
                      opacity: item.opacity,
                      child: _DiscoveryCard(card: item.card),
                      ),
                    ),
                  ),
                );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _CardRenderData {
  final int cardIndex;
  final _DiscoveryCardData card;
  final double dx;
  final double dy;
  final double angle;
  final double scale;
  final double opacity;
  final double zIndex;

  const _CardRenderData({
    required this.cardIndex,
    required this.card,
    required this.dx,
    required this.dy,
    required this.angle,
    required this.scale,
    required this.opacity,
    required this.zIndex,
  });
}

class _DiscoveryCardData {
  final String imagePath;
  final String tag;
  final IconData tagIcon;
  final String title;
  final String subtitle;
  final String detail;
  final String action;
  final Color accent;

  const _DiscoveryCardData({
    required this.imagePath,
    required this.tag,
    required this.tagIcon,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.action,
    required this.accent,
  });
}

/// Carte éditoriale sans ombre portée : l'image et les informations sont
/// composées séparément afin que les trois cartes restent réellement uniques.
class _DiscoveryCard extends StatelessWidget {
  final _DiscoveryCardData card;

  const _DiscoveryCard({required this.card});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: 202,
        height: 310,
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(26)),
        ),
        child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(21)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(card.imagePath, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x10000000),
                    Color(0xCC000000),
                  ],
                  stops: [0.35, 0.54, 1],
                ),
              ),
            ),
            Positioned(
              top: 14,
              left: 12,
              child: _Tag(
                icon: card.tagIcon,
                label: card.tag,
                color: card.accent,
              ),
            ),
            Positioned(
              left: 14,
              right: 11,
              bottom: 14,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          card.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFF5F5F5),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          card.detail,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFDADADA),
                            fontSize: 9,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: card.accent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.calendar_tick,
                            color: Colors.white, size: 17),
                        const SizedBox(height: 2),
                        Text(
                          card.action,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Tag({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1C1C1C),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
}
