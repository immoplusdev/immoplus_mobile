import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/features/payment_module/utils/wave_payment_router.dart';

import 'wave_phone_number_page.dart';

class WavePage extends StatefulWidget {
  const WavePage(
      {super.key,
      required this.productType,
      required this.orderID,
      required this.amount});
  final String productType;
  final String orderID;
  final int amount;
  @override
  State<WavePage> createState() => _WavePageState();
}

class _WavePageState extends State<WavePage> {
  @override
  Widget build(BuildContext context) {
    return PaymentData(
      productType: widget.productType,
      orderID: widget.orderID,
      amount: widget.amount,
      child: ValueListenableBuilder(
          valueListenable: WavePaymentRouter.pageStateNotifier,
          builder: (context, value, child) {
            return SizedBox(
              height: (value == WaveNumberPage.name)
                  ? 300 + MediaQuery.viewInsetsOf(context).bottom
                  : 500 + MediaQuery.viewInsetsOf(context).bottom,
              child: Router(
                routerDelegate: WavePaymentRouter.router.routerDelegate,
                routeInformationParser:
                    WavePaymentRouter.router.routeInformationParser,
                routeInformationProvider:
                    WavePaymentRouter.router.routeInformationProvider,
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    WavePaymentRouter.setup();
  }
}
