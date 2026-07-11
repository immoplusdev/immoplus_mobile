import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/models/remote/payment/operator_model.dart';
import 'package:immoplus/app/features/hotel/cubit/hotel_cubit.dart';
import 'package:immoplus/app/features/payment_module/paiement_status_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';
import 'package:immoplus/app/core/network/utils/easy_loading_handler.dart';

class HotelPaymentSelectorPage extends StatefulWidget {
  const HotelPaymentSelectorPage({
    super.key,
    required this.hotelId,
    required this.paymentPageAdapter,
  });

  final String hotelId;
  final PaymentPageAdapter paymentPageAdapter;

  static const String name = 'hotel_payment_selector';
  static String route(String hotelId) => '/hotels/$hotelId/payment';

  @override
  State<HotelPaymentSelectorPage> createState() =>
      _HotelPaymentSelectorPageState();
}

class _HotelPaymentSelectorPageState extends State<HotelPaymentSelectorPage> {
  bool _isLoading = true;
  String _errorMsg = '';
  List<OperatorModel> _availableOperators = [];

  @override
  void initState() {
    super.initState();
    _fetchPaymentMethods();
  }

  Future<void> _fetchPaymentMethods() async {
    try {
      final response =
          await context.read<HotelCubit>().getPaymentMethods(widget.hotelId);
      final apiMethods = response.availableMethods;

      // Mappage : ne garder que les opérateurs dont la valeur existe dans retraitOperatorsItems
      final List<OperatorModel> mappedOperators = [];
      for (final method in apiMethods) {
        try {
          final matchedOperator =
              OrderPaymentController.retraitOperatorsItems.firstWhere(
            (op) => op.value == method.id,
          );
          // On peut cloner ou utiliser directement
          mappedOperators.add(matchedOperator);
        } catch (e) {
          // Opérateur non supporté localement
        }
      }

      setState(() {
        _availableOperators = mappedOperators;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      appBar: AppBar(
        backgroundColor: AppColors.scafold,
        title: const Text('Moyen de paiement'),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall,
        leading: const BackButton(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMsg.isNotEmpty
              ? Center(child: Text("Erreur: $_errorMsg"))
              : CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          tileColor: Colors.white,
                          title: Text(
                            '${widget.paymentPageAdapter.amount} FCFA',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final operator = _availableOperators[index];
                          final isStripe = operator.value == 'visa_card';

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30)
                                .copyWith(bottom: 10),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  OrderPaymentController.selectedOperator =
                                      operator;
                                });

                                if (isStripe) {
                                  EasyLoadingHandler.showErrorToast(
                                      text:
                                          'Paiement Stripe non supporté pour les hôtels pour le moment.');
                                } else {
                                  // Navigation vers le composant de validation du paiement
                                  // PaiementStatusPage redirige ensuite vers la page spécifique (WavePage, MoovPage, etc.)
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaiementStatusPage(
                                        paymentPageAdapter:
                                            widget.paymentPageAdapter,
                                      ),
                                    ),
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
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              subtitle: Text(
                                "Frais : ${operator.fee} %",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                          );
                        },
                        childCount: _availableOperators.length,
                      ),
                    ),
                  ],
                ),
    );
  }
}
