import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/error/app_error.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:immoplus/app/core/error/error_feedback.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/payment/operator_model.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/wallet/data/wallet_models.dart';
import 'package:immoplus/app/features/wallet/logic/withdrawal_cubit.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_formatters.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:immoplus/app/widgets/international_phone_number_input.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';

/// Demande de retrait du solde du coffre vers un compte mobile money.
class WithdrawalRequestPage extends StatelessWidget {
  const WithdrawalRequestPage({super.key, required this.wallet});

  final WalletModel wallet;

  static const String name = 'WITHDRAWAL_REQUEST_PAGE';
  static String routePath() => '/wallet/withdrawal';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WithdrawalCubit>(),
      child: _WithdrawalForm(wallet: wallet),
    );
  }
}

class _WithdrawalForm extends StatefulWidget {
  const _WithdrawalForm({required this.wallet});

  final WalletModel wallet;

  @override
  State<_WithdrawalForm> createState() => _WithdrawalFormState();
}

class _WithdrawalFormState extends State<_WithdrawalForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _operators = OrderPaymentController.retraitOperatorsItems;

  OperatorModel? _operator;
  String _phoneNumber = '';
  bool _isPhoneValid = false;

  /// Erreurs de validation renvoyées par le serveur, par champ.
  Map<String, String> _serverErrors = {};

  String get _initialPhone {
    final phone = getIt<SessionManager>().currentUser?.phoneNumber ?? '';
    if (phone.isEmpty) return '';
    return phone.startsWith('+') ? phone : '+$phone';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String? _validateAmount(String? value) {
    final serverError = _serverErrors['amount'];
    if (serverError != null) return serverError;
    final amount = int.tryParse((value ?? '').replaceAll(RegExp(r'\s'), ''));
    if (amount == null || amount <= 0) return 'Saisissez un montant';
    if (amount > widget.wallet.availableBalance) {
      return 'Montant supérieur à votre solde disponible';
    }
    return null;
  }

  void _submit() {
    setState(() => _serverErrors = {});
    if (!_formKey.currentState!.validate()) return;
    if (_operator == null) {
      ToastUtils.showWarning(title: 'Choisissez un opérateur');
      return;
    }
    if (!_isPhoneValid || _phoneNumber.isEmpty) {
      ToastUtils.showWarning(title: 'Numéro de téléphone invalide');
      return;
    }
    FocusScope.of(context).unfocus();
    context.read<WithdrawalCubit>().submit(
          WithdrawalRequestBody(
            amount:
                int.parse(_amountController.text.replaceAll(RegExp(r'\s'), '')),
            phoneNumber: _phoneNumber,
            operator: _operator!.value,
            currency: widget.wallet.currency,
          ),
        );
  }

  void _onFailure(AppError error) {
    // Validation par champ : affichée sous les champs concernés.
    if (error is ValidationError && error.hasFieldErrors) {
      setState(() {
        _serverErrors = {
          for (final entry in error.fieldErrors.entries)
            if (entry.value.isNotEmpty) entry.key: entry.value.first,
        };
      });
      _formKey.currentState?.validate();
      return;
    }
    ErrorFeedback.present(error, context: ErrorContext.withdrawalRequest);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WithdrawalCubit, WithdrawalState>(
      listener: (context, state) {
        if (state is WithdrawalSuccess) {
          ToastUtils.showSuccess(
            title: 'Demande enregistrée',
            description: 'Votre retrait sera traité prochainement.',
          );
          context.pop(true);
        } else if (state is WithdrawalFailure) {
          _onFailure(state.error);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 0,
          title: const Text('Retirer mon solde'),
          titleTextStyle: Theme.of(context).textTheme.headlineSmall,
          leading: BackButton(color: AppColors.black),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Disponible : ${formatAmount(widget.wallet.availableBalance, currency: widget.wallet.currency)}',
                          style: AppTypography.font(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _amountController,
                          labelText: 'Montant à retirer (FCFA)',
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: _validateAmount,
                          onChanged: (_) {
                            if (_serverErrors.containsKey('amount')) {
                              setState(() => _serverErrors.remove('amount'));
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Opérateur',
                          style: AppTypography.font(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (final operator in _operators)
                              _OperatorChip(
                                operator: operator,
                                selected: _operator?.value == operator.value,
                                onTap: () =>
                                    setState(() => _operator = operator),
                              ),
                          ],
                        ),
                        if (_serverErrors['operator'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              _serverErrors['operator']!,
                              style: AppTypography.font(
                                fontSize: 12,
                                color: AppColors.immoFeedbackError,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Text(
                          'Numéro de réception',
                          style: AppTypography.font(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InternationalPhoneInput(
                          initialPhoneNumber: _initialPhone,
                          onValidPhoneNumber: (value) => _phoneNumber = value,
                          onInputValidated: (valid) => _isPhoneValid = valid,
                        ),
                        if (_serverErrors['phoneNumber'] != null)
                          Text(
                            _serverErrors['phoneNumber']!,
                            style: AppTypography.font(
                              fontSize: 12,
                              color: AppColors.immoFeedbackError,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          'Votre coffre n\'est débité qu\'une fois le retrait '
                          'traité. Vous pouvez suivre la demande dans l\'onglet '
                          '« Retraits ».',
                          style: AppTypography.font(
                            fontSize: 12,
                            height: 1.5,
                            color: AppColors.slate500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: BlocBuilder<WithdrawalCubit, WithdrawalState>(
                  builder: (context, state) => CustomButtom(
                    text: 'Demander le retrait',
                    buttonHeight: 56,
                    borderRadius: BorderRadius.circular(28),
                    isLoading: state is WithdrawalSubmitting,
                    onClick: _submit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OperatorChip extends StatelessWidget {
  const _OperatorChip({
    required this.operator,
    required this.selected,
    required this.onTap,
  });

  final OperatorModel operator;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.gray200,
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                operator.logo,
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 28,
                  height: 28,
                  color: AppColors.gray200,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              operator.name,
              style: AppTypography.font(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.slate900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
