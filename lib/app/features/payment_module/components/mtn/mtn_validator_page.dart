import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/payment_module/bloc/payment_cubit.dart';
import 'package:immoplus/app/features/payment_module/components/mtn/mtn_phone_number_page.dart';
import 'package:immoplus/app/features/payment_module/utils/orange_payment_router.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/logic/request_state.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/lottie_assets.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';

class MtnValidatorPage extends StatefulWidget {
  const MtnValidatorPage({super.key, required this.paymentIntentModel});
  static String name = 'otp';
  final PaymentItentData paymentIntentModel;

  @override
  State<MtnValidatorPage> createState() => _MtnValidatorPageState();
}

class _MtnValidatorPageState extends State<MtnValidatorPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, RequestState>(
      builder: (context, state) {
        if (state is REQUEST_SUCCESS) {
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
                  AppRouter.router.go(
                      "/order/${PaymentData.of(context)!.orderID}/${PaymentData.of(context)!.productType}");
                },
                child: const Text(
                  "Voir les détails de la réservation",
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
                        OrangePaymentRouter.router.goNamed(MtnNumberPage.name);
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
                              OrderPaymentController.selectedOperator.logo ??
                                  ''),
                        ),
                        // you can replace
                        Transform.scale(
                          scale: 2.5,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.yellow.shade600),
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
                          name: widget.paymentIntentModel.paymentMethod ?? ''),
                    ),
                  ),
                ),
                Flexible(
                  child: CustomButtom(
                    elevation: 2,
                    color: Colors.white,
                    text: 'Composer *133#',
                    textColor: Colors.black,
                    onClick: () {
                      Utils.ssdPayment(
                        paymentType: OPERATOR_NAME.MTN.name.toLowerCase(),
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
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    AppDialog.confirm(
                        context: context,
                        content: "Voulez vous vraiment annuler le paiement ?",
                        rollback: () {
                          AppRouter.router.pop();
                          AppRouter.router.pop();
                        });
                  },
                  child: const Text(
                    "Annuler le paiement",
                  ),
                ),
                Gap(MediaQuery.viewInsetsOf(context).bottom)
              ],
            ),
          ),
        );
      },
    );
  }
}
