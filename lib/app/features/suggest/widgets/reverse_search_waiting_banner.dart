import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Affiché à la place de "Libre tout de suite" tant qu'aucun match temps réel
class ReverseSearchWaitingBanner extends StatefulWidget {
  const ReverseSearchWaitingBanner({super.key});

  @override
  State<ReverseSearchWaitingBanner> createState() =>
      _ReverseSearchWaitingBannerState();
}

class _ReverseSearchWaitingBannerState
    extends State<ReverseSearchWaitingBanner> {
  static const _phrases = [
    'On cherche pour vous...',
    'Encore un instant...',
    "Vos meilleures options s'affichent ici.",
  ];

  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1600), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _index = (_index + 1) % _phrases.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Column(
        children: [
          const _SearchingImageFan(),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Text(
              _phrases[_index],
              key: ValueKey(_index),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FanSlot {
  const _FanSlot({
    required this.left,
    required this.top,
    required this.angle,
    required this.opacity,
    required this.scale,
  });

  final double left;
  final double top;
  final double angle;
  final double opacity;
  final double scale;
}

/// Pile de 3 cartes-images en éventail centré (carte du milieu devant, plus
class _SearchingImageFan extends StatefulWidget {
  const _SearchingImageFan();

  @override
  State<_SearchingImageFan> createState() => _SearchingImageFanState();
}

class _SearchingImageFanState extends State<_SearchingImageFan> {
  static const List<String> _images = [
    'assets/img/residence.png',
    'assets/img/terrain.png',
    'assets/img/meuble.png',
  ];

  static const double _cardSize = 72;

  static const List<_FanSlot> _slots = [
    _FanSlot(left: 0, top: 22, angle: -0.34, opacity: 0.75, scale: 0.85),
    _FanSlot(left: 39, top: 0, angle: 0.0, opacity: 1, scale: 1),
    _FanSlot(left: 78, top: 22, angle: 0.34, opacity: 0.75, scale: 0.85),
  ];

  static const Duration _shuffleInterval = Duration(seconds: 3);
  static const Duration _moveDuration = Duration(milliseconds: 550);

  Timer? _shuffleTimer;
  List<int> _slotForImage = [0, 1, 2];

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
    // Ordre de peinture arrière → avant, selon le slot courant de chaque image.
    final paintOrder = List<int>.generate(3, (i) => i)
      ..sort((a, b) => _slotForImage[a].compareTo(_slotForImage[b]));

    return SizedBox(
      width: _slots.last.left + _cardSize,
      height: _slots.map((s) => s.top).reduce(math.max) + _cardSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final imageIndex in paintOrder)
            _buildImage(imageIndex, _slots[_slotForImage[imageIndex]]),
        ],
      ),
    );
  }

  Widget _buildImage(int imageIndex, _FanSlot slot) {
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
        child: AnimatedScale(
          scale: slot.scale,
          duration: _moveDuration,
          curve: Curves.easeInOutCubic,
          child: AnimatedOpacity(
            opacity: slot.opacity,
            duration: _moveDuration,
            child: Container(
              width: _cardSize,
              height: _cardSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(_images[imageIndex], fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
