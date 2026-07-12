import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_intent_body.dart';
import 'package:immoplus/app/data/repositories/payment_repository.dart';
import 'package:immoplus/app/features/fast-track-book/reservation_engagement.dart';
import 'package:immoplus/app/features/payment_module/bloc/payment_cubit.dart';
import 'package:immoplus/app/features/payment_module/paiement_status_page.dart';
import 'package:immoplus/app/features/payment_module/stripe_result_route.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/utils/app_colors.dart';
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
    } on StripeException catch (e) {
      if (e.error.code != FailureCode.Canceled) {
        EasyLoading.showToast(
          e.error.localizedMessage ?? 'Le paiement a échoué.',
        );
      }
    } catch (e, stack) {
      EasyLoading.showToast("Une erreur s'est produite.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.scafold,
            title: const Text('Moyen de paiement'),
            titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            leading: BackButton(color: Colors.black),
            actions: const [],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                tileColor: Colors.white,
                title: Text(
                  '${widget.paymentPageAdapter.amount} FCFA',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Montant à payer'),
                trailing: const Icon(
                  FontAwesomeIcons.moneyBill,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final operator =
                    OrderPaymentController.retraitOperatorsItems[index];
                final isStripe = operator.value == 'visa_card';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30)
                      .copyWith(bottom: 10),
                  child: ListTile(
                    onTap: _isLoading
                        ? null
                        : () {
                            context.read<PaymentCubit>().init();
                            setState(() {
                              OrderPaymentController.selectedOperator = operator;
                            });
                            getIt<AnalyticsService>().logAddPaymentInfo(
                              paymentType: operator.value,
                              value: widget.paymentPageAdapter.amount.toDouble(),
                              itemId: widget.paymentPageAdapter.itemId,
                            );

                            if (isStripe) {
                              _payWithStripe();
                            } else {
                              context.pushNamed(
                                PaiementStatusPage.name,
                                extra: widget.paymentPageAdapter,
                              );
                            }
                          },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    leading: CircleAvatar(
                      foregroundImage: NetworkImage(operator.logo),
                    ),
                    tileColor: Colors.white,
                    title: Text(operator.name),
                    titleTextStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    trailing: _isLoading && isStripe
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(CupertinoIcons.chevron_right_circle_fill),
                  ),
                );
              },
              childCount: OrderPaymentController.retraitOperatorsItems.length,
            ),
          ),
        ],
      ),
    );
  }
}
