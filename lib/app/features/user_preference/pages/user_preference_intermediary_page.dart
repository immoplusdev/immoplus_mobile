import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/account/widgets/general_condition_page.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/user_preference/widgets/animated_cards_fanout.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

class UserPreferenceIntermediaryPage extends StatelessWidget {
  const UserPreferenceIntermediaryPage({super.key});

  static const String routePath = '/user_preference_intermediary';
  static const String name = 'USER_PREFERENCE_INTERMEDIARY_PAGE';

  void _showTerms(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              const Gap(12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.immoBorderStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Gap(8),
                ],
              ),
              const Expanded(
                child: GeneralConditionPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(12),
                        // Illustration animée avec rotation fluide des cards
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: size.height * 0.44,
                              maxWidth: size.width,
                            ),
                            child: const AnimatedCardsFanout(),
                          ),
                        ),
                        const Gap(20),
                        // Titre avec icônes et mots stylisés
                        _buildHeadline(context),
                        const Spacer(),
                        const Gap(24),
                        // Bouton principal d'inscription / connexion
                        CustomButtom(
                          buttonHeight: 54,
                          borderRadius: BorderRadius.circular(30),
                          color: AppColors.immoBrandPrimary,
                          onClick: () {
                            context.pushNamed(AuthenticationPage.name);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/icons/auth_ic.svg"),
                              const Gap(10),
                              Text(
                                "S'inscrire / Se connecter",
                                style: AppTypography.button.copyWith(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        // Bouton mode invité
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              context.goNamed(HomePage.name);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: Text(
                                'Continuer en mode invité',
                                style: AppTypography.bodyMediumMedium.copyWith(
                                  color: AppColors.immoTextSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Gap(24),
                        // Conditions d'utilisation et politique de confidentialité
                        _buildLegalFooter(context),
                        const Gap(16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeadline(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTypography.font(
          fontSize: 39,
          fontWeight: FontWeight.w600,
          color: AppColors.immoTextPrimary,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        children: [
          const TextSpan(text: 'Trouvez '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SvgPicture.asset(
                'assets/icons/calandar_intermediar.svg',
                width: 38,
                height: 38,
              ),
            ),
          ),
          const TextSpan(text: ' le\n'),
          const TextSpan(
            text: 'bien qui ',
            style: TextStyle(
              color: Color(0xFFFFC700),
              fontWeight: FontWeight.w800,
            ),
          ),
          const TextSpan(text: 'vous\n'),
          const TextSpan(text: 'ressemble. '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _buildAvatarStack(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStack() {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Image.asset(
        'assets/img/avatar_intermediar.png',
        height: 38,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildLegalFooter(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.immoTextDisabled,
          fontSize: 11,
          height: 1.45,
        ),
        children: [
          const TextSpan(text: 'En continuant, vous acceptez nos '),
          TextSpan(
            text: "Conditions d'utilisation",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: AppColors.immoTextSecondary,
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _showTerms(context),
          ),
          const TextSpan(text: ' et notre '),
          TextSpan(
            text: 'Politique de confidentialité.',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: AppColors.immoTextSecondary,
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _showTerms(context),
          ),
        ],
      ),
    );
  }
}
