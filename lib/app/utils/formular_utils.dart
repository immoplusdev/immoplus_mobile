import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/utils/request_path.dart';

class FormUtils {
  static void showAlertConfirmDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('Proceed with destructive action?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  static bool isValidEmail(String? email) {
    if (email == null || email.trim().isEmpty) return false;
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // Email désormais optionnel côté backend : on ne bloque plus sur l'absence
  // de valeur, on vérifie juste le format si l'utilisateur en saisit une.
  static String? emailValidator({String? email}) {
    if (email == null || email.isEmpty) {
      return null;
    } else if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      caseSensitive: false,
      multiLine: false,
    ).hasMatch(email)) {
      return 'Adresse non valide';
    }
    return null;
  }

  // Mot de passe désormais optionnel côté backend : idem, on ne vérifie le
  // format que si une valeur est saisie.
  static String? passwordValidator({String? password}) {
    if (password == null || password.isEmpty) {
      return null;
    } else if (!RegExp(r'^.{4,}$').hasMatch(password)) {
      return 'Mot de passe trop court';
    }
    return null;
  }

  static String? fieldValidator({String? value}) {
    if (value == null || value.isEmpty) {
      return 'Veuillez remplir ce champ';
    }
    return null;
  }

  static String? internationalNumberValidator({String? number}) {
    if (number == null ||
        number.isEmpty ||
        number.replaceAll(" ", "").toString().isEmpty) {
      return 'veillez entrer votre numéro';
    }

    return null;
  }

  static String? numberValidator({String? number}) {
    if (number == null || number.isEmpty || number.toString().isEmpty) {
      return 'veillez entrer votre numéro';
    }
    final RegExp regex = RegExp(r'^(07|01|05)[0-9]{8}$');
    if (!regex.hasMatch(number.replaceAll(" ", ""))) {
      print(number.replaceAll(" ", ""));
      return 'Numéro de téléphone ivoirien invalide';
    }

    return null;
  }

  static String getPeriod({required String value}) =>
      switch (value.toLowerCase()) {
        'monthly' => ' par mois',
        'day' => ' par nuit',
        'daily' => ' par nuit',
        'year' => ' par année',
        _ => '',
      };
  static final Dio _dio = Dio();
  static final List<DateTime> markedDates = [];
  static Future<bool> getDateBooked({required String id}) async {
    Response rp = await _dio.get(
        "${RequestPath.baseUrl}/reservations/data/residence/occupied-dates/$id");

    List data = rp.data['data']['dates'];
    inspect(data);
    for (var e in data) {
      markedDates.add(DateTime.parse(e['date']));
    }

    return true;
  }

  static avaibilityCalendar(
      {required BuildContext context, required String id}) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Jours disponible'),
            ),
            body: FutureBuilder(
                future: getDateBooked(id: id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.hasData) {
                    return CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        disableModePicker: true,
                        firstDayOfWeek: 1,
                        calendarType: CalendarDatePicker2Type.multi,
                        selectedDayTextStyle: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),

                        selectedDayHighlightColor: CupertinoColors.systemFill,
                        centerAlignModePicker: true,
                        customModePickerIcon: const SizedBox(),
                        firstDate: DateTime.now(),
                        selectableDayPredicate: (day) {
                          print(day);
                          return false;
                        },

                        dayBuilder: (
                                {required date,
                                decoration,
                                isDisabled,
                                isSelected,
                                isToday,
                                textStyle}) =>
                            IgnorePointer(
                          ignoring: true,
                          child: CircleAvatar(
                            backgroundColor: isSelected!
                                ? CupertinoColors.systemRed.color
                                    .withOpacity(0.3)
                                : Colors.transparent,
                            child: Text(
                              date.day.toString(),
                              style: GoogleFonts.inder(
                                color: (isSelected || isDisabled!)
                                    ? CupertinoColors.systemGrey
                                    : Colors.black,
                                decoration: isSelected
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                        //   dayBuilder: _yourDayBuilder,
                        //   yearBuilder: _yourYearBuilder,
                      ),
                      onDisplayedMonthChanged: null,
                      value: markedDates,
                      onValueChanged: (value) {
                        log(value.toString(), name: 'VALUE');
                      },
                    );
                  }
                  return const Center(child: CupertinoActivityIndicator());
                }),
          ),
        ),
      ),
    );
  }
}
