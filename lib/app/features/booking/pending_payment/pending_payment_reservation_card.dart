import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:intl/intl.dart';

class PendingPaymentReservationCard extends StatelessWidget {
  PendingPaymentReservationCard({super.key, required this.reservationModel});
  final ReservationModel reservationModel;
  final DateFormat formatDate = DateFormat('d MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge EN ATTENTE DE PAIEMENT
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'EN ATTENTE DE PAIEMENT',
                style: GoogleFonts.sen(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Montant
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

            Divider(thickness: 0.5, color: Colors.grey.shade300),

            // Dates
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
                          'ARRIVEE',
                          style: GoogleFonts.sen(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        AutoSizeText(
                          maxLines: 1,
                          "${formatDate.format(Utils.toDateTime(reservationModel.dateDebut))} a ${reservationModel.residence.heureEntree}",
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(thickness: 0.5, color: Colors.grey.shade300),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DEPART',
                          style: GoogleFonts.sen(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        AutoSizeText(
                          maxLines: 1,
                          "${formatDate.format(Utils.toDateTime(reservationModel.dateFin))} avant ${reservationModel.residence.heureDepart}",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Bouton Payer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed(
                    OperatorsSelectorPage.name,
                    extra: PaymentPageAdapter(
                      itemId: reservationModel.id,
                      collection: ProductType.reservations.name,
                      amount:
                          reservationModel.montantTotalReservation.toInt(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text('Payer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
