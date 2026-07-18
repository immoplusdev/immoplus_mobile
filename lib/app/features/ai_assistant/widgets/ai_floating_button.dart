import 'dart:math' as math;
import 'dart:ui';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:animate_do/animate_do.dart';
import 'package:concentric_transition/clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/home_page/logic/home_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/login_page/login_page.dart';
import 'package:immoplus/app/routes/app_router.dart';
import '../pages/ai_assistant_page.dart';
// ignore: unused_import
import 'ai_assistant_bottom_sheet.dart';

const Map<int, String> _iaLabels = {
  0: 'Hôte IA', // Résidences
  1: 'Hôte IA', // Hôtel
  2: 'Hôte IA', // Locations
  3: 'Decor IA', // Meubles
  4: 'Deal IA', // Achats
};

/// Notifier partagé : true quand l'utilisateur scrolle (pilule compactée à droite).
final ValueNotifier<bool> aiFabCollapsedNotifier = ValueNotifier<bool>(false);

/// Variante propre de ConcentricPageRoute : retire le clip dès que l'animation
/// est terminée (évite le disque résiduel laissé par la formule du clipper).
// ignore: unused_element
class _CleanConcentricRoute<T> extends PageRoute<T> {
  _CleanConcentricRoute({required this.builder});
  final WidgetBuilder builder;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 700);
  @override
  bool get opaque => false;
  @override
  Color? get barrierColor => null;
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      builder(context);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        if (animation.status == AnimationStatus.completed) return child;
        return ClipPath(
          clipper: ConcentricClipper(progress: animation.value),
          child: child,
        );
      },
      child: child,
    );
  }
}

class AiFloatingButton extends StatefulWidget {
  const AiFloatingButton({super.key});

  @override
  State<AiFloatingButton> createState() => _AiFloatingButtonState();
}

const TextStyle _pillTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w900,
  // letterSpacing: 0.3,
  color: Color.fromARGB(255, 26, 25, 25),
);

class _AiFloatingButtonState extends State<AiFloatingButton>
    with TickerProviderStateMixin {
  late final AnimationController _breathingController;
  late final AnimationController _orbController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  Future<void> _showAiModal(BuildContext context) async {
    HapticFeedback.heavyImpact();

    // Guard : vérifier que l'utilisateur est connecté avant d'ouvrir le chat.
    final session = getIt<SessionManager>();
    final user = session.currentUser ?? await session.getCurrentUser();

    if (!context.mounted) return;

    if (user == null) {
      AppRouter.router.push(LoginPage.routePath());
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 1.0,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: const AiAssistantPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeBottomPadding = MediaQuery.of(context).padding.bottom;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(bottom: safeBottomPadding > 0 ? 0 : 4.0),
      // Slide droite au scroll — désactivé (voir aiFabCollapsedNotifier).
      // child: ValueListenableBuilder<bool>(
      //   valueListenable: aiFabCollapsedNotifier,
      //   builder: (context, collapsed, child) {
      //     final slideX = collapsed ? (screenWidth * 0.5 - 55) : 0.0;
      //     return TweenAnimationBuilder<double>(
      //       tween: Tween<double>(end: slideX),
      //       duration: const Duration(milliseconds: 480),
      //       curve: Curves.easeOutCubic,
      //       builder: (context, value, inner) {
      //         return Transform.translate(
      //           offset: Offset(value, 0),
      //           child: inner,
      //         );
      //       },
      //       child: child,
      //     );
      //   },
      //   child: ...
      // ),
      child: AnimatedBuilder(
        animation: _breathingController,
        builder: (context, child) {
          final breath = 1.0 + (_breathingController.value * 0.015);
          return Transform.scale(
            scale: _isPressed ? 0.95 : breath,
            child: child,
          );
        },
        child: GestureDetector(
          onTapDown: (_) {
            HapticFeedback.selectionClick();
            setState(() => _isPressed = true);
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
            _showAiModal(context);
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: IntrinsicWidth(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 24,
                    spreadRadius: 1,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.95),
                            const Color(0xFFF5F3EF).withOpacity(0.85),
                            const Color(0xFFE8E4DC).withOpacity(0.75),
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.9),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // ORB (reste en background)
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _orbController,
                              builder: (context, _) {
                                final t = _orbController.value;
                                return Align(
                                  alignment: Alignment(
                                    math.sin(t * 2 * math.pi),
                                    math.sin(t * 4 * math.pi) * 0.6,
                                  ),
                                  child: ImageFiltered(
                                    imageFilter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color.fromRGBO(0, 194, 255, 0),
                                            Color(0xFFFF29C3),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // LIGHT OVERLAY (ne doit pas influencer le layout)
                          IgnorePointer(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 14,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withOpacity(0.95),
                                      Colors.white.withOpacity(0),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                              ),
                            ),
                          ),

                          // CONTENU CENTRÉ (clé du fix)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/img/bubble_2.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  BlocBuilder<HomePageCubit, HomePageState>(
                                    buildWhen: (p, n) =>
                                        p.indexPage != n.indexPage,
                                    builder: (context, state) {
                                      final label =
                                          _iaLabels[state.indexPage] ?? 'AI';

                                      return AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 320),
                                        child: Text(
                                          label,
                                          key: ValueKey(label),
                                          style: _pillTextStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
