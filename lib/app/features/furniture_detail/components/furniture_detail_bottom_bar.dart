import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
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
            context.pushNamed(AuthenticationPage.name);
            return;
          }

          final phone = furnitureModel.ownerPhoneNumber.trim();
          if (phone.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Numéro du propriétaire indisponible"),
              ),
            );
            return;
          }
          Utils.makePhoneCall(phone);
        },
        child: const Text('CONTACTER'),
      ),
    );
  }
}
