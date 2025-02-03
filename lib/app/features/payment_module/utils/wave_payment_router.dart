import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/payment_module/components/wave/wave_phone_number_page.dart';
import 'package:immoplus/app/features/payment_module/components/wave/wave_validator_page.dart';

class WavePaymentRouter {
  static late GoRouter router;
  static ValueNotifier<String> pageStateNotifier =
      ValueNotifier<String>(WaveNumberPage.name);
  static void setup() {
    router = GoRouter(
      initialLocation: '/number',
      routes: [
        GoRoute(
          path: '/number',
          name: WaveNumberPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              const WaveNumberPage(),
        ),
        GoRoute(
          path: '/validator',
          name: WaveValidatorPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              WaveValidatorPage(
            paymentIntentModel: state.extra as PaymentItentData,
          ),
        ),
      ],
    );
  }
}
