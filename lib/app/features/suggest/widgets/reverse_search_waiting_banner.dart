import 'dart:async';
import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/lottie_assets.dart';

/// Affiché à la place de "Libre tout de suite" tant qu'aucun match temps réel
/// n'est encore arrivé — fait défiler 3 courtes phrases une seule fois (pas
/// de boucle) pour accompagner l'attente sans dupliquer la promesse une fois
/// que les vrais résultats sont là.
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
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted || _index >= _phrases.length - 1) {
        timer.cancel();
        return;
      }
      setState(() => _index++);
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: LottieAssets().orderChecking,
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
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
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
