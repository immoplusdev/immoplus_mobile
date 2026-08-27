import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/features/hotel/widgets/hotel_page_header.dart';
import 'package:immoplus/app/utils/app_colors.dart';

/// Affiché à la place du flux normal de la page Hôtel tant que le module
/// est désactivé côté plateforme (GET /pms/hotels/module-status → active: false).
class HotelComingSoonView extends StatelessWidget {
  const HotelComingSoonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const HotelPageHeader(),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              Iconsax.building,
                              color: AppColors.primary,
                              size: 44,
                            ),
                          ),
                          const Gap(28),
                          Text(
                            "Bientôt disponible",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Gap(12),
                          Text(
                            "Hôtel arrive très prochainement. "
                            "Revenez bientôt pour réserver votre chambre !",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
