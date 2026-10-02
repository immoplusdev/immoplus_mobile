import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/design_system.dart';

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

  static const List<String> _cardAssets = [
    'assets/img/card1_intermediate.png',
    'assets/img/card2_intermediate.png',
    'assets/img/card3_intermediate.png',
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

          final isFront = (fromSlotIndex == 1 && t < 0.5) ||
              (fromSlotIndex == 0 && t >= 0.5);

          return _CardRenderData(
            cardIndex: cardIndex,
            assetPath: _cardAssets[cardIndex],
            dx: dx,
            dy: dy,
            angle: angle,
            scale: scale,
            opacity: opacity,
            zIndex: zIndex,
            isFront: isFront,
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
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.alphaBlack12,
                              blurRadius: item.isFront ? 20 : 10,
                              offset: Offset(0, item.isFront ? 10 : 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.asset(
                            item.assetPath,
                            fit: BoxFit.contain,
                            height: 310,
                          ),
                        ),
                      ),
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
  final String assetPath;
  final double dx;
  final double dy;
  final double angle;
  final double scale;
  final double opacity;
  final double zIndex;
  final bool isFront;

  const _CardRenderData({
    required this.cardIndex,
    required this.assetPath,
    required this.dx,
    required this.dy,
    required this.angle,
    required this.scale,
    required this.opacity,
    required this.zIndex,
    required this.isFront,
  });
}
