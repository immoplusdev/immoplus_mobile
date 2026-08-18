// lib/app/features/payment_module/components/moov/moov_validator_page.dart

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/data/repositories/payment_repository.dart';
import 'package:immoplus/app/features/payment_module/components/moov/moov_payment_controller.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/lottie_assets.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';

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

    return Form(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
        child: _paymentValidated
            ? _buildSuccessView(context, paymentData)
            : _buildWaitingView(context, paymentData),
      ),
    );
  }

  // ✅ Vue de succès
  Widget _buildSuccessView(BuildContext context, PaymentData paymentData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 200, child: LottieAssets().success),
        Text(
          "Paiement validé",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const Gap(10),
        const Text(
          "Votre paiement Moov a été validé avec succès",
          textAlign: TextAlign.center,
        ),
        const Gap(8),
        TextButton.icon(
          iconAlignment: IconAlignment.end,
          icon: Icon(
            FontAwesomeIcons.circleArrowRight.data,
            color: AppColors.primary,
            size: 20,
          ),
          onPressed: () {
            AppRouter.router.go(
              "/payment/${paymentData.productType}/${paymentData.orderID}",
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          label: Text(
            "Voir les détails de la réservation",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.primary,
                ),
          ),
        ),
      ],
    );
  }

  // ✅ Vue d'attente
  Widget _buildWaitingView(BuildContext context, PaymentData paymentData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: IconButton(
              icon: const Icon(
                CupertinoIcons.chevron_back,
                color: Colors.black,
              ),
              onPressed: () {
                widget.controller.goToPhoneNumber();
              },
            ),
            titleTextStyle: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Flexible(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  foregroundImage: NetworkImage(
                    OrderPaymentController.selectedOperator.logo,
                  ),
                ),
                Transform.scale(
                  scale: 2.5,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    strokeWidth: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(15),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Markdown(
              physics: const NeverScrollableScrollPhysics(),
              styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.center),
              selectable: true,
              data: Utils.getNextActionText(
                name: widget.paymentIntentModel.paymentMethod,
              ),
            ),
          ),
        ),
        Flexible(
          child: CustomButtom(
            elevation: 2,
            color: Colors.white,
            text: 'Composer *155#',
            textColor: Colors.black,
            onClick: () {
              Utils.ssdPayment(
                paymentType: OPERATOR_NAME.Moov.name.toLowerCase(),
              );
            },
          ),
        ),
        const Gap(10),
        const Text(
          "Une fois le paiement validé, veuillez patienter quelques instants. Vous serez notifié du statut de votre paiement, puis celui de votre demande par ImmoPlus.",
          textAlign: TextAlign.center,
        ),
        const Gap(10),
        Gap(MediaQuery.viewInsetsOf(context).bottom)
      ],
    );
  }
}
