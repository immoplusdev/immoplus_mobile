import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/appli/widgets/date_creation_widget.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/features/booking/booking_detail_page.dart';
import 'package:immoplus/app/features/booking_history/components/booking_history_payment_status.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/booking_utils.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/custom_chip.dart';

import 'package:intl/intl.dart';

class BookingHistoryCard extends StatelessWidget {
  BookingHistoryCard(
      {super.key, required this.reservationModel, this.clickable = true});
  final ReservationModel reservationModel;
  final DateFormat formatDate = DateFormat('d MMMM yyyy');
  final bool clickable;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 15),
      child: InkWell(
        splashColor: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        onTap: clickable
            ? () {
                showModalBottomSheet(
                  backgroundColor: AppColors.scafold,
                  showDragHandle: true,
                  enableDrag: true,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  context: context,
                  builder: (context) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: BookingDetailPage(
                        id: reservationModel.id,
                      )),
                );
              }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Ombre douce
                  spreadRadius: 1, // L'étendue de l'ombre
                  blurRadius: 10, // Flou de l'ombre
                  offset: const Offset(0, 0), // Décalage horizontal et vertical
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateCreationWidget(
                title: "DATE DE RESERVATION: ",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomChip(
                    icon: (BookingUtils.getBookingStatus(
                                reservationModel.datesReservation.first.date!,
                                reservationModel.datesReservation.last.date!) ==
                            BookingStatus.ongoing)
                        ? FontAwesomeIcons.suitcaseRolling
                        : CupertinoIcons.calendar_today,
                    iconSize: 14,
                    backgroundColor: (BookingUtils.getBookingStatus(
                                reservationModel.datesReservation.first.date!,
                                reservationModel.datesReservation.last.date!) !=
                            BookingStatus.ongoing)
                        ? Colors.blueGrey.shade200
                        : Colors.green.shade100,
                    label: BookingUtils.getStatusText(
                        startDate:
                            reservationModel.datesReservation.first.date!,
                        endDate: reservationModel.datesReservation.last.date!),
                  ),
                  BookingHistoryPaymentStatus(
                    reservationModel: reservationModel,
                  ),
                  // CustomChip(
                  //   icon: CupertinoIcons.home,
                  //   label: reservationModel.residence.nom,
                  //   iconSize: 15,
                  //   backgroundColor: CupertinoColors.systemFill,
                  // ),
                ],
              ),
              const Gap(6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    "${reservationModel.datesReservation.length} jour${(reservationModel.datesReservation.length > 1) ? 's' : ''}",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  AutoSizeText(
                    maxLines: 1,
                    Utils.formatCurrency(
                        reservationModel.montantTotalReservation),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              Divider(
                thickness: 0.5,
                color: Colors.grey.shade300,
              ),
              SizedBox(
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ARRIVÉE',
                            style: GoogleFonts.sen(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          AutoSizeText(
                              maxLines: 1,
                              "${formatDate.format(Utils.toDateTime(reservationModel.dateDebut))} à ${reservationModel.residence.heureEntree}")
                        ],
                      ),
                    ),
                    VerticalDivider(
                      thickness: 0.5,
                      color: Colors.grey.shade300,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DÉPART',
                            style: GoogleFonts.sen(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          AutoSizeText(
                            maxLines: 1,
                            "${formatDate.format(Utils.toDateTime(reservationModel.dateFin))} avant ${reservationModel.residence.heureDepart} ",
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
