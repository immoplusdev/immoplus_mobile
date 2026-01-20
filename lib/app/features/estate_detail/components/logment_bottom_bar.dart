import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/features/visits/visit_formular_action.dart';
import 'package:immoplus/app/utils/contact_utils.dart';
import 'package:immoplus/app/utils/utils.dart';

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
              Utils.authentificationPopup(context: context);
            } else {
              if (bienImmobilier.aLouer) {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => VisitFormularAction(
                            bienImmoModel: bienImmobilier)));
              } else {
                ContactUtils.showContact(id: bienImmobilier.id);
              }
            }
          },
          child: Text(bienImmobilier.aLouer ? 'VISITER' : 'CONTACTER')),
      //color: Colors.red,
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Flexible(
      //         flex: 2,
      //         child: RichText(
      //             text: TextSpan(children: [
      //           TextSpan(
      //               text: Utils.formatCurrency(bienImmobilier.prix),
      //               style: Theme.of(context).textTheme.headlineSmall),
      //           TextSpan(
      //               text: bienImmobilier.typeLocation,
      //               style: TextStyle(color: Colors.grey.shade700))
      //         ]))),
      //     Flexible(
      //       child: CustomButtom(
      //         onClick: () {
      //           if (SessionManager().currentUser == null) {
      //             Utils.authentificationPopup(context: context);
      //           } else {
      //             if (bienImmobilier.aLouer) {
      //               Navigator.push(
      //                   context,
      //                   CupertinoPageRoute(
      //                       builder: (context) => VisitFormularAction(
      //                           bienImmoModel: bienImmobilier)));
      //             } else {
      //               ContactUtils.showContact(id: bienImmobilier.id);
      //             }
      //           }
      //         },
      //         text: bienImmobilier.aLouer ? 'VISITER' : 'CONTACTER',
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
