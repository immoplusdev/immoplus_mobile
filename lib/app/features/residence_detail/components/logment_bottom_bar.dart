import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/features/booking/booking_formular_action.dart';
import 'package:immoplus/app/utils/utils.dart';

class LogmentBottomBar extends StatelessWidget {
  LogmentBottomBar({super.key, required this.residenceModel});
  final ResidenceModel residenceModel;
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
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        BookingFormularAction(residenceModel: residenceModel)));
          }
        },
        child: const Text('Réserver'),
      ),
    );
  }
}
