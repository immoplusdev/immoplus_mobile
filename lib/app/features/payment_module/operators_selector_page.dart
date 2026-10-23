import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/core/services/crashlytics_service.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_intent_body.dart';
import 'package:immoplus/app/data/models/remote/payment/operator_model.dart';
import 'package:immoplus/app/data/repositories/payment_repository.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/features/fast-track-book/reservation_engagement.dart';
import 'package:immoplus/app/features/payment_module/bloc/payment_cubit.dart';
import 'package:immoplus/app/features/payment_module/paiement_status_page.dart';
import 'package:immoplus/app/features/payment_module/stripe_result_route.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/features/payment_module/widgets/payment_gallery.dart';
import 'package:immoplus/app/features/payment_module/widgets/payment_summary_skeleton.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';

class OperatorsSelectorPage extends StatefulWidget {
  const OperatorsSelectorPage({super.key, required this.paymentPageAdapter});
  static String name = 'operators_selector';
  final PaymentPageAdapter paymentPageAdapter;
  @override
  State<OperatorsSelectorPage> createState() => _OperatorsSelectorPageState();
}

class _OperatorsSelectorPageState extends State<OperatorsSelectorPage> {
  bool _isLoading = false;
  OperatorModel? _selected;

  PaymentSummary? _summary;
  late int _amount = widget.paymentPageAdapter.amount;
  bool _summaryLoading = false;

  @override
  void initState() {
    super.initState();
    _summary = widget.paymentPageAdapter.summary;
    if (_summary == null &&
        widget.paymentPageAdapter.collection == ProductType.reservations.name) {
      _loadSummary();
    }
  }

  /// Certains points d'entrée n'ont que l'id de la réservation : on récupère
  /// ses détails pour afficher le résumé. En cas d'échec, la page reste
  /// utilisable sans résumé.
  Future<void> _loadSummary() async {
    setState(() => _summaryLoading = true);
    try {
      final response = await getIt<ResidenceRepository>()
          .getReservation(id: widget.paymentPageAdapter.itemId);
      final summary = PaymentSummary.fromReservation(response.data);
      final amount = response.data.montantAPayer.toInt();
      widget.paymentPageAdapter.summary = summary;
      if (amount > 0) widget.paymentPageAdapter.amount = amount;
      if (!mounted) return;
      setState(() {
        _summary = summary;
        if (amount > 0) _amount = amount;
      });
    } catch (e, stack) {
      getIt<CrashlyticsService>().recordNonFatalError(
        exception: e,
        stackTrace: stack,
        screen: 'OperatorsSelectorPage',
        feature: 'payment_summary',
        errorType: 'PaymentSummaryLoadException',
      );
    } finally {
      if (mounted) setState(() => _summaryLoading = false);
    }
  }

  void _onPay() {
    final operator = _selected;
    if (operator == null) {
      EasyLoading.showToast('Choisissez un moyen de paiement.');
      return;
    }
    context.read<PaymentCubit>().init();
    OrderPaymentController.selectedOperator = operator;
    getIt<AnalyticsService>().logAddPaymentInfo(
      paymentType: operator.value,
      value: widget.paymentPageAdapter.amount.toDouble(),
      itemId: widget.paymentPageAdapter.itemId,
    );

    if (operator.value == 'visa_card') {
      _payWithStripe();
    } else {
      context.pushNamed(
        PaiementStatusPage.name,
        extra: widget.paymentPageAdapter,
      );
    }
  }

  Future<void> _payWithStripe() async {
    setState(() => _isLoading = true);

    try {
      final model = await PaymentRepository().intent(
        body: PaymentIntentBody(
          collection: widget.paymentPageAdapter.collection,
          itemId: widget.paymentPageAdapter.itemId,
          paymentMethod: OrderPaymentController.selectedOperator.value,
          paymentCredentials: '',
        ),
      );

      final clientSecret = model.data.stripeClientSecret ?? '';
      if (clientSecret.isEmpty) {
        EasyLoading.showToast("Impossible d'initialiser le paiement.");
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'ImmoPlus',
          style: ThemeMode.light,
        ),
      );

      // Stopper le polling avant que Stripe prenne l'écran
      ReservationEngagementFrame.onPaymentCompleted();

      await Stripe.instance.presentPaymentSheet();

      if (!mounted) {
        return;
      }
      context.push(StripeResultRoute.path, extra: model.data);
    } on StripeException catch (e, stack) {
      if (e.error.code != FailureCode.Canceled) {
        EasyLoading.showToast(
          e.error.localizedMessage ?? 'Le paiement a échoué.',
        );
        getIt<CrashlyticsService>().recordNonFatalError(
          exception: e,
          stackTrace: stack,
          screen: 'OperatorsSelectorPage',
          feature: 'payment_stripe',
          errorType: 'StripePaymentSheetException',
          reason: e.error.localizedMessage,
          additionalContext: {
            'failure_code': e.error.code.name,
          },
        );
      }
    } catch (e, stack) {
      EasyLoading.showToast("Une erreur s'est produite.");
      getIt<CrashlyticsService>().recordNonFatalError(
        exception: e,
        stackTrace: stack,
        screen: 'OperatorsSelectorPage',
        feature: 'payment_stripe',
        errorType: 'PaymentSheetUnexpectedException',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  static String _group(int value, String separator) {
    return value.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (_) => separator,
        );
  }

  @override
  Widget build(BuildContext context) {
    final amount = _amount;
    final summary = _summary;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        title: const Text('Moyen de paiement'),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall,
        leading: BackButton(color: AppColors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_summaryLoading && summary == null)
                      const PaymentSummarySkeleton(),
                    if (summary != null) ...[
                      if (summary.imageIds.isNotEmpty)
                        PaymentGallery(imageIds: summary.imageIds),
                      if (summary.imageIds.isNotEmpty)
                        const SizedBox(height: 20),
                      _buildHeader(summary),
                      const SizedBox(height: 20),
                    ],
                    _buildTotalCard(summary, amount),
                    const SizedBox(height: 16),
                    _buildSecureNotice(),
                    const SizedBox(height: 24),
                    Text(
                      'Payer avec',
                      style: AppTypography.font(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildOperatorGrid(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.6),
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Payer ${_group(amount, '.')} F',
                          style: AppTypography.font(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(PaymentSummary summary) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                summary.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.font(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.slate900,
                ),
              ),
              if (summary.subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  summary.subtitle!,
                  style: AppTypography.font(
                    fontSize: 14,
                    color: AppColors.slate500,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (summary.badge != null) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              summary.badge!,
              style: AppTypography.font(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTotalCard(PaymentSummary? summary, int amount) {
    final dates = summary?.dateRange;
    final reference = summary?.reference;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.gray200, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (dates != null)
                  Text(
                    dates,
                    style: AppTypography.font(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate900,
                    ),
                  ),
                if (reference != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Réf. $reference',
                    style: AppTypography.font(
                      fontSize: 12,
                      color: AppColors.slate500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'TOTAL À PAYER',
                style: AppTypography.font(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${_group(amount, ' ')} FCFA',
                style: AppTypography.font(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecureNotice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.immoFeedbackSuccessSubtle.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.immoFeedbackSuccess.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: 16,
              color: AppColors.immoFeedbackSuccess,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Paiement sécurisé. Un problème ? Notre équipe vous '
              'accompagne pour votre demande de remboursement.',
              style: AppTypography.font(
                fontSize: 13,
                height: 1.4,
                color: AppColors.slate500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatorGrid() {
    final operators = OrderPaymentController.retraitOperatorsItems;
    return Column(
      children: [
        for (var i = 0; i < operators.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(child: _buildOperatorTile(operators[i])),
                const SizedBox(width: 12),
                Expanded(
                  child: i + 1 < operators.length
                      ? _buildOperatorTile(operators[i + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildOperatorTile(OperatorModel operator) {
    final selected = _selected?.value == operator.value;
    return GestureDetector(
      onTap: _isLoading ? null : () => setState(() => _selected = operator),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.gray200,
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: operator.logo,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 36,
                  height: 36,
                  color: AppColors.gray200,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                operator.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.font(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate900,
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.slate500,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
