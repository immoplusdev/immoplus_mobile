import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/payment_module/components/mtn/mtn_phone_number_page.dart';
import 'package:immoplus/app/features/payment_module/components/mtn/mtn_validator_page.dart';

class MtnPaymentRouter {
  static late GoRouter router;
  static ValueNotifier<String> pageStateNotifier =
      ValueNotifier<String>(MtnNumberPage.name);
  static void setup() {
    router = GoRouter(
      initialLocation: '/number',
      routes: [
        GoRoute(
          path: '/number',
          name: MtnNumberPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              const MtnNumberPage(),
        ),
        GoRoute(
          path: '/validator',
          name: MtnValidatorPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              MtnValidatorPage(
            paymentIntentModel: state.extra as PaymentItentData,
          ),
        ),
      ],
    );
  }
}
