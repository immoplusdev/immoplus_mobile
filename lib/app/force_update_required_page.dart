import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/version_app_widget.dart';
import 'package:lottie/lottie.dart';

class ForceUpdateRequiredPage extends StatefulWidget {
  final VoidCallback? onUpdateTap;
  const ForceUpdateRequiredPage({super.key, this.onUpdateTap});

  static String name = 'ForceUpdateRequiredPage';
  static String routePath() => '/ForceUpdateRequiredPage';

  static String route() => routePath();

  @override
  State<ForceUpdateRequiredPage> createState() =>
      _ForceUpdateRequiredPageState();
}

class _ForceUpdateRequiredPageState extends State<ForceUpdateRequiredPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ConfettiController _confettiController;
  late ConfettiController _confettiControllerRight;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Initialiser les contrôleurs de confetti
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 3));

    // Démarrer les confetti automatiquement après un délai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _startConfetti();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    _confettiControllerRight.dispose();
    super.dispose();
  }

  void _startConfetti() {
    _confettiController.play();
    _confettiControllerRight.play();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Contenu principal
            Container(
              padding: EdgeInsets.all(appPadding),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Gap(50),
                          Center(
                              child: LottieBuilder.asset(
                            "assets/lotties/rocket.json",
                            width: 200,
                            height: 200,
                          )),
                          Gap(30),
                          Text(
                            "Mise à jour obligatoire",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Veuillez mettre à jour votre application pour continuer, elle contient des améliorations importantes.",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                          Gap(24),
                        ],
                      ),
                    ),
                  ),
                  VersionAppWidget(),
                  CustomButtom(
                    text: 'Mettre à jour',
                    onClick: widget.onUpdateTap,
                  ),
                  Gap(24),
                ],
              ),
            ),

            // Confetti central (du haut vers le bas)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,

                blastDirection: 1.5708, // Vers le bas (π/2)
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.05,
                numberOfParticles: 50,
                maxBlastForce: 90,
                minBlastForce: 70,
                gravity: 0.1,
                particleDrag: 0.05,
                colors: const [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),

            // Confetti droite (diagonale vers la gauche)
            Align(
              alignment: Alignment.topRight,
              child: ConfettiWidget(
                confettiController: _confettiControllerRight,
                blastDirection: 2.3562, // 135 degrés vers la gauche
                emissionFrequency: 0.03,
                numberOfParticles: 30,
                maxBlastForce: 80,
                minBlastForce: 60,
                gravity: 0.1,
                particleDrag: 0.05,
                colors: const [
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                  Colors.cyan,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
