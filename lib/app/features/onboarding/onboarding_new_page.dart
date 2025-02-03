import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // PageView

            Expanded(
              flex: 4,
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildPage(
                    color: Colors.blueAccent,
                    title: "BIENVENUE SUR IMMOPLUS",
                    content:
                        "Votre application tout en  un est disponible, découvrons nos offres.",
                  ),
                  _buildPage(
                    color: Colors.greenAccent,
                    title: "RESERVATION",
                    content:
                        "Plus besoins de se promener ou se déplacer pour faire une réservation de bien immobilier, immoplus s’en occupe.",
                  ),
                  _buildPage(
                    color: Colors.orangeAccent,
                    title: "DEMENAGEMENT",
                    content:
                        "Immoplus vous permet de gérer vos déménagement en un seul clic.",
                  ),
                ],
              ),
            ),
            // Stepper (dots indicator)
            SizedBox(
              height: 80,
              //color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 10,
                    width: _currentPage == index ? 20 : 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
            ),
            // Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButtom(
                text: _currentPage < 2
                    ? "Suivant".toUpperCase()
                    : "Commencer".toUpperCase(),
                onClick: () async {
                  if (_currentPage < 2) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // Action when onboarding is complete
                    // Navigate to home or another screen
                    print("Onboarding terminé !");

                    await sessionManager.setOpended().then(
                      (value) {
                        AppRouter.showOnboarding = false;
                        context.goNamed(HomePage.name);
                      },
                    );
                  }
                },
              ),
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButtom(
                text: 'Passer',
                onClick: () async {
                  await sessionManager.setOpended().then(
                    (value) {
                      AppRouter.showOnboarding = false;
                      context.goNamed(HomePage.name);
                    },
                  );
                },
                color: Colors.white,
                textColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(
      {required Color color, required String title, required String content}) {
    return Container(
      //color: color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade300,
                ),
                margin: const EdgeInsets.symmetric(vertical: 50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      20), // Applique les bords arrondis à l'image
                  child: Image.asset(
                    'assets/img/visit.jpg', // Chemin de l'image locale
                    width: 280,
                    height: 380,
                    fit: BoxFit
                        .cover, // Ajuste l'image pour remplir le conteneur
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
