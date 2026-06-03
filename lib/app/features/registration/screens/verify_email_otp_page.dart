import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/auth/verify_email_response.dart';
import 'package:immoplus/app/data/models/auth/verify_otp_extra.dart';
import 'package:immoplus/app/features/registration/customer_registration.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/custom_input.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_page_immo.dart';
import 'package:immoplus/gen/assets.gen.dart';

class VerifyEmailOtpPage extends StatefulWidget {
  const VerifyEmailOtpPage({
    super.key,
    required this.extra,
    this.nextRouteName,
    this.pageController,
  });

  /// Contient l'email, le numéro, le canal WhatsApp et le callback success
  final VerifyOtpExtra extra;

  /// Si fourni, navigation par `Navigator.pushReplacementNamed(nextRouteName)`.
  final String? nextRouteName;

  /// Optionnel : si vous utilisez un PageView et voulez revenir à la page précédente.
  final PageController? pageController;

  static const name = 'VERIFY_EMAIL_OTP';
  static String routePath() => '/verify-email-otp';

  String? get email => extra.email;
  String? get phoneNumber => extra.phoneNumber;
  bool? get isWhatsapp => extra.isWhatsapp;
  void Function()? get onSuccess => extra.onSuccess;

  @override
  State<VerifyEmailOtpPage> createState() => _VerifyEmailOtpPageState();
}

class _VerifyEmailOtpPageState extends State<VerifyEmailOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool? _isWhatsapp;

  @override
  void initState() {
    super.initState();
    _isWhatsapp = widget.isWhatsapp;
  }

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

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final cubit = context.read<RgistrationCubitCubit>();
    final resp = await cubit.verifyOtp(
      email: widget.email?.trim(),
      phoneNumber: widget.phoneNumber?.trim(),
      otp: _otpController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (resp is VerifyEmailResponse) {
      context.pushReplacementNamed(CustomerRegistration.name,
          extra: DataRouterRegistration(
              email: resp.data.email,
              token: resp.data.token.toString(),
              phoneNumber: widget.phoneNumber));
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      }
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

  Future<void> _resend() async {
    if (widget.email != null) {
      await _doResend(useWhatsapp: null);
      return;
    }

    await AppDialog.show(
      title: 'Envoyer le code par',
      description:
          'Choisissez comment vous souhaitez recevoir votre code de vérification.',
      primaryButtonText: 'WhatsApp',
      secondButtonText: 'SMS',
      onPrimary: () => _doResend(useWhatsapp: true),
      onSecond: () => _doResend(useWhatsapp: false),
    );
  }

  Future<void> _doResend({required bool? useWhatsapp}) async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    final cubit = context.read<RgistrationCubitCubit>();
    final ok = await cubit.userSendOTP(
      email: widget.email?.trim(),
      phoneNumber: widget.phoneNumber?.trim(),
      is_whatssap: useWhatsapp,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok && useWhatsapp != null) {
      setState(() {
        _isWhatsapp = useWhatsapp;
      });
    }

    final destination = useWhatsapp == true
        ? 'WhatsApp'
        : useWhatsapp == false
            ? 'SMS'
            : (widget.email ?? widget.phoneNumber);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Un nouveau code a été envoyé par $destination.'
              : 'Échec de l\'envoi du code. Réessayez.',
        ),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPageImmo(
      title: 'Vérification du code',
      content: BlocListener<RgistrationCubitCubit, RegistrationCubitState>(
        listener: (context, state) {
          setState(() => _isLoading = state is REGISTRATION_LOADING);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(appPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isWhatsapp == true
                          ? 'Entrez le code reçu par WhatsApp'
                          : _isWhatsapp == false
                              ? 'Entrez le code reçu par SMS'
                              : 'Entrez le code reçu par email',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(8),
                    Text(
                      _isWhatsapp == true
                          ? 'Un code à 6 chiffres a été envoyé par WhatsApp au ${widget.phoneNumber}'
                          : _isWhatsapp == false
                              ? 'Un code à 6 chiffres a été envoyé par SMS au ${widget.phoneNumber}'
                              : 'Un code à 6 chiffres a été envoyé à ${widget.email ?? widget.phoneNumber}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(28),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.E6F5FF,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: _isWhatsapp == true
                                ? const Icon(Icons.chat,
                                    color: Colors.green, size: 35)
                                : _isWhatsapp == false
                                    ? const Icon(Icons.sms,
                                        color: Colors.blue, size: 35)
                                    : Image.asset(
                                        Assets.img.email.path,
                                        width: 35,
                                      ),
                          ),
                          const Gap(14),
                          Text("Code de vérification",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                          const Gap(13),
                          // Champ OTP (6 cases)
                          CustomPinput(
                            controller: _otpController,
                            onCompleted: (pin) => _submit(),
                            onChanged: (code) {
                              if (_formKey.currentState?.mounted ?? false) {
                                _formKey.currentState!.validate();
                              }
                            },
                          ),

                          // Message d'erreur animé
                          Builder(
                            builder: (context) {
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
                            },
                          ),
                          const Gap(24),

                          // Bouton de validation
                          SizedBox(
                            width: double.infinity,
                            child: CustomLoadingButtom(
                              text: "Valider le code",
                              onClick: _submit,
                              isLoading: _isLoading,
                            ),
                          ),
                          const Gap(12),

                          // Bouton renvoyer
                          Center(
                            child: TextButton(
                              onPressed: _isLoading ? null : _resend,
                              child: const Text('Renvoyer le code'),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
