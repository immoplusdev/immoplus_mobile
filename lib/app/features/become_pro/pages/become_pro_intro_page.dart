import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/features/become_pro/pages/become_pro_form_page.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/gen/assets.gen.dart';

class BecomeProIntroPage extends StatelessWidget {
  const BecomeProIntroPage({super.key});

  static const String name = 'BECOME_PRO_INTRO_PAGE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gradientBottom,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gradientTop, AppColors.gradientBottom],
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
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3)
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
                  const SizedBox(height: 48),

                  // Title
                  Center(
                    child: Text(
                      "Passez en compte\nprofessionnel",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subtitle
                  Center(
                    child: Text(
                      "Publiez vos biens, gérez vos annonces et atteignez\nplus de clients avec Immo Plus.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Badges
                  _buildFeatureBadge("Publier des appartements et terrains"),
                  const SizedBox(height: 16),
                  _buildFeatureBadge("Gérer vos demandes facilement"),
                  const SizedBox(height: 16),
                  _buildFeatureBadge("Toucher plus de clients"),

                  const Spacer(),

                  // Bottom Button

                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: CustomButtom(
                      text: "Devenir Pro",
                      // color: AppColors.darkBluePrimary,
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
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
