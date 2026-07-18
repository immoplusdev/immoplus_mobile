import 'package:flutter/material.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';

// getAmountithFee(int amount) =>
//     ((amount + (amount * OrderPaymentController.selectedOperator.fee!) / 100))
//         .ceil();

class PaymentData extends InheritedWidget {
  const PaymentData({
    super.key,
    required this.child,
    required this.amount,
    required this.productType,
    required this.orderID,
    this.extra,
  }) : super(child: child);

  final Widget child;
  final int amount;
  final String productType;
  final String orderID;
  final Object? extra;
  static PaymentData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PaymentData>();
  }

  @override
  bool updateShouldNotify(PaymentData oldWidget) {
    return true;
  }
}
