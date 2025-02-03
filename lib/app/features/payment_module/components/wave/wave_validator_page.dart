import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_model.dart';
import 'package:immoplus/app/data/repositories/payment_repository.dart';
import 'package:immoplus/app/features/payment_module/components/wave/wave_phone_number_page.dart';
import 'package:immoplus/app/features/payment_module/utils/orange_payment_router.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class WaveValidatorPage extends StatefulWidget {
  const WaveValidatorPage({super.key, required this.paymentIntentModel});
  static String name = 'validator';
  final PaymentItentData paymentIntentModel;

  @override
  State<WaveValidatorPage> createState() => _WaveValidatorPageState();
}

class _WaveValidatorPageState extends State<WaveValidatorPage> {
  PaymentItentModel? _paymentIntentModel;
  int rep = 0;
  Timer? _timer;
  Future<PaymentItentModel> getStatus(Timer timer) async {
    PaymentItentModel paymentDetailModel =
        await PaymentRepository().getPayment(widget.paymentIntentModel.id);

    rep += 1;
    if (rep == 5) {
      timer.cancel();
      print('Le timer a été arrêté.');
    }

    if (paymentDetailModel.data.hub2NextAction!.data.url.isNotEmpty) {
      timer.cancel();
      print('Le timer a été arrêté.');
      _paymentIntentModel = paymentDetailModel;
      _launchUrl(_paymentIntentModel!.data.hub2NextAction!.data.url);
      // Arrêter le timer
      setState(() {});
    }
    return paymentDetailModel;
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        // Votre logique ici
        getStatus(timer);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
        child: Visibility(
          visible: _paymentIntentModel != null,
          replacement: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          OrderPaymentController.selectedOperator.logo),
                    ),
                    // you can replace
                    Transform.scale(
                      scale: 2.5,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              for (int i = 0; i <= 4; i++)
                Shimmer.fromColors(
                  period: const Duration(milliseconds: 800),
                  baseColor: CupertinoColors.tertiarySystemFill,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: ((sin(i) + 1) * 50))
                            .copyWith(bottom: 10),
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
            ],
          ),
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
                      OrangePaymentRouter.router.goNamed(WaveNumberPage.name);
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
                            OrderPaymentController.selectedOperator.logo ?? ''),
                      ),
                      // you can replace
                      Transform.scale(
                        scale: 2.5,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue.shade600),
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(15),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Veuillez valider depuis l'application Wave",
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      if (kDebugMode) {
                        print(
                            _paymentIntentModel!.data.hub2NextAction!.data.url);
                      }
                      _launchUrl(
                          _paymentIntentModel!.data.hub2NextAction!.data.url);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor: AppColors.primary,
                    leading: const Icon(
                      Icons.phone_android,
                      color: Colors.white,
                    ),
                    title: const Text("Valider depuis Wave"),
                    titleTextStyle: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                    trailing: const Icon(
                      CupertinoIcons.chevron_right_circle_fill,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Gap(10),
              const Text(
                "Une fois le code le paiement validé, veuillez patienter quelques instants. Vous serez notifié du statut de votre paiement, puis celui de votre demande par ImmoPlus.",
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
              // Gap(MediaQuery.viewInsetsOf(context).bottom)
            ],
          ),
        ),
      ),
    );
  }
}
