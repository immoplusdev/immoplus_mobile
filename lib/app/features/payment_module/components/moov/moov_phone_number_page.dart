import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/features/payment_module/components/moov/moov_validator_page.dart';
import 'package:immoplus/app/features/payment_module/utils/moov_payment_router.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../constants/constantes.dart';
import '../../services/payment_services.dart';
import '../../utils/payment_utils.dart';

class MoovNumberPage extends StatefulWidget {
  const MoovNumberPage({super.key});
  static String name = 'number';
  @override
  State<MoovNumberPage> createState() => _MoovNumberPageState();
}

class _MoovNumberPageState extends State<MoovNumberPage> {
  final FormController _formController = FormController(
      productId: 0, phoneNumber: TextEditingController(text: ''));
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loadingButton = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      MoovPaymentRouter.pageStateNotifier.value = MoovNumberPage.name;
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
                'Paiement par ${OrderPaymentController.selectedOperator.name}',
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
              labelText: 'Numéro de téléphone valide',
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
                // MoovPaymentRouter.pageStateNotifier.value =
                //     MoovOptValidatorPage.name;
                // MoovPaymentRouter.router.goNamed(MoovOptValidatorPage.name,
                //     extra: PaymentIntentModel(paymentMethod: 'moov'));

                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loadingButton = true;
                  });
                  PaymentServices.initPayment(
                    context: context,
                    number:
                        _formController.phoneNumber!.text.replaceAll(' ', ''),
                    collection: ProductType.booking.name,
                    itemID: "38c16b58-74a5-47ec-b404-8ebf6a7b3dcc",
                    onSuccess: (p) {
                      setState(() {
                        loadingButton = false;
                      });
                      MoovPaymentRouter.pageStateNotifier.value =
                          MoovOptValidatorPage.name;
                      MoovPaymentRouter.router
                          .goNamed(MoovOptValidatorPage.name, extra: p);
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
