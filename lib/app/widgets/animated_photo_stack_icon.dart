import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Mini pile de 3 cartes-images en éventail, avec rotation/décalage subtils
/// et permutation périodique des positions (effet "shuffle") — boucle en
/// continu tant que le widget est monté.
///
/// Extrait de `TransactionsFloatingButton` pour être réutilisé ailleurs
/// (ex: tuile "Voir plus" en fin de section horizontale) à une taille
/// différente via [size].
class AnimatedPhotoStackIcon extends StatefulWidget {
  const AnimatedPhotoStackIcon({super.key, this.size = 34});

  final double size;

  @override
  State<AnimatedPhotoStackIcon> createState() => _AnimatedPhotoStackIconState();
}

class _StackSlot {
  const _StackSlot({
    required this.left,
    required this.top,
    required this.angle,
    required this.opacity,
  });

  final double left;
  final double top;
  final double angle;
  final double opacity;
}

class _AnimatedPhotoStackIconState extends State<AnimatedPhotoStackIcon> {
  static const List<String> _images = [
    'assets/img/residence.png',
    'assets/img/terrain.png',
    'assets/img/meuble.png',
  ];

  static const Duration _shuffleInterval = Duration(seconds: 3);
  static const Duration _moveDuration = Duration(milliseconds: 550);

  Timer? _shuffleTimer;
  List<int> _slotForImage = [0, 1, 2];

  /// Slots exprimés en fraction de [widget.size] (calculés sur une pile de
  /// référence de 34px) pour rester proportionnels à toute taille demandée.
  List<_StackSlot> get _slots {
    final scale = widget.size / 34;
    return [
      _StackSlot(left: 2 * scale, top: 10 * scale, angle: -0.13, opacity: 0.82),
      _StackSlot(left: 12 * scale, top: 6 * scale, angle: 0.12, opacity: 0.9),
      _StackSlot(left: 7 * scale, top: 12 * scale, angle: 0.0, opacity: 1),
    ];
  }

  double get _imageSize => widget.size * (18 / 34);

  @override
  void initState() {
    super.initState();
    _shuffleTimer = Timer.periodic(_shuffleInterval, (_) {
      if (!mounted) return;
      setState(() {
        _slotForImage = _slotForImage.map((s) => (s + 1) % 3).toList();
      });
    });
  }

  @override
  void dispose() {
    _shuffleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slots = _slots;
    // Ordre de peinture arrière → avant, selon le slot courant de chaque image.
    final paintOrder = List<int>.generate(3, (i) => i)
      ..sort((a, b) => _slotForImage[a].compareTo(_slotForImage[b]));

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final imageIndex in paintOrder)
            _buildImage(imageIndex, slots[_slotForImage[imageIndex]]),
        ],
      ),
    );
  }

  Widget _buildImage(int imageIndex, _StackSlot slot) {
    final imageSize = _imageSize;
    return AnimatedPositioned(
      key: ValueKey(_images[imageIndex]),
      duration: _moveDuration,
      curve: Curves.easeInOutCubic,
      left: slot.left,
      top: slot.top,
      child: AnimatedRotation(
        turns: slot.angle / (2 * math.pi),
        duration: _moveDuration,
        curve: Curves.easeInOutCubic,
        child: AnimatedOpacity(
          opacity: slot.opacity,
          duration: _moveDuration,
          child: Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6 * (imageSize / 18)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 3,
                  offset: const Offset(0, 1.5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6 * (imageSize / 18)),
              child: Image.asset(_images[imageIndex], fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
