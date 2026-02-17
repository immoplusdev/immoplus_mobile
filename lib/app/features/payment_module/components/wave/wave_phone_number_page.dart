// lib/app/features/payment_module/components/wave/wave_phone_number_page.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/features/payment_module/components/wave/wave_page.dart';
import 'package:immoplus/app/features/payment_module/services/payment_services.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';
import '../../utils/payment_data.dart';
import '../../utils/payment_utils.dart';

class WaveNumberPage extends StatefulWidget {
  const WaveNumberPage({
    super.key,
    required this.controller,
  });

  final WavePaymentController controller;

  @override
  State<WaveNumberPage> createState() => _WaveNumberPageState();
}

class _WaveNumberPageState extends State<WaveNumberPage> {
  final FormController _formController = FormController(
    productId: 0,
    phoneNumber: TextEditingController(text: ''),
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loadingButton = false;

  @override
  void dispose() {
    _formController.phoneNumber?.dispose();
    super.dispose();
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
                  OrderPaymentController.selectedOperator.logo,
                ),
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
                    },
                  );
                },
              ),
            ),
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(
                FontAwesomeIcons.moneyBill,
                color: Colors.green,
              ),
              title: Text(Utils.formatCurrency(paymentData.amount)),
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
                operatorName: OrderPaymentController.selectedOperator.value,
              ),
              inputFormatters: [
                MaskTextInputFormatter(
                  mask: '## ## ## ## ##',
                  filter: {'#': RegExp(r'[0-9]')},
                ),
              ],
            ),
            CustomButtom(
              isLoading: _loadingButton,
              text: 'Confirmer',
              onClick: () => _onConfirm(paymentData),
            ),
          ],
        ),
      ),
    );
  }

  void _onConfirm(PaymentData paymentData) {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loadingButton = true);

    PaymentServices.initPayment(
      context: context,
      number: _formController.phoneNumber!.text.replaceAll(' ', ''),
      collection: paymentData.productType,
      itemID: paymentData.orderID,
      onSuccess: (paymentIntentData) {
        if (!mounted) return;

        setState(() => _loadingButton = false);

        // ✅ Naviguer vers l'étape suivante via le controller
        widget.controller.goToValidator(paymentIntentData);
      },
      onFailed: () {
        if (!mounted) return;
        setState(() => _loadingButton = false);
      },
    );
  }
}
