import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/features/payment_module/components/orange/orange_otp_validator_page.dart';
import 'package:immoplus/app/features/payment_module/utils/orange_payment_router.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_utils.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../widgets/custom_button.dart';
import '../../services/payment_services.dart';
import '../../utils/payment_data.dart';

class OrangePhoneNumberPage extends StatefulWidget {
  const OrangePhoneNumberPage({super.key});

  static String name = 'number';

  @override
  State<OrangePhoneNumberPage> createState() => _OrangePhoneNumberPageState();
}

class _OrangePhoneNumberPageState extends State<OrangePhoneNumberPage> {
  final FormController _formController = FormController(
      productId: 0, phoneNumber: TextEditingController(text: ''));
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loadingButton = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      OrangePaymentRouter.pageStateNotifier.value = OrangePhoneNumberPage.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                foregroundImage: NetworkImage(
                    OrderPaymentController.selectedOperator.logo ?? ''),
              ),
              title: Text(
                OrderPaymentController.selectedOperator.name,
              ),
              titleTextStyle: Theme.of(context).textTheme.titleLarge,
              trailing: IconButton(
                icon: const Icon(
                  CupertinoIcons.clear_circled_solid,
                  color: Colors.black,
                ),
                onPressed: () {
                  AppDialog.confirm(
                      context: context,
                      content: "Voulez vous annuler l'opération ?",
                      rollback: () {
                        AppRouter.router.pop();
                        AppRouter.router.pop();
                      });
                },
              ),
            ),
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(
                FontAwesomeIcons.moneyBill,
                color: Colors.green,
              ),
              title:
                  Text(Utils.formatCurrency(PaymentData.of(context)!.amount)),
              titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            CustomTextField(
              fillColor: Colors.white,
              autofocus: true,
              controller: _formController.phoneNumber,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
              labelText: 'Numéro de telephone orange',
              prefixIcon: const Icon(CupertinoIcons.phone),
              validator: (String? value) => PaymentUtils.numberValidator(
                  number: value!.replaceAll(' ', ''),
                  operatorName:
                      OrderPaymentController.selectedOperator.value ?? ''),
              inputFormatters: [
                MaskTextInputFormatter(
                    mask: '## ## ## ## ##', filter: {'#': RegExp(r'[0-9]')})
              ],
            ),
            CustomButtom(
              isLoading: loadingButton,
              text: 'Confirmer',
              onClick: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loadingButton = true;
                  });
                  PaymentServices.initPayment(
                    context: context,
                    number:
                        _formController.phoneNumber!.text.replaceAll(' ', ''),
                    collection: PaymentData.of(context)!.productType,
                    itemID: PaymentData.of(context)!.orderID,
                    onSuccess: (p) {
                      setState(() {
                        loadingButton = false;
                      });
                      inspect(p);
                      OrangePaymentRouter.pageStateNotifier.value =
                          OrangeOptValidatorPage.name;
                      OrangePaymentRouter.router
                          .goNamed(OrangeOptValidatorPage.name, extra: p);
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
            //Gap(MediaQuery.viewInsetsOf(context).bottom)
          ],
        ),
      ),
    );
  }
}
