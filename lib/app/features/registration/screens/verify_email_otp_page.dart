import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/data/models/auth/verify_email_response.dart';
import 'package:immoplus/app/features/registration/customer_registration.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit_state.dart';
// Optionnel si vous utilisez PinFieldAutoFill. Sinon, remplacez par vos propres champs.
import 'package:sms_autofill/sms_autofill.dart';

class DataRouterRegistration {
  String email;
  String token;
  DataRouterRegistration({required this.email, required this.token});
}

class VerifyEmailOtpPage extends StatefulWidget {
  const VerifyEmailOtpPage({
    super.key,
    required this.email,
    this.nextRouteName,
    this.pageController,
  });

  /// L’email à vérifier (déjà saisi à l’étape précédente)
  final String email;

  /// Si fourni, navigation par `Navigator.pushReplacementNamed(nextRouteName)`.
  final String? nextRouteName;

  /// Optionnel : si vous utilisez un PageView et voulez revenir à la page précédente.
  final PageController? pageController;

  static const name = 'VERIFY_EMAIL_OTP';

  @override
  State<VerifyEmailOtpPage> createState() => _VerifyEmailOtpPageState();
}

class _VerifyEmailOtpPageState extends State<VerifyEmailOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  String? _otpValidator(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Le code est requis';
    if (v.length != 6) return 'Le code doit contenir 6 chiffres';
    if (!RegExp(r'^\d{6}$').hasMatch(v)) return 'Le code doit être numérique';
    return null;
  }

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final cubit = context.read<RgistrationCubitCubit>();
    final resp = await cubit.verifyOtp(
      email: widget.email.trim(),
      otp: _otpController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (resp is VerifyEmailResponse) {
      // Succès : navigation
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Email vérifié avec succès.'),
      //     backgroundColor: Colors.green,
      //   ),
      // );
      context.pushReplacementNamed(CustomerRegistration.name,
          extra: DataRouterRegistration(
              email: resp.data.email.toString(),
              token: resp.data.token.toString()));
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (context) => CustomerRegistration(
      //           email: resp.data.email.toString(),
      //           token: resp.data.token.toString()),
      //     ),
      //     (route) => false);
    } else {
      // Échec : feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Code invalide ou expiré. Veuillez réessayer.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resend(BuildContext context) async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    final cubit = context.read<RgistrationCubitCubit>();
    final ok = await cubit.sendEmailOTP(email: widget.email.trim());
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? 'Un nouveau code a été envoyé à ${widget.email}.'
            : 'Échec de l’envoi du code. Réessayez.'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification du code'),
        centerTitle: true,
        elevation: 0,
        leading: widget.pageController == null
            ? null
            : IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  widget.pageController!.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
      ),
      body: BlocListener<RgistrationCubitCubit, RegistrationCubitState>(
        listener: (context, state) {
          setState(() => _isLoading = state is REGISTRATION_LOADING);
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.mark_email_read_outlined,
                                  size: 48, color: theme.colorScheme.primary),
                              const SizedBox(height: 12),
                              Text(
                                'Entrez le code reçu par email',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Un code à 6 chiffres a été envoyé à ${widget.email}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.8),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 28),
                              // Champ OTP (6 cases)
                              PinFieldAutoFill(
                                codeLength: 6,
                                currentCode: _otpController.text,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                decoration: BoxLooseDecoration(
                                  gapSpace: 10,
                                  radius: const Radius.circular(10),
                                  strokeColorBuilder: FixedColorBuilder(
                                    theme.colorScheme.primary.withOpacity(.5),
                                  ),
                                  bgColorBuilder: FixedColorBuilder(
                                      theme.colorScheme.surface),
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                onCodeChanged: (code) {
                                  final v = (code ?? '').trim();
                                  if (v.length <= 6) {
                                    _otpController.value = TextEditingValue(
                                      text: v,
                                      selection: TextSelection.collapsed(
                                          offset: v.length),
                                    );
                                    if (_formKey.currentState?.mounted ??
                                        false) {
                                      _formKey.currentState!.validate();
                                    }
                                  }
                                },
                                onCodeSubmitted: (_) =>
                                    _isLoading ? null : _submit(context),
                              ),
                              Builder(builder: (context) {
                                final err = _otpValidator(_otpController.text);
                                return AnimatedOpacity(
                                  opacity: (err == null) ? 0 : 1,
                                  duration: const Duration(milliseconds: 200),
                                  child: (err == null)
                                      ? const SizedBox.shrink()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            err,
                                            style: TextStyle(
                                              color: theme.colorScheme.error,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                );
                              }),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed:
                                  _isLoading ? null : () => _submit(context),
                              style: FilledButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const CupertinoActivityIndicator()
                                  : const Text(
                                      'Valider le code',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(child: const SizedBox(height: 12)),
                        SliverToBoxAdapter(
                          child: TextButton(
                            onPressed:
                                _isLoading ? null : () => _resend(context),
                            child: const Text('Renvoyer le code'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
