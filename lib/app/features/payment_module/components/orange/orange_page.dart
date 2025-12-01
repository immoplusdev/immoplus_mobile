import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/features/payment_module/components/orange/orange_phone_number_page.dart';
import 'package:immoplus/app/features/payment_module/utils/orange_payment_router.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';

class OrangePage extends StatefulWidget {
  const OrangePage(
      {super.key,
      required this.productType,
      required this.orderID,
      required this.amount});
  final String productType;
  final String orderID;
  final int amount;
  @override
  State<OrangePage> createState() => _OrangePageState();
}

class _OrangePageState extends State<OrangePage> {
  @override
  Widget build(BuildContext context) {
    return PaymentData(
      productType: widget.productType,
      orderID: widget.orderID,
      amount: widget.amount,
      child: ValueListenableBuilder(
          valueListenable: OrangePaymentRouter.pageStateNotifier,
          builder: (context, value, child) {
            return SizedBox(
              height: (value == OrangePhoneNumberPage.name)
                  ? 300 + MediaQuery.viewInsetsOf(context).bottom
                  : 600 + MediaQuery.viewInsetsOf(context).bottom,
              child: Router(
                routerDelegate: OrangePaymentRouter.router.routerDelegate,
                routeInformationParser:
                    OrangePaymentRouter.router.routeInformationParser,
                routeInformationProvider:
                    OrangePaymentRouter.router.routeInformationProvider,
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    OrangePaymentRouter.setup();
  }
}
