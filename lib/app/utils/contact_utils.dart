import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/svgs_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUtils {
  static showContact({String? id}) => showModalBottomSheet(
        context: NavigationService.navigatorKey.currentContext!,
        showDragHandle: true,
        backgroundColor: AppColors.whiteBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        builder: (context) {
          final phone = getIt<SessionManager>().configModel?.data?.contactPhoneNumber ?? '';
          final email = getIt<SessionManager>().configModel?.data?.contactEmail ?? '';
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 20),
                  child: Text(
                    "Nous contacter",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D0D0D),
                    ),
                  ),
                ),
                _contactTile(
                  context: context,
                  leading: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Iconsax.message, size: 18, color: Color(0xFF25D366)),
                  ),
                  title: "WhatsApp",
                  subtitle: "Écrivez-nous sur WhatsApp",
                  accentColor: const Color(0xFF25D366),
                  onTap: () => Utils.whatsapp(phoneNumber: phone),
                ),
                const Gap(10),
                _contactTile(
                  context: context,
                  leading: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Iconsax.call, size: 18, color: AppColors.primary),
                  ),
                  title: "Appel téléphonique",
                  subtitle: "Appeler notre service client",
                  accentColor: AppColors.primary,
                  onTap: () => Utils.makePhoneCall(phone),
                ),
                const Gap(10),
                _contactTile(
                  context: context,
                  leading: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEA4335).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: SvgPicture.asset(SVGMap.map['gmail']!),
                    ),
                  ),
                  title: "Email",
                  subtitle: "Envoyez-nous un e-mail",
                  accentColor: const Color(0xFFEA4335),
                  onTap: () async {
                    final uri = Uri(scheme: 'mailto', path: email);
                    await launchUrl(uri);
                  },
                ),
              ],
            ),
          );
        },
      );

  static Widget _contactTile({
    required BuildContext context,
    required Widget leading,
    required String title,
    required String subtitle,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              leading,
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const Gap(2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: const Color(0xFFD1D5DB), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
