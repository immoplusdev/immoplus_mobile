import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/payment_module/components/moov/moov_phone_number_page.dart';
import 'package:immoplus/app/features/payment_module/components/moov/moov_validator_page.dart';

class MoovPaymentRouter {
  static late GoRouter router;
  static ValueNotifier<String> pageStateNotifier =
      ValueNotifier<String>(MoovNumberPage.name);
  static void setup() {
    router = GoRouter(
      initialLocation: '/number',
      routes: [
        GoRoute(
          path: '/number',
          name: MoovNumberPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              MoovNumberPage(),
        ),
        GoRoute(
          path: '/validator',
          name: MoovOptValidatorPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              MoovOptValidatorPage(
            paymentIntentModel: state.extra as PaymentItentData,
          ),
        ),
      ],
    );
  }
}
