import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/mtn_payment_router.dart';
import '../../utils/payment_data.dart';
import '../moov/moov_phone_number_page.dart';

class MtnPage extends StatefulWidget {
  const MtnPage(
      {super.key,
      required this.productType,
      required this.orderID,
      required this.amount});
  final String productType;
  final String orderID;
  final int amount;
  @override
  State<MtnPage> createState() => _MtnPageState();
}

class _MtnPageState extends State<MtnPage> {
  @override
  Widget build(BuildContext context) {
    return PaymentData(
      productType: widget.productType,
      orderID: widget.orderID,
      amount: getAmountithFee(widget.amount),
      child: ValueListenableBuilder(
          valueListenable: MtnPaymentRouter.pageStateNotifier,
          builder: (context, value, child) {
            return SizedBox(
              height: (value == MoovNumberPage.name)
                  ? 300 + MediaQuery.viewInsetsOf(context).bottom
                  : 500 + MediaQuery.viewInsetsOf(context).bottom,
              child: Router(
                routerDelegate: MtnPaymentRouter.router.routerDelegate,
                routeInformationParser:
                    MtnPaymentRouter.router.routeInformationParser,
                routeInformationProvider:
                    MtnPaymentRouter.router.routeInformationProvider,
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    MtnPaymentRouter.setup();
  }
}
