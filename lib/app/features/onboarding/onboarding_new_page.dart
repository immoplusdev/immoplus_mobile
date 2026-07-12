import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/user_preference/pages/user_preference_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class OnboardingData {
  final String title1;
  final String title2;
  final String title3;
  final String svg;
  final String image;

  const OnboardingData({
    required this.title1,
    required this.title2,
    required this.title3,
    required this.svg,
    required this.image,
  });
}

class OnboardingNewPage extends StatefulWidget {
  const OnboardingNewPage({super.key});
  static String name = 'ONBOARDING_NEW';

  @override
  State<OnboardingNewPage> createState() => _OnboardingNewPageState();
}

class _OnboardingNewPageState extends State<OnboardingNewPage>
    with TickerProviderStateMixin {
  final sessionManager = getIt<SessionManager>();
  final PageController _pageController = PageController();
  late AnimationController _dragController;
  late Animation<double> _dragAnimation;
  late AnimationController _hintController;
  late Animation<double> _hintAnimation;
  double _dragOffset = 0.0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _dragAnimation = const AlwaysStoppedAnimation(0.0);
    _dragController.addListener(() {
      setState(() {
        _dragOffset = _dragAnimation.value;
      });
    });

    _hintController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _hintAnimation = Tween<double>(begin: 0.0, end: -12.0).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );
    _hintController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dragController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  final List<OnboardingData> _pages = const [
    OnboardingData(
      title1: 'Réserve',
      title2: 'Ton bien',
      title3: 'Où tu veux',
      svg: 'assets/img/onboarding/direct-up.svg',
      image: 'assets/img/onboarding/1.png',
    ),
    OnboardingData(
      title1: 'Explore',
      title2: 'les biens',
      title3: 'En Reel',
      svg: 'assets/img/onboarding/play.svg',
      image: 'assets/img/onboarding/2.png',
    ),
  ];

  void _navigateToHome() {
    context.goNamed(UserPreferencePage.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Radial Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 0.4),
                  radius: 0.8,
                  colors: [
                    AppColors.customBlue.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Linear Gradient at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification &&
                  notification.dragDetails != null) {
                setState(() {
                  _dragOffset += notification.dragDetails!.delta.dy;
                  if (_dragOffset > 0) _dragOffset = 0;
                  if (_dragOffset < -150) _dragOffset = -150;
                });
              } else if (notification is ScrollEndNotification) {
                // Seulement naviguer si on était déjà sur la dernière page et qu'on a un offset valide
                if (_currentPage == _pages.length - 1 && _dragOffset < -60) {
                  _navigateToHome();
                }

                // Animation de retour plus snappée (easeOutBack)
                _dragAnimation = Tween<double>(begin: _dragOffset, end: 0.0)
                    .animate(CurvedAnimation(
                        parent: _dragController, curve: Curves.easeOutBack));
                _dragController.forward(from: 0.0);
              }
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _dragOffset =
                      0.0; // Reset pour éviter de garder l'offset de la page précédente
                });
              },
              itemBuilder: (context, index) {
                return _buildPage(_pages[index], index);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomCurvedButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data, int index) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    data.title1,
                    style: GoogleFonts.dmSans(
                      fontSize: 55,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF00122E),
                      height: 1.1,
                    ),
                  ),
                ),
                FadeInLeft(
                  duration: const Duration(milliseconds: 700),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        data.svg,
                        width: 50,
                        height: 50,
                      ),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          data.title2,
                          style: GoogleFonts.dmSans(
                            fontSize: 55,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF00122E),
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    data.title3,
                    style: GoogleFonts.dmSans(
                      fontSize: 55,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF00122E),
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          Expanded(
            child: FadeIn(
              duration: const Duration(milliseconds: 1000),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(data.image),
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          const Gap(20), // Space for the curved button
        ],
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
      // On limite le drag vers le haut (valeurs négatives) et vers le bas à 0
      if (_dragOffset > 0) _dragOffset = 0;
      if (_dragOffset < -150) _dragOffset = -150;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    // Si on a tiré assez fort vers le haut
    if (_dragOffset < -60) {
      if (_currentPage < _pages.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else {
        _navigateToHome();
      }
    }

    // Animation de retour élastique (Bounce back)
    _dragAnimation = Tween<double>(begin: _dragOffset, end: 0.0).animate(
      CurvedAnimation(parent: _dragController, curve: Curves.easeOutBack),
    );
    _dragController.forward(from: 0.0);
  }

  Widget _buildBottomCurvedButton() {
    return GestureDetector(
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      onTap: () {
        if (_currentPage < _pages.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        } else {
          _navigateToHome();
        }
      },
      child: Container(
        color: Colors
            .transparent, // Pour capter les événements tactiles sur toute la zone
        height: 120, // Zone sensible au drag
        child: FadeInUp(
          key: ValueKey(_currentPage),
          delay: const Duration(seconds: 2),
          duration: const Duration(milliseconds: 600),
          child: AnimatedBuilder(
            animation: _hintAnimation,
            builder: (context, child) {
              final hintOffset =
                  _dragOffset == 0.0 ? _hintAnimation.value : 0.0;
              final currentOffset = _dragOffset + hintOffset;

              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 100),
                    // On anime la déformation de la courbe (le bas reste fixe)
                    painter: CurvePainter(dragOffset: currentOffset),
                  ),
                  Positioned(
                    top: 30,
                    child: Transform.translate(
                      offset: Offset(0, currentOffset * 0.8),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final double dragOffset;

  CurvePainter({required this.dragOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final double baseY = size.height * 0.72;
    // On étire proportionnellement toute la forme
    final double peakY = (size.height * 0.05) + dragOffset;
    final double midY2 = (size.height * 0.18) + (dragOffset * 0.8);
    final double midY1 = (size.height * 0.48) + (dragOffset * 0.4);

    final path = Path()
      ..moveTo(0, baseY)

      // partie gauche qui monte doucement vers le dôme
      ..cubicTo(
        size.width * 0.16,
        baseY,
        size.width * 0.28,
        midY1,
        size.width * 0.40,
        midY2,
      )

      // sommet arrondi au centre
      ..cubicTo(
        size.width * 0.45,
        peakY,
        size.width * 0.55,
        peakY,
        size.width * 0.60,
        midY2,
      )

      // descente droite symétrique
      ..cubicTo(
        size.width * 0.72,
        midY1,
        size.width * 0.84,
        baseY,
        size.width,
        baseY,
      )

      // fermeture vers le bas pour que la forme remplisse le bas de l'écran
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CurvePainter oldDelegate) {
    return oldDelegate.dragOffset != dragOffset;
  }
}
