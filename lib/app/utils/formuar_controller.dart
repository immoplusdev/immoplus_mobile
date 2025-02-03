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
  String? serviceOption;
  List<String>? dates;

  int? city;
  int? state;
  void set setServiceOption(String service) {
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
  });
  set setCityCode(int cit) => this.city = cit;
  set setStateCode(int st) => this.state = st;
  addDate({required String date}) {
    dates!.add(date);
  }

  Map<String, dynamic> toJsonForOrder() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['service_option'] = this.serviceOption;
    data['note'] = (note != null) ? this.note!.text : '';
    data['customer_last_name'] = (lastName != null) ? this.lastName!.text : '';
    data['customer_first_name'] =
        (firstName != null) ? this.firstName!.text : '';
    data['first_name'] = (firstName != null) ? this.firstName!.text : '';
    data['last_name'] = (lastName != null) ? this.lastName!.text : '';
    data['email'] = (email != null) ? this.email!.text : '';
    data['customer_phone_number'] =
        (phoneNumber != null) ? this.phoneNumber!.text : '';
    data['phone_number'] = (phoneNumber != null) ? this.phoneNumber!.text : '';
    //data['password'] = (password != null) ? this.password!.text : '';
    data['customer_email'] = (email != null) ? this.email!.text : '';
    data['username'] = (email != null) ? this.email!.text : '';
    data['customer_country_id'] = 54;
    data['customer_state_id'] = state;
    data['customer_city_id'] = city;
    data['customer_address'] = (address != null) ? this.address!.text : '';
    data['customer_address_2'] = (address2 != null) ? this.address2!.text : '';
    data['payment_type'] =
        (this.payementType != null) ? this.payementType!.text : '';
    data['password'] = (this.password != null) ? this.password!.text : '';
    data['newPassword'] =
        (this.newPassword != null) ? this.newPassword!.text : '';
    data['city'] = this.city;
    data['dates'] = this.dates;
    data['visit_type'] = this.serviceOption ?? 'normal';
    data['type_visite'] = this.serviceOption ?? 'normal';
    data['logement'] = logmentID ?? ''; //dates_reservation
    data['notes'] = 'note';
    data['service_dates'] = (this.dates != null)
        ? this
            .dates!
            .map((e) => {
                  "date": e,
                })
            .toList()
        : [];
    data['dates_reservation'] = (this.dates != null)
        ? this
            .dates!
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
      "customer_first_name": (firstName != null) ? this.firstName!.text : '',
      "customer_last_name": (lastName != null) ? this.lastName!.text : '',
      "customer_phone_number":
          (phoneNumber != null) ? this.phoneNumber!.text : '',
      "customer_email": (email != null) ? this.email!.text : '',
    };
    return data;
  }
}
