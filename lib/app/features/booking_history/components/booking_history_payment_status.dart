import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/custom_chip.dart';

class BookingHistoryPaymentStatus extends StatelessWidget {
  const BookingHistoryPaymentStatus(
      {super.key, required this.reservationModel});
  final ReservationModel reservationModel;
  @override
  Widget build(BuildContext context) {
    return CustomChip(
        //padding: EdgeInsets.zero,
        backgroundColor:
            Utils.getServiceStatusColor(reservationModel.statusFacture)
                .withOpacity(0.2),
        label: Utils.getServiceStatus(reservationModel.statusFacture),
        labelStyle: TextStyle(
          fontSize: 12,
          color: Utils.getServiceStatusColor(
            reservationModel.statusFacture,
          ),
        ));
  }
}
