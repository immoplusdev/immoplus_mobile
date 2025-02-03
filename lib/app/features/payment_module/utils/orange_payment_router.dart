import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/payment_module/components/orange/orange_otp_validator_page.dart';
import 'package:immoplus/app/features/payment_module/components/orange/orange_phone_number_page.dart';

class OrangePaymentRouter {
  static late GoRouter router;
  static ValueNotifier<String> pageStateNotifier =
      ValueNotifier<String>(OrangePhoneNumberPage.name);
  // static String productType = '';
  // static String orderID = '';
  static void setup() {
    router = GoRouter(
      initialLocation: '/number',
      routes: [
        GoRoute(
          path: '/number',
          name: OrangePhoneNumberPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              const OrangePhoneNumberPage(),
        ),
        GoRoute(
          path: '/otp',
          name: OrangeOptValidatorPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              OrangeOptValidatorPage(
            paymentIntentModel: state.extra as PaymentItentData,
          ),
        ),
      ],
    );
  }
}
