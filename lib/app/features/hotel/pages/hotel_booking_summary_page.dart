import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_detail_model.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_estimation_request.dart';
import 'package:immoplus/app/features/hotel/cubit/hotel_cubit.dart';
import 'package:immoplus/app/features/hotel/cubit/hotel_state.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/features/hotel/widgets/hotel_booking_card.dart';
import 'package:intl/intl.dart';

class HotelBookingSummaryPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const HotelBookingSummaryPage({super.key, required this.data});

  static const String routePath = '/hotels/:hotelId/summary';
  static const String name = 'hotel_booking_summary';

  static String route(String hotelId) => '/hotels/$hotelId/summary';

  @override
  State<HotelBookingSummaryPage> createState() =>
      _HotelBookingSummaryPageState();
}

class _HotelBookingSummaryPageState extends State<HotelBookingSummaryPage> {
  HotelDetailModel get hotel => widget.data['hotel'] as HotelDetailModel;
  RoomTypeModel get room => widget.data['room'] as RoomTypeModel;
  HotelEstimationRequest get request =>
      widget.data['request'] as HotelEstimationRequest;

  @override
  Widget build(BuildContext context) {
    final checkIn = DateTime.parse(request.checkInDate);
    final checkOut = DateTime.parse(request.checkOutDate);
    final displayDates = checkIn.month == checkOut.month
        ? "${checkIn.day} ➔ ${checkOut.day} ${DateFormat('MMMM yyyy', 'fr_FR').format(checkOut)}"
        : "${checkIn.day} ${DateFormat('MMM', 'fr_FR').format(checkIn)} ➔ ${checkOut.day} ${DateFormat('MMM yyyy', 'fr_FR').format(checkOut)}";

    return BlocProvider<HotelCubit>(
      create: (context) => getIt<HotelCubit>()
        ..getEstimation(hotelId: hotel.hotelId, request: request),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF7F8FA),
          elevation: 0,
          leadingWidth: 56,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon:
                    const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                onPressed: () => context.pop(),
              ),
            ),
          ),
        ),
        body: BlocBuilder<HotelCubit, HotelState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              estimationLoaded: (estimation) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: HotelBookingCard(
                  title: "Récapitulatif",
                  children: [
                    // ── SÉJOUR Card ──
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6F8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "SÉJOUR",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                          const Gap(8),
                          Text(
                            displayDates,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Gap(4),
                          Text(
                            "${estimation.roomTypeName} • ${estimation.adults} adulte${estimation.adults > 1 ? 's' : ''}",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ],
                      ),
                    ),

                    const Gap(24),

                    // ── Pricing Detail Lines ──
                    _buildPriceRow(
                      "${CurrencyFormatter().format(estimation.tarification.prixParNuit.toString())} FCFA × ${estimation.nightCount} nuits",
                      "${CurrencyFormatter().format(estimation.tarification.prixChambre.toString())}",
                    ),
                    const Gap(12),
                    _buildPriceRow(
                      "Petit-déjeuner inclus",
                      "${CurrencyFormatter().format(estimation.tarification.petitDejeuner.prixTotal.toString())}",
                    ),
                    const Gap(12),
                    _buildPriceRow(
                      "Taxe de séjour (${estimation.nightCount} × ${CurrencyFormatter().format(estimation.tarification.taxeSejourPerNuit.prixParNuit.toString())})",
                      "${CurrencyFormatter().format(estimation.tarification.taxeSejourPerNuit.prixTotal.toString())}",
                    ),
                    const Gap(16),
                    const Divider(height: 1, thickness: 0.5),
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total séjour",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${CurrencyFormatter().format(estimation.tarification.prixTotal.toString())} FCFA",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const Gap(24),

                    // ── ACOMPTE À LA RÉSERVATION Card ──
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2744DE).withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFF2744DE).withOpacity(0.15)),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "ACOMPTE À LA RÉSERVATION",
                                style: TextStyle(
                                    color: Color(0xFF2744DE),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${estimation.acompte.pourcentage}%",
                                style: const TextStyle(
                                    color: Color(0xFF2744DE),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Gap(12),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "${CurrencyFormatter().format(estimation.acompte.montant.toString())}",
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF5D0014)),
                                ),
                                const TextSpan(
                                  text: " FCFA",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF5D0014)),
                                ),
                              ],
                            ),
                          ),
                          const Gap(4),
                          const Text(
                            "À payez maintenant",
                            style: TextStyle(
                                color: Color(0xFF2744DE),
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          const Gap(16),
                          Divider(
                              color: const Color(0xFF2744DE).withOpacity(0.15),
                              height: 1,
                              thickness: 0.5),
                          const Gap(16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Solde au check-in",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 14),
                              ),
                              Text(
                                "${CurrencyFormatter().format(estimation.montantRestant.toString())} FCFA",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Gap(24),

                    // ── POLITIQUE D'ANNULATION ──
                    const Text(
                      "POLITIQUE D'ANNULATION",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    const Gap(8),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2744DE).withOpacity(0.06),
                        border: Border.all(
                            color: const Color(0xFF2744DE).withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: const Text(
                        "Annulation gratuite",
                        style: TextStyle(
                            color: Color(0xFF2744DE),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),

                    const Gap(40),

                    // Final CTA Button
                    CustomButtom(
                      text: "Réserver",
                      borderRadius: BorderRadius.circular(26),
                      onClick: () {
                        // TODO Finalize booking payment
                      },
                    ),
                  ],
                ),
              ),
              orElse: () => const Center(
                  child: Text("Une erreur est survenue lors de l'estimation.")),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
        Text(amount,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }
}
