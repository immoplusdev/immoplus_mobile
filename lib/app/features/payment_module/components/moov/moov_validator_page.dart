// lib/app/features/payment_module/components/moov/moov_validator_page.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/payment_module/bloc/payment_cubit.dart';
import 'package:immoplus/app/features/payment_module/components/moov/moov_payment_controller.dart';
import 'package:immoplus/app/logic/app_state.dart';
import 'package:immoplus/app/logic/request_state.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/lottie_assets.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';

class MoovOptValidatorPage extends StatefulWidget {
  const MoovOptValidatorPage({
    super.key,
    required this.controller, // ← NOUVEAU paramètre
    required this.paymentIntentModel,
  });

  final MoovPaymentController controller;
  final PaymentItentData paymentIntentModel;

  @override
  State<MoovOptValidatorPage> createState() => _MoovOptValidatorPageState();
}

class _MoovOptValidatorPageState extends State<MoovOptValidatorPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, RequestState>(
      builder: (context, state) {
        if (state is SuccessState) {
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
                "Une fois le paiement validé, veuillez patienter quelques instants. Vous serez notifié du statut de votre paiement, puis celui de votre demande par ImmoPlus.",
                textAlign: TextAlign.center,
              ),
              CupertinoActionSheetAction(
                isDestructiveAction: false,
                onPressed: () {
                  AppRouter.router.goNamed(HomePage.name);
                },
                child: const Text(
                  "Page d'accueil",
                ),
              ),
            ],
          );
        }
        return Form(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
            child: Column(
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
                ),
                const Gap(15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
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
                  "Une fois le paiment validé, veuillez patienter quelques instants. Vous serez notifié du statut de votre paiement, puis celui de votre demande par ImmoPlus.",
                  textAlign: TextAlign.center,
                ),
                const Gap(10),
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
      },
    );
  }
}
