import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/utils/formuar_controller.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../widgets/custom_text_field.dart';

class VisaPage extends StatefulWidget {
  const VisaPage({super.key});

  @override
  State<VisaPage> createState() => _VisaPageState();
}

class _VisaPageState extends State<VisaPage> {
  final FormController _formController = FormController(
      productId: 0, phoneNumber: TextEditingController(text: ''));
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                foregroundImage:
                    NetworkImage(OrderPaymentController.selectedOperator.logo),
              ),
              title: Text(
                'Paiement par ${OrderPaymentController.selectedOperator.name}',
              ),
              titleTextStyle: Theme.of(context).textTheme.titleMedium,
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
                        context.pop();
                        context.pop();
                      });
                },
              ),
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Numéro de carte'),
                CustomTextField(
                  fillColor: Colors.white,
                  autofocus: true,
                  controller: _formController.phoneNumber,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  labelText: '#### #### #### ####',
                  obscureText: true,
                  sufixIcon: const FaIcon(FontAwesomeIcons.ccVisa),
                  // validator: (String? value) =>
                  //     PaymentUtils.numberValidator(
                  //         number: value!.replaceAll(' ', ''),
                  //         operatorName: OrderPaymentController
                  //                 .selectedOperator.value ??
                  //             ''),
                  // inputFormatters: [
                  //   MaskTextInputFormatter(
                  //       mask: '#### #### #### ####',
                  //       filter: {'#': RegExp(r'[0-9]')})
                  // ],
                ),
              ],
            ),
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Expiration'),
                        CustomTextField(
                          fillColor: Colors.white,
                          //autofocus: true,
                          //controller: _formController.phoneNumber,
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          sufixIcon: const Icon(CupertinoIcons.calendar),
                          labelText: 'MM/YY',
                          inputFormatters: [
                            MaskTextInputFormatter(
                                mask: '##/##', filter: {'#': RegExp(r'[0-9]')})
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('CVC'),
                        CustomTextField(
                          fillColor: Colors.white,
                          //autofocus: true,
                          //controller: _formController.phoneNumber,
                          textInputType: TextInputType.number,

                          textInputAction: TextInputAction.next,
                          labelText: '###',
                          sufixIcon: const Icon(CupertinoIcons.lock),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text('Nom du propriétaire'),
                ),
                CustomTextField(
                  fillColor: Colors.white,
                  //autofocus: true,

                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(CupertinoIcons.person),
                  labelText: 'Nom sur la carte',
                ),
              ],
            ),
            const CustomButtom(text: 'Confirmer'),
            Gap(MediaQuery.viewInsetsOf(context).bottom)
          ],
        ),
      ),
    );
  }
}
