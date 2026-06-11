import 'package:immoplus/app/data/models/remote/payment/operator_model.dart';
import 'package:immoplus/app/data/models/remote/payment/operator_provider_model.dart';

class OrderPaymentController {
  static List<OperatorModel> items = [];
  static bool operatorIsSelected = true;
  static OperatorProviderModel selectedValue = const OperatorProviderModel(
      id: "cash", name: "Cash", country: "CI", method: "cash", currency: "XOF");
  static String getLogoURL(String method) {
    if (method == 'orange') {
      return "https://play-lh.googleusercontent.com/AlHlWVHGr3yfwKMlCSkN38H_TPJ3Hsmqa8Ddiq06Qgq68e4iIOIxrfpWlcd-l8wYxHs";
    } else if (method == 'wave') {
      return "https://play-lh.googleusercontent.com/B2sfLVgRWgV_bk5rtF51w6AieJWXc0qWbyWoaA8pMNp-is41AmvhJYVr95Dq9hT97Es";
    } else if (method == 'moov') {
      return "https://play-lh.googleusercontent.com/ZZzobZMd5ewtZsX7B6bYyj1yMb7hyOEhVCpqsYlbDA0MGQaGuMAIlddE8xWvksIyhLZt";
    } else if (method == 'mtn') {
      return "https://theme.zdassets.com/theme_assets/2281253/1525d160e04a6da033974dee88ce44cce70585d4.JPG";
    } else if (method == 'visa') {}
    return "https://play-lh.googleusercontent.com/lKebetEHVDuBrbq5KJJ4MK6V6BaFuo0Mj9Qy9YZkoenrEDZVU-IzLrbAuoKMaCT4nA";
  }

  static OperatorModel selectedOperator = const OperatorModel(
      id: 1,
      name: "Orange Money",
      value: 'orange',
      logo:
          "https://play-lh.googleusercontent.com/AlHlWVHGr3yfwKMlCSkN38H_TPJ3Hsmqa8Ddiq06Qgq68e4iIOIxrfpWlcd-l8wYxHs",
      prefix: "07",
      fee: 2);
  static List<OperatorModel> retraitOperatorsItems = const <OperatorModel>[
    OperatorModel(
      id: 4,
      name: "Wave",
      value: 'wave',
      logo:
          "https://play-lh.googleusercontent.com/B2sfLVgRWgV_bk5rtF51w6AieJWXc0qWbyWoaA8pMNp-is41AmvhJYVr95Dq9hT97Es",
      prefix: '',
      fee: 2,
    ),

    // OperatorModel(
    //     id: 0,
    //     name: "Sur place",
    //     logo: "https://cdn-icons-png.flaticon.com/512/2331/2331941.png",
    //     prefix: null,
    //     value: 'cash',
    //     fee: 1),
    OperatorModel(
      id: 1,
      name: "Orange Money",
      value: 'orange',
      logo:
          "https://play-lh.googleusercontent.com/AlHlWVHGr3yfwKMlCSkN38H_TPJ3Hsmqa8Ddiq06Qgq68e4iIOIxrfpWlcd-l8wYxHs",
      prefix: "07",
      fee: 2,
    ),
    OperatorModel(
      id: 2,
      name: "MTN MoMo",
      value: 'mtn',
      logo:
          "https://theme.zdassets.com/theme_assets/2281253/1525d160e04a6da033974dee88ce44cce70585d4.JPG",
      prefix: "05",
      fee: 2,
    ),
    OperatorModel(
      id: 3,
      name: "Moov Money",
      value: 'moov',
      logo:
          "https://play-lh.googleusercontent.com/ZZzobZMd5ewtZsX7B6bYyj1yMb7hyOEhVCpqsYlbDA0MGQaGuMAIlddE8xWvksIyhLZt",
      prefix: "01",
      fee: 2,
    ),
    OperatorModel(
      id: 0,
      name: "Carte bancaire",
      value: 'visa_card',
      logo:
          "https://img.freepik.com/vecteurs-libre/appartement-securite-pour-carte-credit_78370-3588.jpg?semt=ais_hybrid&w=740&q=80",
      prefix: '',
      fee: 2,
    ),
  ];
  static OperatorProviderModel electedOperator = const OperatorProviderModel();
  static OperatorProviderModel electedParamsItem =
      const OperatorProviderModel();
}
