import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/features/payment_module/components/moov/moov_phone_number_page.dart';
import 'package:immoplus/app/features/payment_module/utils/moov_payment_router.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';

class MoovPage extends StatefulWidget {
  const MoovPage(
      {super.key,
      required this.productType,
      required this.orderID,
      required this.amount});
  final String productType;
  final String orderID;
  final int amount;

  @override
  State<MoovPage> createState() => _MoovPageState();
}

class _MoovPageState extends State<MoovPage> {
  @override
  Widget build(BuildContext context) {
    return PaymentData(
      productType: widget.productType,
      orderID: widget.orderID,
      amount: getAmountithFee(widget.amount),
      child: ValueListenableBuilder(
          valueListenable: MoovPaymentRouter.pageStateNotifier,
          builder: (context, value, child) {
            return SizedBox(
              height: (value == MoovNumberPage.name)
                  ? 300 + MediaQuery.viewInsetsOf(context).bottom
                  : 500 + MediaQuery.viewInsetsOf(context).bottom,
              child: Router(
                routerDelegate: MoovPaymentRouter.router.routerDelegate,
                routeInformationParser:
                    MoovPaymentRouter.router.routeInformationParser,
                routeInformationProvider:
                    MoovPaymentRouter.router.routeInformationProvider,
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    MoovPaymentRouter.setup();
  }
}
