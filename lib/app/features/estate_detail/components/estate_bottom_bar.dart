import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/auth_redirect_service.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/visits/visit_formular_action.dart';
import 'package:immoplus/app/utils/contact_utils.dart';

class EstateBottomBar extends StatelessWidget {
  EstateBottomBar({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;
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
                popUntilRouteName: EstatePage.name,
                callback: () => _proceed(context),
              ));
              context.pushNamed(AuthenticationPage.name);
            } else {
              _proceed(context);
            }
          },
          child: Text(bienImmobilier.aLouer ? 'VISITER' : 'CONTACTER')),
    );
  }

  void _proceed(BuildContext context) {
    if (bienImmobilier.aLouer) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => VisitFormularAction(bienImmoModel: bienImmobilier),
        ),
      );
    } else {
      ContactUtils.showContact(id: bienImmobilier.id);
    }
  }
}
