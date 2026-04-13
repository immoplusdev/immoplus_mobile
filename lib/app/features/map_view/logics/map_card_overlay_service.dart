import 'package:flutter/material.dart';
import 'package:immoplus/app/services/navigation_service.dart';

class MapCardOverlayService {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  static final ValueNotifier<Widget?> _childNotifier = ValueNotifier(null);
  static double _bottomPadding = 100;

  static void show({
    required Widget child,
    double bottomPadding = 220,
    BuildContext? context,
  }) {
    _bottomPadding = bottomPadding;

    if (_isShowing) {
      _childNotifier.value = child;
      return;
    }

    _childNotifier.value = child;

    // Utiliser le navigatorKey global pour éviter le crash "deactivated widget"
    final ctx = context ??
        NavigationService.navigatorKey.currentContext;
    if (ctx == null) return;

    final overlay = Overlay.maybeOf(ctx);
    if (overlay == null) return;

    _overlayEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        bottom: _bottomPadding + MediaQuery.of(ctx).viewPadding.bottom,
        left: 16,
        right: 16,
        child: _AnimatedCardEntry(childNotifier: _childNotifier),
      ),
    );

    overlay.insert(_overlayEntry!);
    _isShowing = true;
  }

  static void hide() {
    if (!_isShowing || _overlayEntry == null) return;
    try {
      _overlayEntry!.remove();
    } catch (_) {
      // Widget déjà désactivé — safe à ignorer
    }
    _overlayEntry = null;
    _isShowing = false;
    _childNotifier.value = null;
  }

  static bool get isShowing => _isShowing;
}

class _AnimatedCardEntry extends StatefulWidget {
  const _AnimatedCardEntry({required this.childNotifier});
  final ValueNotifier<Widget?> childNotifier;

  @override
  State<_AnimatedCardEntry> createState() => _AnimatedCardEntryState();
}

class _AnimatedCardEntryState extends State<_AnimatedCardEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          color: Colors.transparent,
          child: ValueListenableBuilder<Widget?>(
            valueListenable: widget.childNotifier,
            builder: (context, child, _) {
              if (child == null) return const SizedBox.shrink();
              return Center(child: child);
            },
          ),
        ),
      ),
    );
  }
}
