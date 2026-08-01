import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_model.dart';
import 'package:immoplus/app/data/repositories/payment_repository.dart';
import 'package:immoplus/app/features/payment_module/components/wave/wave_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/lottie_assets.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class WaveValidatorPage extends StatefulWidget {
  const WaveValidatorPage({
    super.key,
    required this.controller,
    required this.paymentIntentModel,
  });

  final WavePaymentController controller;
  final PaymentItentData paymentIntentModel;

  @override
  State<WaveValidatorPage> createState() => _WaveValidatorPageState();
}

class _WaveValidatorPageState extends State<WaveValidatorPage> {
  PaymentItentModel? _paymentIntentModel;
  bool _paymentValidated = false;
  int _checkCount = 0;
  Timer? _timer;
  bool _urlLaunched = false;

  @override
  void initState() {
    super.initState();
    _startPaymentStatusCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPaymentStatusCheck() {
    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) => _checkPaymentStatus(timer),
    );
  }

  Future<void> _checkPaymentStatus(Timer timer) async {
    try {
      final paymentDetail = await PaymentRepository().getPayment(
        widget.paymentIntentModel.id,
      );

      _checkCount++;

      if (!mounted) {
        timer.cancel();
        return;
      }

      // ✅ Paiement validé
      if (paymentDetail.data.paymentStatus == PaymentStatus.successful.name) {
        timer.cancel();
        setState(() {
          _paymentValidated = true;
          _paymentIntentModel = paymentDetail;
        });
        return;
      }

      // ✅ URL Wave disponible
      if (paymentDetail.data.hub2NextAction?.data.url.isNotEmpty == true &&
          !_urlLaunched) {
        _urlLaunched = true;
        setState(() {
          _paymentIntentModel = paymentDetail;
        });
        await _launchUrl(paymentDetail.data.hub2NextAction!.data.url);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking payment status: $e');
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error launching URL: $e');
      }
    }
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
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
        child: _paymentValidated
            ? _buildSuccessView(context, paymentData)
            : _buildWaitingView(context),
      ),
    );
  }

  // ✅ Vue de succès
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
          "Votre paiement Wave a été validé avec succès",
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

  // ✅ Vue d'attente
  Widget _buildWaitingView(BuildContext context) {
    if (_paymentIntentModel == null) {
      return _buildLoadingIndicator();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: _buildOperatorIndicator()),
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
            child: _buildWaveButton(),
          ),
        ),
        const Gap(10),
        const Text(
          "Une fois le paiement validé, veuillez patienter quelques instants. "
          "Vous serez notifié du statut de votre paiement, puis celui de votre demande par ImmoPlus.",
          textAlign: TextAlign.center,
        ),
        const Gap(10),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildOperatorIndicator(),
        const Gap(10),
        for (int i = 0; i <= 4; i++)
          Shimmer.fromColors(
            period: const Duration(milliseconds: 800),
            baseColor: CupertinoColors.tertiarySystemFill,
            highlightColor: Colors.grey.shade100,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: ((sin(i) + 1) * 50),
              ).copyWith(bottom: 10),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOperatorIndicator() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            foregroundImage: NetworkImage(
              OrderPaymentController.selectedOperator.logo ?? '',
            ),
          ),
          Transform.scale(
            scale: 2.5,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.blue.shade600,
              ),
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveButton() {
    return ListTile(
      onTap: () {
        final url = _paymentIntentModel?.data.hub2NextAction?.data.url;
        if (url != null && url.isNotEmpty) {
          if (kDebugMode) {
            print('🔗 Launching Wave URL: $url');
          }
          _launchUrl(url);
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      tileColor: AppColors.primary,
      leading: const Icon(
        Icons.phone_android,
        color: Colors.white,
      ),
      title: const Text("Valider depuis Wave"),
      titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.white,
          ),
      trailing: const Icon(
        CupertinoIcons.chevron_right_circle_fill,
        color: Colors.white,
      ),
    );
  }
}
