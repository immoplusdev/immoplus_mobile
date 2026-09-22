import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/features/payment_module/components/orange/orange_payment_controller.dart';
import 'package:immoplus/app/features/payment_module/services/payment_services.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class OrangeOptValidatorPage extends StatefulWidget {
  const OrangeOptValidatorPage({
    super.key,
    required this.controller,
  });

  final OrangePaymentController controller;

  @override
  State<OrangeOptValidatorPage> createState() => _OrangeOptValidatorPageState();
}

class _OrangeOptValidatorPageState extends State<OrangeOptValidatorPage> {
  final OtpFieldController _otpController = OtpFieldController();
  String _otp = '';
  bool _loadingButton = false;

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
        child: _buildOtpView(context, paymentData),
      ),
    );
  }

  Widget _buildOtpView(BuildContext context, PaymentData paymentData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
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
        const Gap(15),
        const Flexible(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(child: Text('1')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 60,
            child: Markdown(
              physics: const NeverScrollableScrollPhysics(),
              styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.center),
              selectable: true,
              data: Utils.getNextActionText(
                name: OrderPaymentController.selectedOperator.value,
              ),
            ),
          ),
        ),
        CustomButtom(
          elevation: 2,
          color: Colors.white,
          text: 'Composer #144*82#',
          textColor: Colors.black,
          onClick: () {
            Utils.ssdPayment(
              paymentType: OPERATOR_NAME.Orange.name.toLowerCase(),
            );
          },
        ),
        const Flexible(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(child: Text('2')),
          ),
        ),
        const Flexible(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Saisissez le code OTP de confirmation'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 220,
            child: OTPTextField(
              onChanged: (value) {
                setState(() => _otp = value);
              },
              otpFieldStyle: OtpFieldStyle(
                backgroundColor: Colors.white,
              ),
              length: 4,
              width: MediaQuery.of(context).size.width,
              fieldWidth: 50,
              style: const TextStyle(fontSize: 17),
              textFieldAlignment: MainAxisAlignment.spaceBetween,
              fieldStyle: FieldStyle.box,
              controller: _otpController,
              onCompleted: (pin) {
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() => _otp = pin);
              },
            ),
          ),
        ),
        const Gap(10),
        CustomButtom(
          clickable: _otp.length == 4,
          text: 'Confirmer',
          isLoading: _loadingButton,
          onClick: () => _onConfirm(paymentData),
        ),
        Gap(MediaQuery.of(context).viewInsets.bottom),
      ],
    );
  }

  void _onConfirm(PaymentData paymentData) {
    if (_otp.isEmpty || _otp.length < 4) return;

    setState(() => _loadingButton = true);

    PaymentServices.initPayment(
      context: context,
      number: widget.controller.phoneNumber ?? '',
      collection: paymentData.productType,
      itemID: paymentData.orderID,
      otp: _otp,
      extra: paymentData.extra,
      onSuccess: (paymentIntentData) {
        if (!mounted) return;
        setState(() => _loadingButton = false);
        // ✅ Naviguer vers l'étape de validation (polling du statut)
        widget.controller.goToValidator(paymentIntentData);
      },
      onFailed: () {
        if (!mounted) return;
        setState(() => _loadingButton = false);
      },
    );
  }
}
