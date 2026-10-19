import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/become_pro/pages/become_pro_form_page.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/gen/assets.gen.dart';

class BecomeProIntroPage extends StatelessWidget {
  const BecomeProIntroPage({super.key});

  static const String name = 'BECOME_PRO_INTRO_PAGE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.immoBecomeProGradientBottom,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.immoBecomeProGradientTop,
                  AppColors.immoBecomeProGradientBottom
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Bottom Image Placeholder (Man in Blue Suit)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              child: Image.asset(
                Assets.img.proMan.path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image not yet added to assets
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.transparent,
                          AppColors.black.withValues(alpha: 0.3)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 48),

                  // Title
                  Center(
                    child: Text(
                      "Passez en compte\nprofessionnel",
                      textAlign: TextAlign.center,
                      style: AppTypography.h1.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Subtitle
                  Center(
                    child: Text(
                      "Publiez vos biens, gérez vos annonces et atteignez\nplus de clients avec Immo Plus.",
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Badges
                  _buildFeatureBadge("Publier des appartements et terrains"),
                  SizedBox(height: 16),
                  _buildFeatureBadge("Gérer vos demandes facilement"),
                  SizedBox(height: 16),
                  _buildFeatureBadge("Toucher plus de clients"),

                  const Spacer(),

                  // Bottom Button

                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: CustomButtom(
                      text: "Devenir Pro",
                      // color: AppColors.immoBecomeProPrimary,
                      borderRadius: BorderRadius.circular(28),
                      onClick: () {
                        context.replaceNamed(BecomeProFormPage.name);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.white,
        ),
      ),
    );
  }
}
