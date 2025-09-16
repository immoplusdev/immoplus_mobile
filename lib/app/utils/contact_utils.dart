import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        backgroundColor: AppColors.scafold,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.6,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10)
                    .copyWith(bottom: 10),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(20),
                  child: ListTile(
                    tileColor: Colors.white,
                    enabled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                      ),
                    ),
                    title: const Text("Écrivez-nous sur WhatsApp"),
                    titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                    trailing: const Icon(
                      CupertinoIcons.chevron_right_circle_fill,
                      color: Colors.green,
                    ),
                    onTap: () async {
                      Utils.whatsapp(
                          phoneNumber: getIt<SessionManager>()
                              .configModel!
                              .data!
                              .contactPhoneNumber);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10)
                    .copyWith(bottom: 10),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(20),
                  child: ListTile(
                    tileColor: Colors.white,
                    enabled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    leading: const Icon(
                      FontAwesomeIcons.headset,
                      color: Colors.black,
                    ),
                    title: const Text("Appeller notre service client"),
                    titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                    trailing: const Icon(
                      CupertinoIcons.chevron_right_circle_fill,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      Utils.makePhoneCall(getIt<SessionManager>()
                          .configModel!
                          .data!
                          .contactPhoneNumber);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10)
                    .copyWith(bottom: 10),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(20),
                  child: ListTile(
                    tileColor: Colors.white,
                    enabled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    leading: SvgPicture.asset(
                      SVGMap.map['gmail']!,
                      height: 30,
                    ),
                    title: const Text("Envoyez-nous un e-mail"),
                    titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                    trailing: const Icon(
                      CupertinoIcons.chevron_right_circle_fill,
                      color: Colors.red,
                    ),
                    onTap: () async {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: getIt<SessionManager>()
                            .configModel!
                            .data!
                            .contactEmail,
                      );

                      await launchUrl(emailLaunchUri);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
