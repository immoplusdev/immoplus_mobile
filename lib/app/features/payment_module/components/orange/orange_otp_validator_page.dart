import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/payment_module/components/orange/orange_payment_controller.dart';
import 'package:immoplus/app/features/payment_module/services/payment_services.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/lottie_assets.dart';
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
    required this.paymentIntentModel,
  });

  final OrangePaymentController controller;
  final PaymentItentData paymentIntentModel;

  @override
  State<OrangeOptValidatorPage> createState() => _OrangeOptValidatorPageState();
}

class _OrangeOptValidatorPageState extends State<OrangeOptValidatorPage> {
  final OtpFieldController _otpController = OtpFieldController();
  String _otp = '';
  bool _loadingButton = false;
  bool _isSuccess = false;

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
        child: _isSuccess
            ? _buildSuccessView(context, paymentData)
            : _buildOtpView(context, paymentData),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, PaymentData paymentData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 200, child: LottieAssets().success),
        Text(
          "Code OTP validé",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const Gap(10),
        const Text(
          "Une fois le code OTP validé, veuillez patienter quelques instants. "
          "Vous serez notifié du statut de votre paiement, puis celui de votre demande par ImmoPlus.",
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
                name: widget.paymentIntentModel.paymentMethod,
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
              onChanged: (value) {},
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
          clickable: _otp.isNotEmpty,
          text: 'Confirmer',
          isLoading: _loadingButton,
          onClick: () => _onConfirm(paymentData),
        ),
        Gap(MediaQuery.of(context).viewInsets.bottom),
      ],
    );
  }

  void _onConfirm(PaymentData paymentData) {
    if (_otp.isEmpty) return;

    setState(() => _loadingButton = true);

    PaymentServices.authenticatePayment(
      otp: _otp,
      itemId: widget.paymentIntentModel.itemId,
      collection: widget.paymentIntentModel.collection,
      context: context,
      onSuccess: () {
        if (!mounted) return;
        setState(() {
          _loadingButton = false;
          _isSuccess = true;
        });
      },
      onFailed: () {
        if (!mounted) return;
        setState(() => _loadingButton = false);
      },
    );
  }
}
