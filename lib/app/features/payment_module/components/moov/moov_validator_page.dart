import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_model.dart';
import 'package:immoplus/app/data/repositories/payment_repository.dart';
import 'package:immoplus/app/features/payment_module/components/moov/moov_payment_controller.dart';
import 'package:immoplus/app/features/payment_module/components/shared/payment_success_ticket_view.dart';
import 'package:immoplus/app/features/payment_module/components/shared/payment_waiting_view.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/utils/utils.dart';

class MoovOptValidatorPage extends StatefulWidget {
  const MoovOptValidatorPage({
    super.key,
    required this.controller,
    required this.paymentIntentModel,
  });

  final MoovPaymentController controller;
  final PaymentItentData paymentIntentModel;

  @override
  State<MoovOptValidatorPage> createState() => _MoovOptValidatorPageState();
}

class _MoovOptValidatorPageState extends State<MoovOptValidatorPage> {
  PaymentItentModel? _paymentIntentModel;
  bool _paymentValidated = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPaymentStatusCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPaymentStatusCheck() {
    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) => _checkPaymentStatus(timer),
    );
  }

  Future<void> _checkPaymentStatus(Timer timer) async {
    try {
      final paymentDetail = await PaymentRepository().getPayment(
        widget.paymentIntentModel.id,
      );

      if (!mounted) {
        timer.cancel();
        return;
      }

      // ✅ Paiement validé
      if (paymentDetail.data.paymentStatus == PaymentStatus.successful.name) {
        timer.cancel();
        setState(() {
          _paymentValidated = true;
          _paymentIntentModel = paymentDetail;
        });
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking payment status: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentData = PaymentData.of(context);

    if (paymentData == null) {
      return const Center(
        child: Text('Erreur: Données de paiement manquantes'),
      );
    }

    if (_paymentValidated) {
      return PaymentSuccessTicketView(
        paymentData: paymentData,
        paymentIntentData:
            _paymentIntentModel?.data ?? widget.paymentIntentModel,
        phoneNumber: widget.controller.phoneNumber,
      );
    }

    return PaymentWaitingView(
      onBack: () => widget.controller.goToPhoneNumber(),
      loaderColor: Colors.orange,
      instructionMarkdown: Utils.getNextActionText(
        name: widget.paymentIntentModel.paymentMethod,
      ),
      actionButtonText: 'Composer *155#',
      onActionTap: () {
        Utils.ssdPayment(
          paymentType: OPERATOR_NAME.Moov.name.toLowerCase(),
        );
      },
    );
  }
}
