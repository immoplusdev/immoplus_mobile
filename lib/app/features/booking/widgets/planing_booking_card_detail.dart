import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:intl/intl.dart';

import '../../../utils/utils.dart';

class PlaningBookingCardDetail extends StatelessWidget {
  PlaningBookingCardDetail({super.key, required this.reservationModel});
  final ReservationModel reservationModel;
  final DateFormat formatDate = DateFormat('d MMMM yyyy');
  @override
  Widget build(BuildContext context) {
    final String dateHeureDebut =
        "${formatDate.format(Utils.toDateTime(reservationModel.dateDebut))} à ${reservationModel.residence.heureEntree}";
    final String dateHeureFin =
        "${formatDate.format(Utils.toDateTime(reservationModel.dateFin))} avant ${reservationModel.residence.heureDepart} ";
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ListTile(
              dense: true,
              title: const Text('ARRIVÉE'),
              contentPadding: EdgeInsets.zero.copyWith(left: 3),
              titleTextStyle: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              subtitle: AutoSizeText(dateHeureDebut),
            ),
          ),
          const VerticalDivider(
            thickness: 1,
            color: Colors.grey,
          ),
          Flexible(
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('DÉPART'),
              titleTextStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.bold, color: Colors.black),
              subtitle: (reservationModel.datesReservation.isNotEmpty)
                  ? AutoSizeText(
                      dateHeureFin,
                      maxLines: 1,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
