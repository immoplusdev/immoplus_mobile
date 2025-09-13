import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/payment_module/components/orange/orange_phone_number_page.dart';
import 'package:immoplus/app/features/payment_module/services/payment_services.dart';
import 'package:immoplus/app/features/payment_module/utils/orange_payment_router.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/lottie_assets.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class OrangeOptValidatorPage extends StatefulWidget {
  const OrangeOptValidatorPage({super.key, required this.paymentIntentModel});

  static String name = 'otp';
  final PaymentItentData paymentIntentModel;

  @override
  State<OrangeOptValidatorPage> createState() => _OrangeOptValidatorPageState();
}

class _OrangeOptValidatorPageState extends State<OrangeOptValidatorPage> {
  OtpFieldController controller = OtpFieldController();
  String otp = '';
  bool loadingButton = false;
  bool isSuccess = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
        child: (isSuccess)
            ? Column(
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
                    "Une fois le code OTP validé, veuillez patienter quelques instants. Vous serez notifié du statut de votre paiement, puis celui de votre demande par ImmoPlus.",
                    textAlign: TextAlign.center,
                  ),
                  Gap(8),
                  TextButton.icon(
                    iconAlignment: IconAlignment.end,
                    icon: Icon(FontAwesomeIcons.circleArrowRight,
                        color: AppColors.primary, size: 20),
                    // isDestructiveAction: false,
                    onPressed: () {
                      AppRouter.router.go(
                          "/payment/${PaymentData.of(context)!.productType}/${PaymentData.of(context)!.orderID}");
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    label: Text(
                      "Voir les détails de la réservation",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Flexible(
                  //   child: ListTile(
                  //     contentPadding: EdgeInsets.zero,
                  //     leading: IconButton(
                  //       icon: const Icon(
                  //         CupertinoIcons.chevron_back,
                  //         color: Colors.black,
                  //       ),
                  //       onPressed: () {
                  //         OrangePaymentRouter.router
                  //             .goNamed(OrangePhoneNumberPage.name);
                  //       },
                  //     ),
                  //     titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  //   ),
                  // ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          foregroundImage: NetworkImage(
                              OrderPaymentController.selectedOperator.logo),
                        ),
                        // you can replace
                        Transform.scale(
                          scale: 2.5,
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.orange),
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
                      child: CircleAvatar(
                        child: Text('1'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 60,
                      child: Markdown(
                        physics: const NeverScrollableScrollPhysics(),
                        styleSheet:
                            MarkdownStyleSheet(textAlign: WrapAlignment.center),
                        selectable: true,
                        data: Utils.getNextActionText(
                            name: widget.paymentIntentModel.paymentMethod),
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
                      child: CircleAvatar(
                        child: Text('2'),
                      ),
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
                        //contentPadding: EdgeInsets.all(10),
                        textFieldAlignment: MainAxisAlignment.spaceBetween,
                        fieldStyle: FieldStyle.box,
                        controller: controller,
                        onCompleted: (pin) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            otp = pin;
                          });
                          // setState(() {
                          //   _displayOtp = false;
                          // });
                          // context
                          //     .read<PaymentCubit>()
                          //     .authenticatePayment(
                          //         context: context,
                          //         orderId: widget.orderModel.itemId!,
                          //         productType:
                          //             widget.orderModel.productType!,
                          //         otp: pin);
                          print("Completed: $pin");
                        },
                      ),
                    ),
                  ),
                  const Gap(10),
                  CustomButtom(
                    clickable: otp.isNotEmpty,
                    text: 'Confirmer',
                    isLoading: loadingButton,
                    onClick: () {
                      if (otp.isNotEmpty) {
                        setState(() {
                          loadingButton = true;
                        });
                        PaymentServices.authenticatePayment(
                          otp: otp,
                          itemId: widget.paymentIntentModel.itemId,
                          collection: widget.paymentIntentModel.collection,
                          context: context,
                          onSuccess: () {
                            setState(() {
                              loadingButton = false;
                              isSuccess = true;
                            });
                          },
                          onFailed: () {
                            setState(() {
                              loadingButton = false;
                            });
                          },
                        );
                      }
                    },
                  ),
                  // CupertinoActionSheetAction(
                  //   isDestructiveAction: true,
                  //   onPressed: () {
                  //     AppDialog.confirm(
                  //         context: context,
                  //         content: "Voulez vous vraiment annuler le paiement ?",
                  //         rollback: () {
                  //           AppRouter.router.pop();
                  //           AppRouter.router.pop();
                  //         });
                  //   },
                  //   child: const Text(
                  //     "Annuler le paiement",
                  //   ),
                  // ),
                  Gap(MediaQuery.viewInsetsOf(context).bottom)
                ],
              ),
      ),
    );
  }
}
