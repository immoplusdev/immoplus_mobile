import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/auth_redirect_service.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/furniture_detail/furniture_detail_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/utils/utils.dart';

class FurnitureDetailBottomBar extends StatelessWidget {
  FurnitureDetailBottomBar({super.key, required this.furnitureModel});
  final FurnitureModel furnitureModel;
  final sessionManager = getIt<SessionManager>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20)
          .copyWith(bottom: 20, top: 10),
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          if (sessionManager.currentUser == null) {
            getIt<AuthRedirectService>().set((
              popUntilRouteName: FurnitureDetailPage.name,
              callback: () => _proceed(context),
            ));
            context.pushNamed(AuthenticationPage.name);
          } else {
            _proceed(context);
          }
        },
        child: const Text('CONTACTER'),
      ),
    );
  }

  _proceed(BuildContext context) {
    final phone = furnitureModel.ownerPhoneNumber.trim();
    if (phone.isEmpty) {
      ToastUtils.error("Numéro du propriétaire indisponible");
      return;
    }

    final localisation = [
      furnitureModel.communeModel?.name,
      furnitureModel.villeModel?.name,
    ].where((e) => e != null && e.isNotEmpty).join(', ');

    final defaultMessage = "Bonjour, je suis intéressé(e) par l'annonce "
        "\"${furnitureModel.titre}\""
        "${furnitureModel.prix > 0 ? ' au prix de ${furnitureModel.prix} FCFA' : ''}"
        "${localisation.isNotEmpty ? '($localisation)' : ''}"
        "${furnitureModel.codeFurniture != null ? ' (Réf: ${furnitureModel.codeFurniture})' : ''}."
        "\nPouvez-vous me donner plus d'informations ?";
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.scafold,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              child: ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                leading: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    FontAwesomeIcons.whatsapp.data,
                    color: Colors.green,
                  ),
                ),
                title: const Text('Contacter sur WhatsApp'),
                titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                trailing: const Icon(
                  CupertinoIcons.chevron_right_circle_fill,
                  color: Colors.green,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Utils.whatsapp(
                      phoneNumber: phone, defaultMessage: defaultMessage);
                },
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              child: ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                leading: const Icon(
                  FontAwesomeIcons.headset.data,
                  color: Colors.black,
                ),
                title: const Text('Contacter par appel'),
                titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                trailing: const Icon(
                  CupertinoIcons.chevron_right_circle_fill,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Utils.makePhoneCall(phone);
                },
              ),
            ),
          ),
          Gap(20)
        ],
      ),
    );
  }
}
