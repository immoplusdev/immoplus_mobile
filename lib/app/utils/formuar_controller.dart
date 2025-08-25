import 'package:flutter/cupertino.dart';

class FormController {
  int? productId;
  String? logmentID;
  TextEditingController? firstName;

  TextEditingController? lastName;
  TextEditingController? email;
  TextEditingController? phoneNumber;
  TextEditingController? password;
  TextEditingController? newPassword;
  TextEditingController? cityName;
  TextEditingController? stateName;
  TextEditingController? startWishedDate;
  TextEditingController? endWishedDate;
  TextEditingController? coupon;
  TextEditingController? payementType;
  TextEditingController? note;
  TextEditingController? placeLoading;
  TextEditingController? placeUnloading;
  TextEditingController? address;
  TextEditingController? address2;
  TextEditingController? paymentType;
  TextEditingController? passwordConfirm;
  String? serviceOption;
  List<String>? dates;

  int? city;
  int? state;
  set setServiceOption(String service) {
    serviceOption = service;
  }

  FormController({
    this.productId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.password,
    this.newPassword,
    this.cityName,
    this.coupon,
    this.endWishedDate,
    this.startWishedDate,
    this.payementType,
    this.note,
    this.placeLoading,
    this.placeUnloading,
    this.address,
    this.address2,
    this.serviceOption,
    this.city = 1,
    this.state = 0,
    this.stateName,
    this.dates,
    this.logmentID,
    this.passwordConfirm,
  });
  set setCityCode(int cit) => city = cit;
  set setStateCode(int st) => state = st;
  addDate({required String date}) {
    dates!.add(date);
  }

  Map<String, dynamic> toJsonForOrder() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['service_option'] = serviceOption;
    data['note'] = (note != null) ? note!.text : '';
    data['customer_last_name'] = (lastName != null) ? lastName!.text : '';
    data['customer_first_name'] = (firstName != null) ? firstName!.text : '';
    data['first_name'] = (firstName != null) ? firstName!.text : '';
    data['last_name'] = (lastName != null) ? lastName!.text : '';
    data['email'] = (email != null) ? email!.text : '';
    data['customer_phone_number'] =
        (phoneNumber != null) ? phoneNumber!.text : '';
    data['phone_number'] = (phoneNumber != null) ? phoneNumber!.text : '';
    //data['password'] = (password != null) ? this.password!.text : '';
    data['customer_email'] = (email != null) ? email!.text : '';
    data['username'] = (email != null) ? email!.text : '';
    data['customer_country_id'] = 54;
    data['customer_state_id'] = state;
    data['customer_city_id'] = city;
    data['customer_address'] = (address != null) ? address!.text : '';
    data['customer_address_2'] = (address2 != null) ? address2!.text : '';
    data['payment_type'] = (payementType != null) ? payementType!.text : '';
    data['password'] = (password != null) ? password!.text : '';
    data['newPassword'] = (newPassword != null) ? newPassword!.text : '';
    data['city'] = city;
    data['dates'] = dates;
    data['visit_type'] = serviceOption ?? 'normal';
    data['type_visite'] = serviceOption ?? 'normal';
    data['logement'] = logmentID ?? ''; //dates_reservation
    data['notes'] = 'note';
    data['service_dates'] = (dates != null)
        ? dates!
            .map((e) => {
                  "date": e,
                })
            .toList()
        : [];
    data['dates_reservation'] = (dates != null)
        ? dates!
            .map((e) => {
                  "date": e,
                })
            .toList()
        : [];
    data["service_location_1"] = {
      "type": "Point",
      "coordinates": [
        -3.996107,
        5.344332,
      ]
    };
    data["service_location_2"] = {
      "type": "Point",
      "coordinates": [
        -4.009932,
        5.352657,
      ]
    };

    data["service_metadata"] = {
      "customer_first_name": (firstName != null) ? firstName!.text : '',
      "customer_last_name": (lastName != null) ? lastName!.text : '',
      "customer_phone_number": (phoneNumber != null) ? phoneNumber!.text : '',
      "customer_email": (email != null) ? email!.text : '',
    };
    return data;
  }
}
