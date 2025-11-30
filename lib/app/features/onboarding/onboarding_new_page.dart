import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

const _sizeButton = 60.0;

class OnboardingNewPage extends StatefulWidget {
  const OnboardingNewPage({super.key});
  static String name = 'ONBOARDING_NEW';
  @override
  _OnboardingNewPageState createState() => _OnboardingNewPageState();
}

class _OnboardingNewPageState extends State<OnboardingNewPage> {
  final sessionManager = getIt<SessionManager>();

  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnBoardingItem> items = [
    OnBoardingItem(
      title: "Bienvenue sur Immo Plus",
      content: "Trouvez, réservez et installez-vous facilement.",
      image: "assets/img/onb_1.jpeg",
    ),
    OnBoardingItem(
      title: "Trouvez votre bien en un clic.",
      content:
          "Trouvez facilement des logements proches de chez vous grâce à la carte.",
      image: "assets/img/onb_2.jpeg",
    ),
    OnBoardingItem(
      title: "Réservez et achetez en toute sécurité",
      content:
          "Profitez d'un processus simple, sécurisé et garanti pour trouver votre logement idéal.",
      image: "assets/img/onb_3.jpeg",
    ),
    OnBoardingItem(
      title: "Louez votre futur chez-vous en un clic",
      content:
          "Trouvez et réservez facilement le logement qui vous correspond.",
      image: "assets/img/onb_3.jpeg",
    ),
  ];

  /// Navigation vers la page d'accueil après avoir marqué l'onboarding comme lu
  Future<void> _navigateToHome() async {
    await sessionManager.markOnboardingAsRead();
    if (mounted) {
      context.goNamed(HomePage.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            itemCount: items.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildPage(
                title: item.title,
                content: item.content,
                image: item.image,
              );
            },
          ),
          // Stepper (dots indicator)
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(items.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppColors.customBlue
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          );
                        }),
                      ),
                    ),
                    Text(
                      items[_currentPage].title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const Gap(18),
                    Text(
                      items[_currentPage].content,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                    const Gap(25),
                    // Next Button
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () async {
                            if (_currentPage < items.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              await _navigateToHome();
                            }
                          },
                          child: Container(
                            width: _sizeButton,
                            height: _sizeButton,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.customBlue,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ),
                        )),
                    Gap(MediaQuery.of(context).padding.bottom),
                    // const Gap(10),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: CustomButtom(
                    //     text: 'Passer',
                    //     onClick: _navigateToHome,
                    //     color: Colors.white,
                    //     textColor: Colors.black,
                    //   ),
                    // ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildPage(
      {required String title, required String content, required String image}) {
    return Image.asset(
      image, // Chemin de l'image locale
      width: 300,
      height: 400,
      fit: BoxFit.cover, // Ajuste l'image pour remplir le conteneur
    );
  }
}

class OnBoardingItem {
  final String title;
  final String content;
  final String image;

  OnBoardingItem({
    required this.title,
    required this.content,
    required this.image,
  });
}
