import 'package:immoplus/app/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Indicateur de frappe du fil (spec §5.6) : bulle à 3 points animés côté
/// pro, dans une zone `Semantics(liveRegion: true)` pour l'accessibilité.
class ThreadTypingIndicator extends StatefulWidget {
  const ThreadTypingIndicator({super.key, required this.label});
  final String label;

  @override
  State<ThreadTypingIndicator> createState() => _ThreadTypingIndicatorState();
}

class _ThreadTypingIndicatorState extends State<ThreadTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: widget.label,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 48, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.immoBgSurfaceMuted,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Dot(controller: _controller, delay: 0.0),
                  SizedBox(width: 4),
                  _Dot(controller: _controller, delay: 0.2),
                  SizedBox(width: 4),
                  _Dot(controller: _controller, delay: 0.4),
                ],
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.label,
                style: AppTypography.font(
                    fontSize: 12, color: AppColors.immoTextSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.controller, required this.delay});
  final AnimationController controller;
  final double delay;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = (controller.value + delay) % 1.0;
        final scale = 0.7 + (1 - (t * 2 - 1).abs()) * 0.5;
        return Opacity(
          opacity: (0.35 + (scale - 0.7) * 1.3).clamp(0.35, 1.0),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.immoTextSecondary,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
