import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/reservations/dates_reservation_model.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_request_body.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/features/booking/data/estimate_cost_model.dart';
import 'package:immoplus/app/features/booking/logic/booking_cubit.dart';
import 'package:immoplus/app/features/booking/logic/booking_request_state.dart';
import 'package:immoplus/app/features/booking/logic/booking_services.dart';
import 'package:immoplus/app/features/booking/widgets/logment_info.dart';
import 'package:immoplus/app/modules/country_phone_number/country_phone_number.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:intl/intl.dart';

class BookingFormularAction extends StatefulWidget {
  const BookingFormularAction({super.key, required this.residenceModel});
  final ResidenceModel residenceModel;
  @override
  State<BookingFormularAction> createState() => _BookingFormularActionState();
}

class _BookingFormularActionState extends State<BookingFormularAction> {
  final sessionManager = getIt<SessionManager>();
  final dio = getIt<Dio>();

  late FormController _formController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EstimateCostData? estimateCost;

  String time = '';
  List<DateTime?> markedDates = [
    //   DateTime(2023, 08, 24, 15, 30)
  ];
  List<DateTime?> selectedDates = [];
  List<DateTime?> unselectagleDates = [];
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<DateTime> datesBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> datesList = [];
    // Ajouter la date de début à la liste
    datesList.add(startDate);
    // Tant que la date de début n'est pas égale à la date de fin
    while (startDate.isBefore(endDate)) {
      // Ajouter un jour à la date de début et l'ajouter à la liste
      startDate = startDate.add(const Duration(days: 1));
      datesList.add(startDate);
    }
    return datesList;
  }

  DateFormat formatDate = DateFormat('d MMMM yyyy - HH:mm');
  List<DateTime> userDates = [];
  ValueNotifier<bool> testNotifier = ValueNotifier<bool>(false);
  ValueNotifier<List<DateTime>> userDatesNotifier =
      ValueNotifier<List<DateTime>>([]);
// Fonction personnalisée pour vérifier la présence d'une date dans la liste en fonction du jour et du mois
  bool _containsDateInList(DateTime searchDate, List<DateTime?> list) {
    for (DateTime? date in list) {
      if (date != null) {
        if (date.day == searchDate.day && date.month == searchDate.month) {
          return true;
        }
      }
    }
    return false;
  }

  // int calculBookingprice({required int price, required int nbDay}) {
  //   return ((price * nbDay)).round();
  //   //return ((price * nbDay) * 0.1).round();
  // }

  // Future<bool> getDateBooked() async {
  //   Response rp = await dio.get(
  //       "${RequestPath.baseUrl}/reservations/data/residence/occupied-dates/${widget.residenceModel.id}");
  //   List data = rp.data['data']['dates'];
  //   inspect(data);
  //   for (var e in data) {
  //     unselectagleDates.add(DateTime.parse(e['date']));
  //   }

  //   return true;
  // }

  /// Applique l'heure d'entrée à la date de début et l'heure de départ à la date de fin
  List<DateTime> _applyResidenceTimesToDates(List<DateTime?> dates) {
    if (dates.isEmpty) return [];

    List<DateTime> datesWithTime = [];

    // Parser les heures depuis le modèle de résidence
    TimeOfDay entryTime = Utils().parseTime(widget.residenceModel.heureEntree);
    TimeOfDay exitTime = Utils().parseTime(widget.residenceModel.heureDepart);

    for (int i = 0; i < dates.length; i++) {
      if (dates[i] == null) continue;

      DateTime currentDate = dates[i]!;

      // Première date = date d'entrée avec heureEntree
      if (i == 0) {
        datesWithTime.add(DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          entryTime.hour,
          entryTime.minute,
        ));
      }
      // Dernière date = date de sortie avec heureDepart
      else if (i == dates.length - 1) {
        datesWithTime.add(DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          exitTime.hour,
          exitTime.minute,
        ));
      }
      // Dates intermédiaires = garder l'heure par défaut (00:00)
      else {
        datesWithTime.add(currentDate);
      }
    }

    return datesWithTime;
  }

  /// Fusionne une date, une heure et ajoute x jours
  /// Exemple: (2025-10-23, 14:30, 2) -> 2025-10-25 14:30:00
  static DateTime mergeDateTimeAndAddDays(
    DateTime date,
    TimeOfDay time,
    int daysToAdd,
  ) {
    final merged = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    return merged.add(Duration(days: daysToAdd));
  }

  Map<DateTime?, List<dynamic>> _generateEvents(Set<DateTime> days) {
    Map<DateTime?, List<dynamic>> events = {};

    for (var date in markedDates) {
      events[date] = ['Event'];
    }

    return events;
  }

  final bookingServices = getIt<BookingServices>();
  @override
  void initState() {
    _formController = FormController(
      logmentID: widget.residenceModel.id,
      firstName:
          TextEditingController(text: sessionManager.currentUser!.firstName),
      lastName:
          TextEditingController(text: sessionManager.currentUser!.lastName),
      phoneNumber:
          TextEditingController(text: sessionManager.currentUser!.phoneNumber),
      email: TextEditingController(text: sessionManager.currentUser!.email),
      payementType: TextEditingController(text: 'cash'),
      address2: TextEditingController(text: ''),
      address: TextEditingController(text: ''),
      dates: [
        '2024-02-01 18:12:15.536290',
      ],
    );

    super.initState();
    // time = Constantes.configApp!.categoryPaymentTypes
    //     .firstWhere((GalleryGroup e) =>
    //         e.value == ProductState.currentProduct!.paymentType)
    //     .text;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _controllers.forEach((key, value) {
    //   value.dispose();
    // });
  }

  DateTime get startDateCalculated => mergeDateTimeAndAddDays(
      markedDates.first!,
      Utils().parseTime(widget.residenceModel.heureEntree),
      0);

  DateTime get endDateCalculated => mergeDateTimeAndAddDays(markedDates.last!,
      Utils().parseTime(widget.residenceModel.heureDepart), 1);

  int get totalDays => selectedDates.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      appBar: AppBar(
        backgroundColor: AppColors.scafold,
        centerTitle: false,
        title: const Text('Réservation'),
        leadingWidth: 30,
        toolbarHeight: 40,
        actions: [
          Container(
            //color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedDates.isNotEmpty
                      ? (totalDays == 1)
                          ? '$totalDays jour sélectionné'
                          : '$totalDays jours sélectionnés'
                      : "aucun jours sélectionnés",
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary),
                ),
              ],
            ),
          ),
          const Gap(10),
        ],
      ),
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TODO
                LogmentInfo(
                  logmentModel: widget.residenceModel,
                ),

                const Gap(8),
                // Text("Vos informations"),
                // PersonalInfoEditor(
                //   formController: _formController,
                // ),
                CountryPhoneNumberInput(
                    controller: _formController.phoneNumber!),

                Text(
                  "Numéro de téléphone sur lequel vous préférez être contacté, de préférence un numéro WhatsApp actif.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inder(
                    fontSize: 11,
                    color: AppColors.primary,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Choisir vos jours de réservatoin:',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 300,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    border: Border.all(color: Colors.grey),
                  ),
                  //color: Colors.amber,
                  child: FutureBuilder(
                      future: bookingServices.getDateBooked(
                          residenceId: widget.residenceModel.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        if (snapshot.hasData) {
                          return ValueListenableBuilder(
                              valueListenable: userDatesNotifier,
                              builder: (context, value, child) {
                                log("Rebuild");
                                return CalendarDatePicker2(
                                  config: CalendarDatePicker2Config(
                                    disableModePicker: true,
                                    firstDayOfWeek: 1,
                                    calendarType: CalendarDatePicker2Type.range,
                                    centerAlignModePicker: true,
                                    customModePickerIcon: const SizedBox(),
                                    firstDate: DateTime.now(),
                                    selectableDayPredicate: (day) =>
                                        !unselectagleDates.any((element) =>
                                            isSameDate(element!, day)),
                                  ),
                                  onDisplayedMonthChanged: null,
                                  value: markedDates,
                                  onValueChanged: (value) {
                                    markedDates.clear();
                                    markedDates.addAll(value);
                                    if (markedDates.length >= 2) {
                                      selectedDates.clear();
                                      selectedDates.addAll(datesBetween(
                                          markedDates.first!,
                                          markedDates.last!));
                                    } else if (markedDates.length == 1) {
                                      selectedDates.clear();
                                      selectedDates.addAll(markedDates);
                                    }
                                    if (selectedDates.isNotEmpty) {
                                      inspect(markedDates);

                                      // ✨ Appliquer les heures de résidence à selectedDates
                                      List<DateTime> datesWithHours =
                                          _applyResidenceTimesToDates(
                                              selectedDates);

                                      // ✨ Mettre à jour selectedDates avec les nouvelles dates (avec heures)
                                      selectedDates.clear();
                                      selectedDates.addAll(datesWithHours);

                                      _formController.dates!.clear();

                                      for (var element in selectedDates) {
                                        _formController.addDate(
                                            date: element!.toIso8601String());
                                      }
                                    }
                                    log(selectedDates.toString());
                                    // context.read<BookingCubit>().estimatePrice(
                                    //     residenceId: widget.residenceModel.id,
                                    //     dates: selectedDates
                                    //         .map((e) => e!)
                                    //         .toList());
                                    context.read<BookingCubit>().estimateCost(
                                          residenceId: widget.residenceModel.id,
                                          dateDebut: startDateCalculated,
                                          dateFin: endDateCalculated,
                                          // paymentMethod: 'moov',
                                        );
                                    setState(() {});
                                  },
                                );
                              });
                        }
                        return const Center(
                            child: CupertinoActivityIndicator());
                      }),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    border: Border(
                        top: BorderSide.none,
                        left: BorderSide(
                          color: Colors.grey,
                        ),
                        right: BorderSide(color: Colors.grey),
                        bottom: BorderSide(color: Colors.grey)),
                  ),
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: ListTile(
                        dense: true,
                        title: const Text('ARRIVÉE'),
                        titleTextStyle: GoogleFonts.inter(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        subtitle: (markedDates.isNotEmpty)
                            ? Text(formatDate.format(startDateCalculated))
                            : null,
                      )),
                      const VerticalDivider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      Flexible(
                          child: ListTile(
                        dense: true,
                        title: const Text('DÉPART'),
                        titleTextStyle: GoogleFonts.inter(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        subtitle: (markedDates.isNotEmpty)
                            ? AutoSizeText(
                                formatDate.format(endDateCalculated),
                                maxLines: 1,
                              )
                            : null,
                      )),
                    ],
                  ),
                ),
                const Gap(10),
                BlocConsumer<BookingCubit, BookingRequestState>(
                  builder: (context, state) {
                    return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          enabled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: const Color.fromRGBO(255, 255, 255, 1),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(5),
                              if (estimateCost != null)
                                Text(
                                  "Montant ${Utils.formatCurrency(
                                    estimateCost!.montant.toInt(),
                                  )} + Frais ${Utils.formatCurrency(
                                    estimateCost!.frais.toInt(),
                                  )} ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600),
                                ),
                              Gap(12),
                              Text(
                                estimateCost == null
                                    ? "••••••••"
                                    : "Montant Total : ${Utils.formatCurrency(
                                        estimateCost!.total.toInt(),
                                      )}",
                              ),
                            ],
                          ),
                          title: const Text('Prix de la réservation'),
                          subtitleTextStyle: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: AppColors.primary),
                          horizontalTitleGap: 2,
                          trailing: const CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                FontAwesomeIcons.moneyBill,
                                color: Colors.green,
                              )),
                        ));
                  },
                  listener: (context, state) {
                    if (state is RECEIVE_ESTIMATE_COST) {
                      setState(() {
                        estimateCost = state.estimateCost.data;
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        color: AppColors.scafold,
        height: 90,
        padding:
            const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 20),
        child: BlocBuilder<BookingCubit, BookingRequestState>(
          builder: (context, state) => CustomLoadingButtom(
            textColor: Colors.white,
            text: 'RESERVER',
            isLoading: state is LOADING_BOOKING,
            onClick: (state is INITIAL_BOOKING)
                ? null
                : () {
                    if (totalDays < widget.residenceModel.dureeMinSejour) {
                      ToastUtils.showError(
                          description:
                              "La durée minimale de séjour pour cette residence est de  ${widget.residenceModel.dureeMinSejour} jours");
                      return;
                    }
                    if (totalDays > widget.residenceModel.dureeMaxSejour) {
                      ToastUtils.showError(
                          description:
                              "La durée maximale de séjour pour cette residence est de  ${widget.residenceModel.dureeMinSejour} jours");
                      return;
                    }
                    // FormUtils.showPayment(context: context);
                    // ContactUtils().showDialog(context: context);
                    if (_formKey.currentState!.validate()) {
                      if (selectedDates.isEmpty) {
                        EasyLoading.showToast(
                            "Aucun jour de réservation sélectionné",
                            toastPosition: EasyLoadingToastPosition.bottom);
                      } else {
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoAlertDialog(
                            //title: const Text('Alert'),
                            content: Text(
                                'Confirmez-vous cette demande de réservation pour $totalDays jours?'),
                            actions: <CupertinoDialogAction>[
                              CupertinoDialogAction(
                                isDefaultAction: false,
                                isDestructiveAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Annuer'),
                              ),
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                isDestructiveAction: false,
                                onPressed: () {
                                  if (estimateCost == null) {
                                    ToastUtils.showSuccess(
                                        description:
                                            "Veuillez choisir une date");
                                    return;
                                  }
                                  context.read<BookingCubit>().orderBooking(
                                      amount: estimateCost!.total.toInt(),
                                      body: ReservationRequestBody(
                                          residence: widget.residenceModel.id,
                                          datesReservation: selectedDates
                                              .map(
                                                (e) => DatesReservationModel(
                                                    date: e),
                                              )
                                              .toList(),
                                          clientPhoneNumber: _formController
                                              .phoneNumber!.text));
                                  context.pop();
                                },
                                child: const Text('Confirmer'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
          ),
        ),
      ),

      // floatingActionButton: (kDebugMode)
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           log(selectedDates.toString());
      //         },
      //       )
      //     : null,
    );
  }
}
