import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/payment_module/bloc/payment_cubit.dart';
import 'package:immoplus/app/features/payment_module/components/mtn/mtn_payment_controller.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/logic/request_state.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/lottie_assets.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MtnValidatorPage extends StatefulWidget {
  const MtnValidatorPage({
    super.key,
    required this.controller,
    required this.paymentIntentModel,
  });

  final MtnPaymentController controller;
  final PaymentItentData paymentIntentModel;

  @override
  State<MtnValidatorPage> createState() => _MtnValidatorPageState();
}

class _MtnValidatorPageState extends State<MtnValidatorPage> {
  @override
  Widget build(BuildContext context) {
    final paymentData = PaymentData.of(context);

    if (paymentData == null) {
      return const Center(
        child: Text('Erreur: Données de paiement manquantes'),
      );
    }

    return BlocBuilder<PaymentCubit, RequestState>(
      builder: (context, state) {
        if (state is REQUEST_SUCCESS) {
          return _buildSuccessView(context, paymentData);
        }

        return _buildWaitingView(context, paymentData);
      },
    );
  }

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
          "Une fois le paiement validé, veuillez patienter quelques instants. "
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

  Widget _buildWaitingView(BuildContext context, PaymentData paymentData) {
    return Form(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.yellow.shade600,
                        ),
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
                  styleSheet: MarkdownStyleSheet(
                    textAlign: WrapAlignment.center,
                  ),
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
              "Une fois le paiement validé, veuillez patienter quelques instants. "
              "Vous serez notifié du statut de votre paiement, puis celui de votre demande par ImmoPlus.",
              textAlign: TextAlign.center,
            ),
            const Gap(10),
            Gap(MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
