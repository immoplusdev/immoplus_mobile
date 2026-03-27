import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
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
import 'package:immoplus/app/extensions/safe_area_extensions.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
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
  List<DateTime?> markedDates = [];
  List<DateTime?> selectedDates = [];
  List<DateTime?> unselectagleDates = [];

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<DateTime> datesBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> datesList = [];
    datesList.add(startDate);
    while (startDate.isBefore(endDate)) {
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

  List<DateTime> _applyResidenceTimesToDates(List<DateTime?> dates) {
    if (dates.isEmpty) return [];

    List<DateTime> datesWithTime = [];

    TimeOfDay entryTime = Utils().parseTime(widget.residenceModel.heureEntree);
    TimeOfDay exitTime = Utils().parseTime(widget.residenceModel.heureDepart);

    for (int i = 0; i < dates.length; i++) {
      if (dates[i] == null) continue;

      DateTime currentDate = dates[i]!;

      if (i == 0) {
        datesWithTime.add(DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          entryTime.hour,
          entryTime.minute,
        ));
      } else if (i == dates.length - 1) {
        datesWithTime.add(DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          exitTime.hour,
          exitTime.minute,
        ));
      } else {
        datesWithTime.add(currentDate);
      }
    }

    return datesWithTime;
  }

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
  }

  @override
  void dispose() {
    super.dispose();
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
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.whiteBackground,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: const Text('Réservation'),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
        leadingWidth: 30,
        toolbarHeight: 50,
        actions: [
          // Badge nombre de jours
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: selectedDates.isNotEmpty
                  ? AppColors.primaryLite
                  : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.calendar_1,
                  size: 16,
                  color: selectedDates.isNotEmpty
                      ? AppColors.primary
                      : const Color(0xFF98A2B3),
                ),
                const Gap(6),
                Text(
                  selectedDates.isNotEmpty
                      ? '$totalDays jour${totalDays > 1 ? 's' : ''}'
                      : 'Aucun jour',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedDates.isNotEmpty
                        ? AppColors.primary
                        : const Color(0xFF98A2B3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info résidence
                LogmentInfo(logmentModel: widget.residenceModel),
                const Gap(16),

                // Numéro de téléphone
                _buildSectionLabel(context, 'Numéro de contact'),
                const Gap(8),
                CountryPhoneNumberInput(
                    controller: _formController.phoneNumber!),
                const Gap(4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.info_circle,
                          size: 14, color: AppColors.primary),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          "De préférence un numéro WhatsApp actif.",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppColors.primary,
                                fontSize: 11,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),

                // Calendrier
                _buildSectionLabel(context, 'Choisir vos jours de réservation'),
                const Gap(8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF2F4F7)),
                  ),
                  child: Column(
                    children: [
                      // Calendrier
                      SizedBox(
                        height: 300,
                        child: FutureBuilder(
                            future: bookingServices.getDateBooked(
                                residenceId: widget.residenceModel.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Iconsax.warning_2,
                                          size: 32,
                                          color: const Color(0xFFF04438)),
                                      const Gap(8),
                                      Text(
                                        "Erreur de chargement",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: const Color(0xFFF04438),
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              if (snapshot.hasData) {
                                final List<DateTime> bookedDates =
                                    List<DateTime>.from(
                                        snapshot.data as List<DateTime>);
                                unselectagleDates =
                                    bookedDates.map((d) => d).toList();

                                return ValueListenableBuilder(
                                    valueListenable: userDatesNotifier,
                                    builder: (context, value, child) {
                                      return CalendarDatePicker2(
                                        config: CalendarDatePicker2Config(
                                          disableModePicker: true,
                                          firstDayOfWeek: 1,
                                          calendarType:
                                              CalendarDatePicker2Type.range,
                                          centerAlignModePicker: true,
                                          customModePickerIcon:
                                              const SizedBox(),
                                          firstDate: DateTime.now(),
                                          selectedDayHighlightColor:
                                              AppColors.primary,
                                          selectedRangeHighlightColor:
                                              AppColors.primary
                                                  .withValues(alpha: 0.1),
                                          controlsTextStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600),
                                          selectableDayPredicate: (day) =>
                                              !bookedDates.any(
                                                  (b) => isSameDate(b, day)),
                                          dayBuilder: ({
                                            required date,
                                            decoration,
                                            isDisabled,
                                            isSelected,
                                            isToday,
                                            textStyle,
                                          }) {
                                            final bool isBooked = bookedDates
                                                .any((b) =>
                                                    isSameDate(b, date));
                                            if (isBooked) {
                                              return IgnorePointer(
                                                ignoring: true,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFFEF3F2),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      date.day.toString(),
                                                      style: (textStyle ??
                                                              const TextStyle())
                                                          .copyWith(
                                                        color: const Color(
                                                            0xFFF04438),
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        decorationColor:
                                                            const Color(
                                                                0xFFF04438),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return Container(
                                              decoration: decoration,
                                              child: Center(
                                                child: Text(
                                                  date.day.toString(),
                                                  style: textStyle,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        onDisplayedMonthChanged: null,
                                        value: markedDates,
                                        onValueChanged: (value) {
                                          if (value.length == 2) {
                                            final range = datesBetween(
                                                value.first, value.last);
                                            final conflict = range.any((d) =>
                                                bookedDates.any(
                                                    (b) => isSameDate(b, d)));
                                            if (conflict) {
                                              ToastUtils.showError(
                                                  description:
                                                      "La sélection contient des dates déjà réservées. La sélection est réduite au jour choisi.");
                                              _applySingleDateSelection(
                                                  value.last, context);
                                              return;
                                            }
                                          }

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

                                            List<DateTime> datesWithHours =
                                                _applyResidenceTimesToDates(
                                                    selectedDates);

                                            selectedDates.clear();
                                            selectedDates
                                                .addAll(datesWithHours);

                                            _formController.dates!.clear();

                                            for (var element
                                                in selectedDates) {
                                              _formController.addDate(
                                                  date: element!
                                                      .toIso8601String());
                                            }
                                          }
                                          log(selectedDates.toString());
                                          context
                                              .read<BookingCubit>()
                                              .estimateCost(
                                                residenceId:
                                                    widget.residenceModel.id,
                                                dateDebut:
                                                    startDateCalculated,
                                                dateFin: endDateCalculated,
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

                      // Arrivée / Départ
                      Divider(height: 1, color: const Color(0xFFF2F4F7)),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildDateInfo(
                                context,
                                icon: Iconsax.login_1,
                                label: 'ARRIVÉE',
                                value: markedDates.isNotEmpty
                                    ? formatDate.format(startDateCalculated)
                                    : null,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: const Color(0xFFF2F4F7),
                            ),
                            Expanded(
                              child: _buildDateInfo(
                                context,
                                icon: Iconsax.logout_1,
                                label: 'DÉPART',
                                value: markedDates.isNotEmpty
                                    ? formatDate.format(endDateCalculated)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),

                // Estimation de prix
                BlocConsumer<BookingCubit, BookingRequestState>(
                  builder: (context, state) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF2F4F7)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECFDF3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Iconsax.receipt_item,
                                  color: Color(0xFF12B76A),
                                  size: 20,
                                ),
                              ),
                              const Gap(12),
                              Text(
                                'Prix de la réservation',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          if (estimateCost != null) ...[
                            const Gap(16),
                            Divider(
                                height: 1,
                                color: const Color(0xFFF2F4F7)),
                            const Gap(12),
                            _buildPriceRow(
                              context,
                              label: 'Montant',
                              value: Utils.formatCurrency(
                                  estimateCost!.montant.toInt()),
                            ),
                            const Gap(8),
                            _buildPriceRow(
                              context,
                              label: 'Frais de service',
                              value: Utils.formatCurrency(
                                  estimateCost!.frais.toInt()),
                            ),
                            const Gap(12),
                            Divider(
                                height: 1,
                                color: const Color(0xFFF2F4F7)),
                            const Gap(12),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                Text(
                                  Utils.formatCurrency(
                                      estimateCost!.total.toInt()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                ),
                              ],
                            ),
                          ] else ...[
                            const Gap(12),
                            Text(
                              'Sélectionnez des dates pour voir le prix',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: const Color(0xFF98A2B3),
                                  ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                  listener: (context, state) {
                    if (state is RECEIVE_ESTIMATE_COST) {
                      setState(() {
                        estimateCost = state.estimateCost.data;
                      });
                    }
                  },
                ),
                const Gap(100),
              ],
            ),
          ),
        ),
      ),

      // Bouton Réserver
      bottomNavigationBar: Container(
        color: AppColors.whiteBackground,
        height: 90,
        margin: EdgeInsets.only(bottom: kDefaultPadding),
        padding:
            const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 20),
        child: BlocBuilder<BookingCubit, BookingRequestState>(
          builder: (context, state) => CustomLoadingButtom(
              textColor: Colors.white,
              text: 'Réserver',
              isLoading: state is LOADING_BOOKING,
              onClick: (state is INITIAL_BOOKING)
                  ? null
                  : () {
                      if (totalDays < widget.residenceModel.dureeMinSejour) {
                        ToastUtils.showError(
                            description:
                                "La durée minimale de séjour pour cette résidence est de ${widget.residenceModel.dureeMinSejour} jours");
                        return;
                      }
                      if (totalDays > widget.residenceModel.dureeMaxSejour) {
                        ToastUtils.showError(
                            description:
                                "La durée maximale de séjour pour cette résidence est de ${widget.residenceModel.dureeMaxSejour} jours");
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        if (selectedDates.isEmpty) {
                          EasyLoading.showToast(
                              "Aucun jour de réservation sélectionné",
                              toastPosition:
                                  EasyLoadingToastPosition.bottom);
                        } else {
                          AppDialog.show(
                            title: 'Confirmation',
                            description:
                                'Confirmez-vous cette demande de réservation pour $totalDays jours ?',
                            primaryButtonText: 'Confirmer',
                            secondButtonText: 'Annuler',
                            onPrimary: () {
                              if (estimateCost == null) {
                                ToastUtils.showSuccess(
                                    description:
                                        "Veuillez choisir une date");
                                return;
                              }
                              context.read<BookingCubit>().orderBooking(
                                  amount: estimateCost!.total.toInt(),
                                  body: ReservationRequestBody(
                                      residence:
                                          widget.residenceModel.id,
                                      datesReservation: selectedDates
                                          .map(
                                            (e) =>
                                                DatesReservationModel(
                                                    date: e),
                                          )
                                          .toList(),
                                      clientPhoneNumber:
                                          _formController
                                              .phoneNumber!.text));
                            },
                          );
                        }
                      }
                    },
            ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF344054),
          ),
    );
  }

  Widget _buildDateInfo(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF667085)),
              const Gap(4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF667085),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Gap(4),
          if (value != null)
            AutoSizeText(
              maxLines: 1,
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF344054),
                  ),
            )
          else
            Text(
              '-- --- ----',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF98A2B3),
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF667085),
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF344054),
              ),
        ),
      ],
    );
  }

  void _applySingleDateSelection(DateTime? date, BuildContext context) {
    if (date == null) return;

    markedDates.clear();
    markedDates.add(date);

    selectedDates.clear();
    selectedDates.addAll(markedDates);

    if (selectedDates.isNotEmpty) {
      final List<DateTime> datesWithHours =
          _applyResidenceTimesToDates(selectedDates);
      selectedDates.clear();
      selectedDates.addAll(datesWithHours);

      _formController.dates!.clear();
      for (var element in selectedDates) {
        _formController.addDate(date: element!.toIso8601String());
      }
    }

    context.read<BookingCubit>().estimateCost(
          residenceId: widget.residenceModel.id,
          dateDebut: startDateCalculated,
          dateFin: endDateCalculated,
        );

    setState(() {});
  }
}
