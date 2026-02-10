// ignore_for_file: prefer_is_empty

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_response.dart';
import 'package:immoplus/app/features/authentification/loading_page.dart';
import 'package:immoplus/app/features/booking/logic/booking_cubit.dart';
import 'package:immoplus/app/features/booking/logic/booking_request_state.dart';
import 'package:immoplus/app/features/booking/widgets/booking_payment_status.dart';
import 'package:immoplus/app/features/booking/widgets/logment_info.dart';
import 'package:immoplus/app/features/booking/widgets/planing_booking_card_detail.dart';
import 'package:immoplus/app/features/booking/widgets/reservation_status_section.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/booking_utils.dart';
import 'package:immoplus/app/utils/contact_utils.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:map_launcher/map_launcher.dart';

class BookingDetailPage extends StatefulWidget {
  const BookingDetailPage({super.key, required this.id});
  static String name = 'BOOKING';
  final String id;
  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().getBooking(id: widget.id);
  }

  /// verifier si la demande de visite est payé
  bool hasPaid(ReservationResponse reservationResponse) {
    return reservationResponse.data.statusFacture.toString() ==
        PaymentStatus.paye.name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingRequestState>(
      builder: (context, state) {
        if (state is RECEIVE_BOOKING) {
          return Scaffold(
            backgroundColor: AppColors.scafold,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(appPadding),
                child: CustomScrollView(
                  slivers: [
                    CupertinoSliverRefreshControl(
                      onRefresh: () async {
                        this
                            .context
                            .read<BookingCubit>()
                            .getBooking(id: widget.id);
                      },
                    ),

                    SliverToBoxAdapter(
                        child: LogmentInfo(
                            logmentModel:
                                state.reservationResponse.data.residence)),
                    const SliverGap(10),
                    SliverToBoxAdapter(
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text('Identifiant de la réservation:'),
                        subtitle:
                            SelectableText(state.reservationResponse.data.id),
                        dense: true,
                        trailing: IconButton(
                          color: AppColors.primary,
                          icon: const Icon(FontAwesomeIcons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                    text: state.reservationResponse.data.id))
                                .then((value) {
                              //Vibrate.feedback(FeedbackType.impact);
                              EasyLoading.showToast('Identifiant copié');
                            }).catchError((err) {
                              EasyLoading.showToast(err.toString());
                            });
                          },
                        ),
                        titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                        subtitleTextStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.purple),
                      ),
                    ),
                    // SliverToBoxAdapter(
                    //     child: Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   child: ElevatedButton(
                    //       onPressed: () {
                    //         inspect(state.data.logement);
                    //       },
                    //       child: Text(
                    //           'Teste')), // LogmentInfo(logmentModel: state.data.logement!),
                    // )),
                    const SliverToBoxAdapter(child: Divider()),

                    SliverToBoxAdapter(
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        dense: true,
                        title: Text(
                          "Total pour ${state.reservationResponse.data.datesReservation.length} ${(state.reservationResponse.data.datesReservation.length >= 1) ? 'Jour' : 'Jours'}",
                        ),
                        trailing: Text(
                          Utils.formatCurrency(
                              state.reservationResponse.data.montantPaye),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.green),
                        ),
                      ),
                    ),

                    SliverGap(10),

                    SliverToBoxAdapter(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: (BookingUtils.getBookingStatus(
                                      state.reservationResponse.data
                                          .datesReservation.first.date!,
                                      state.reservationResponse.data
                                          .datesReservation.last.date!) ==
                                  BookingStatus.ongoing)
                              ? Colors.green.shade400
                              : Colors.blueGrey,
                          child: Icon(
                              (BookingUtils.getBookingStatus(
                                          state.reservationResponse.data
                                              .datesReservation.first.date!,
                                          state.reservationResponse.data
                                              .datesReservation.last.date!) ==
                                      BookingStatus.ongoing)
                                  ? FontAwesomeIcons.personWalkingLuggage
                                  : FontAwesomeIcons.calendarCheck,
                              color: Colors.white),
                        ),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        dense: true,
                        title: Text(
                          BookingUtils.getStatusText(
                              startDate: state.reservationResponse.data
                                  .datesReservation.first.date!,
                              endDate: state.reservationResponse.data
                                  .datesReservation.last.date!),
                        ),
                      ),
                    ),
                    SliverGap(10),
                    SliverToBoxAdapter(
                      // color: Colors.white,
                      // borderRadius: BorderRadius.circular(20),
                      child: ReservationStatusSection(
                          status: state
                                  .reservationResponse.data.statusReservation ??
                              ''),
                    ),
                    SliverGap(10),
                    SliverToBoxAdapter(
                        //  color: Colors.white,
                        //   borderRadius: BorderRadius.circular(20),
                        child: BookingPaymentStatus(
                            reservationModel: state.reservationResponse.data)),
                    const SliverGap(10),
                    SliverToBoxAdapter(
                        child: PlaningBookingCardDetail(
                      reservationModel: state.reservationResponse.data,
                    )),
                    SliverGap(10),

                    if (hasPaid(state.reservationResponse))
                      // Proprietaire
                      SliverToBoxAdapter(
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(20),
                          child: ListTile(
                            tileColor: Colors.white,
                            enabled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            leading: const CircleAvatar(
                              //backgroundColor: Colors.white,
                              child: Icon(
                                FontAwesomeIcons.userTie,
                                //color: Colors.green,
                              ),
                            ),
                            title: const Text("Propriétaire"),
                            subtitle: Text(state.reservationResponse.data
                                .proprietaire.phoneNumber
                                .split('-')
                                .last
                                .toString()),
                            titleTextStyle:
                                Theme.of(context).textTheme.bodyMedium,
                            trailing: Icon(
                              FontAwesomeIcons.phoneVolume,
                              color: AppColors.primary,
                            ),
                            subtitleTextStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: AppColors.primary),
                            onTap: () async {
                              final phone = state.reservationResponse.data
                                  .proprietaire.phoneNumber
                                  .split('-');
                              Utils.makePhoneCall(phone.last);
                            },
                          ),
                        ),
                      ),
                    SliverGap(10),

                    if (hasPaid(state.reservationResponse))
                      // code reservation
                      _customTile(
                        icon: Icons.label_rounded,
                        trailingIcon: Icons.content_copy_rounded,
                        title:
                            "CODE RÉSERVATION : ${state.reservationResponse.data.codeReservation}",
                        onTap: () {
                          Utils.copyToClipboard(
                              state.reservationResponse.data.codeReservation);
                        },
                      ),
                    SliverGap(10),

                    // voir l'itinéraire
                    SliverToBoxAdapter(
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(20),
                        child: ListTile(
                          tileColor: Colors.white,
                          enabled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: Icon(
                            CupertinoIcons.location,
                            color: AppColors.primary,
                          ),
                          title: const Text("Voir l'itinéraire"),
                          titleTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.primary),
                          trailing: Icon(
                            CupertinoIcons.chevron_right_circle_fill,
                            color: AppColors.primary,
                          ),
                          onTap: () async {
                            if (await MapLauncher.isMapAvailable(
                                    MapType.google) ??
                                false) {
                              MapLauncher.showDirections(
                                destinationTitle: state
                                    .reservationResponse.data.residence.nom,
                                destination: Coords(
                                  state.reservationResponse.data.residence
                                      .position.coordinates![1],
                                  state.reservationResponse.data.residence
                                      .position.coordinates![0],
                                ),
                                directionsMode: DirectionsMode.driving,
                                mapType: MapType.google,
                              );
                            } else {
                              final availableMaps =
                                  await MapLauncher.installedMaps;
                              print(availableMaps);
                              await availableMaps.first.showDirections(
                                destinationTitle: state
                                    .reservationResponse.data.residence.nom,
                                destination: Coords(
                                  state.reservationResponse.data.residence
                                      .position.coordinates![1],
                                  state.reservationResponse.data.residence
                                      .position.coordinates![0],
                                ),
                                directionsMode: DirectionsMode.driving,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SliverGap(10),
                    // Contactez nous
                    SliverToBoxAdapter(
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(20),
                        child: ListTile(
                          tileColor: Colors.white,
                          enabled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: Icon(
                            FontAwesomeIcons.headset,
                            color: AppColors.primary,
                          ),
                          title: const Text("Support client"),
                          titleTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.primary),
                          trailing: Icon(
                            CupertinoIcons.chevron_right_circle_fill,
                            color: AppColors.primary,
                          ),
                          onTap: () async {
                            ContactUtils.showContact(id: widget.id);
                          },
                        ),
                      ),
                    ),

                    SliverGap(50)
                  ],
                ),
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding)
                  .copyWith(bottom: 20),
              child: Visibility(
                visible: state.reservationResponse.data.statusFacture ==
                    PaymentStatus.non_paye.name,
                child: ListTile(
                  tileColor: Colors.red.shade300,
                  onTap: () {
                    context.pushNamed(
                      OperatorsSelectorPage.name,
                      extra: PaymentPageAdapter(
                          itemId: state.reservationResponse.data.id,
                          collection: ProductType.reservations.name,
                          amount: state.reservationResponse.data.montantPaye
                              .toInt()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 15,
                    child: Icon(
                      FontAwesomeIcons.coins,
                    ),
                  ),
                  horizontalTitleGap: 3,
                  dense: true,
                  title: Text(
                      'Payer maintenant  ${state.reservationResponse.data.montantPaye} Fcfa'),
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white),
                  trailing: const Icon(
                    CupertinoIcons.chevron_right_circle_fill,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        } else if (state is Error_BOOKINGS) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.remove_circle,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 250,
                    child: Text(
                      "Vous n'avez pas accès à cet élément ou aucun élément correspondant",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Gap(50),
                  SizedBox(
                    width: 300,
                    child: ListTile(
                      onTap: () {
                        //context.goNamed(BookingPage.name);
                      },
                      horizontalTitleGap: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      tileColor: AppColors.primaryLite,
                      leading:
                          const Icon(CupertinoIcons.chevron_left_circle_fill),
                      title: const Text("Retour a la page d'historique"),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return const LoadingPage();
      },
    );
  }

  Widget _customTile(
      {IconData? icon,
      required String title,
      IconData? trailingIcon,
      VoidCallback? onTap}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(20),
          child: ListTile(
            tileColor: Colors.white,
            enabled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            leading: Icon(
              icon,
              color: AppColors.primary,
            ),
            title: Text(title),
            titleTextStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: AppColors.primary, fontSize: 15),
            trailing: Icon(
              trailingIcon,
              color: AppColors.primary,
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
