import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/status_chip.dart';

class BookingPaymentStatus extends StatelessWidget {
  const BookingPaymentStatus({super.key, required this.reservationModel});
  final ReservationModel reservationModel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      leading: const CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 15,
        child: FaFaIcon(
          FontAwesomeIcons.moneyBillWave,
          color: Colors.green,
        ),
      ),
      horizontalTitleGap: 3,
      dense: true,
      title: const Text('Statut de paiement :'),
      trailing: StatusChip(
          text: Utils.getServiceStatus(reservationModel.statusFacture ?? ''),
          status: reservationModel.statusFacture),
    );
  }
}
