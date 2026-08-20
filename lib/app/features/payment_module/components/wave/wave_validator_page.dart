import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_model.dart';
import 'package:immoplus/app/data/repositories/payment_repository.dart';
import 'package:immoplus/app/features/payment_module/components/shared/payment_success_ticket_view.dart';
import 'package:immoplus/app/features/payment_module/components/shared/payment_waiting_view.dart';
import 'package:immoplus/app/features/payment_module/components/wave/wave_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:url_launcher/url_launcher.dart';

class WaveValidatorPage extends StatefulWidget {
  const WaveValidatorPage({
    super.key,
    required this.controller,
    required this.paymentIntentModel,
  });

  final WavePaymentController controller;
  final PaymentItentData paymentIntentModel;

  @override
  State<WaveValidatorPage> createState() => _WaveValidatorPageState();
}

class _WaveValidatorPageState extends State<WaveValidatorPage> {
  PaymentItentModel? _paymentIntentModel;
  bool _paymentValidated = false;
  Timer? _timer;
  bool _urlLaunched = false;

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

      // ✅ URL Wave disponible
      if (paymentDetail.data.hub2NextAction?.data.url.isNotEmpty == true &&
          !_urlLaunched) {
        _urlLaunched = true;
        setState(() {
          _paymentIntentModel = paymentDetail;
        });
        await _launchUrl(paymentDetail.data.hub2NextAction!.data.url);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking payment status: $e');
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error launching URL: $e');
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

    final waveUrl = _paymentIntentModel?.data.hub2NextAction?.data.url;

    return PaymentWaitingView(
      loaderColor: Colors.blue.shade600,
      isWaveStyle: true,
      actionButtonText: "Valider depuis Wave",
      onActionTap: waveUrl != null && waveUrl.isNotEmpty
          ? () {
              if (kDebugMode) {
                print('🔗 Launching Wave URL: $waveUrl');
              }
              _launchUrl(waveUrl);
            }
          : null,
      infoMessage:
          "Veuillez valider depuis l'application Wave.\nUne fois le paiement validé, veuillez patienter quelques instants. Vous serez notifié du statut de votre paiement, puis celui de votre demande par ImmoPlus.",
    );
  }
}
