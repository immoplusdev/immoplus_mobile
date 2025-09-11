import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/payment_module/bloc/payment_cubit.dart';
import 'package:immoplus/app/features/payment_module/paiement_status_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';

class OperatorsSelectorPage extends StatefulWidget {
  const OperatorsSelectorPage({super.key, required this.paymentPageAdapter});
  static String name = 'operators_selector';
  final PaymentPageAdapter paymentPageAdapter;
  @override
  State<OperatorsSelectorPage> createState() => _OperatorsSelectorPageState();
}

class _OperatorsSelectorPageState extends State<OperatorsSelectorPage> {
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
            leading: BackButton(
              color: Colors.black,
            ),
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
                    Utils.formatCurrency(widget.paymentPageAdapter.amount)),
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w600),
                subtitle: const Text('Montant a payer'),
                trailing: const Icon(
                  FontAwesomeIcons.moneyBill,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30)
                    .copyWith(bottom: 10),
                child: ListTile(
                  onTap: () {
                    context.read<PaymentCubit>().init();
                    setState(() {
                      OrderPaymentController.selectedOperator =
                          OrderPaymentController.retraitOperatorsItems[index];
                    });

                    if (OrderPaymentController.selectedOperator.value ==
                        OPERATOR_NAME.visa.name.toLowerCase()) {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        // enableDrag: false,
                        // isDismissible: false,

                        useSafeArea: true,
                        useRootNavigator: true,
                        backgroundColor: AppColors.scafold,
                        scrollControlDisabledMaxHeightRatio:
                            BorderSide.strokeAlignCenter,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        //showDragHandle: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15)
                                .copyWith(bottom: 30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.moneyBill,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Le paiement par ${OrderPaymentController.selectedOperator.name} n'est pas disponible pour le moment. Veuillez si possible essayer un autre moyen de paiement ou contacter notre service client.",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      context.pushNamed(PaiementStatusPage.name,
                          extra: widget.paymentPageAdapter);
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage(
                      OrderPaymentController.retraitOperatorsItems[index].logo,
                    ),
                  ),
                  tileColor: Colors.white,
                  title: Text(
                      OrderPaymentController.retraitOperatorsItems[index].name),
                  titleTextStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16),
                  subtitle: Text(
                      '${OrderPaymentController.retraitOperatorsItems[index].fee}% de frais'),
                  trailing:
                      const Icon(CupertinoIcons.chevron_right_circle_fill),
                ),
              ),
              childCount: OrderPaymentController.retraitOperatorsItems.length,
            ),
          ),
          SliverToBoxAdapter(
            child: TextButton(
              onPressed: () {
                AppDialog.confirm(
                    context: context,
                    content:
                        "Votre demande risque d’être annulée dans moins de 12 heures si la facture n’est pas payée à temps. Veuillez contacter le service client pour plus d’informations.",
                    rollback: () {
                      AppRouter.router.goNamed(HomePage.name);
                    });
              },
              child: Text(
                "Payer plus tard",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
