import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/enums/registration_type.dart';
import 'package:immoplus/app/data/models/auth/verify_otp_extra.dart';
import 'package:immoplus/app/features/registration/screens/verify_email_otp_page.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_page_immo.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:immoplus/app/widgets/international_phone_number_input.dart';
import 'package:immoplus/gen/assets.gen.dart';

class SendEmailOrNumberOptPage extends StatefulWidget {
  const SendEmailOrNumberOptPage({
    super.key,
    required this.type,
    this.onSuccess,
  });

  final RegistrationType type;
  final void Function()? onSuccess;

  static const String name = "SendEmailOrNumberOptPage";
  static String routePath() => '/send-email-or-number-otp';

  @override
  State<SendEmailOrNumberOptPage> createState() => _SendEmailOrNumberOptPageState();
}

class _SendEmailOrNumberOptPageState extends State<SendEmailOrNumberOptPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool isPhoneNumberValid = false;
  String phoneNumber = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (widget.type == RegistrationType.email) {
      if (!_formKey.currentState!.validate()) return;

      final cubit = context.read<RgistrationCubitCubit>();
      final success =
          await cubit.userSendOTP(email: _emailController.text.trim());
      if (!mounted) return;

      if (success) {
        context.pushNamed(
          VerifyEmailOtpPage.name,
          extra: VerifyOtpExtra(
            email: _emailController.text.trim(),
            onSuccess: widget.onSuccess,
          ),
        );
      }
    } else {
      await _sendOtpCode();
    }
  }

  Future<void> _sendOtpCode() async {
    if (!isPhoneNumberValid || phoneNumber.isEmpty) return;
    await AppDialog.show(
      title: 'Envoyer le code par',
      description:
          'Choisissez comment vous souhaitez recevoir votre code de vérification.',
      primaryButtonText: 'WhatsApp',
      secondButtonText: 'SMS',
      onPrimary: () => _doSendOtp(useWhatsapp: true),
      onSecond: () => _doSendOtp(useWhatsapp: false),
    );
  }

  Future<void> _doSendOtp({required bool useWhatsapp}) async {
    FocusScope.of(context).unfocus();
    if (!isPhoneNumberValid || phoneNumber.isEmpty) return;

    final formattedPhone = PhoneNumberHandler.formatPhoneNumber(phoneNumber);

    final cubit = context.read<RgistrationCubitCubit>();
    final success = await cubit.userSendOTP(
      phoneNumber: formattedPhone,
      is_whatssap: useWhatsapp,
    );
    if (!mounted) return;

    if (success) {
      context.pushNamed(
        VerifyEmailOtpPage.name,
        extra: VerifyOtpExtra(
          phoneNumber: formattedPhone,
          isWhatsapp: useWhatsapp,
          onSuccess: widget.onSuccess,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEmail = widget.type == RegistrationType.email;

    return CustomPageImmo(
      title: isEmail ? "Vérification de l'email" : "Vérification du téléphone",
      content: BlocBuilder<RgistrationCubitCubit, RegistrationCubitState>(
        builder: (context, state) {
          final isLoading = state is REGISTRATION_LOADING;

          return SingleChildScrollView(
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
                        isEmail
                            ? "Saisissez votre adresse email"
                            : "Saisissez votre numéro de téléphone",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(8),
                      Text(
                        "Un code de vérification vous sera envoyé.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.8),
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
                              child: isEmail
                                  ? Image.asset(
                                      Assets.img.email.path,
                                      width: 35,
                                    )
                                  : Icon(
                                      Icons.phone_iphone_outlined,
                                      size: 35,
                                      color: theme.primaryColor,
                                    ),
                            ),
                            const Gap(14),
                            Text(
                              isEmail ? "Adresse E-mail" : "Numéro de téléphone",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const Gap(13),
                            if (isEmail)
                              CustomTextField(
                                labelText: "Adresse email",
                                controller: _emailController,
                                textInputType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.send,
                                validator: (String? value) =>
                                    FormUtils.emailValidator(email: value),
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r"\s")),
                                  LengthLimitingTextInputFormatter(254),
                                ],
                                onFieldSubmitted: (_) =>
                                    isLoading ? null : _submit(),
                                prefixIcon: const Icon(Icons.email_outlined),
                                fontSize: 16,
                                fillColor: AppColors.white,
                                sufixIcon:
                                    ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _emailController,
                                  builder: (context, value, _) {
                                    if (value.text.isEmpty) {
                                      return const SizedBox();
                                    }
                                    return IconButton(
                                      tooltip: "Effacer",
                                      icon: const Icon(Icons.close),
                                      onPressed: isLoading
                                          ? null
                                          : _emailController.clear,
                                    );
                                  },
                                ),
                              )
                            else
                              SizedBox(
                                height: 80,
                                child: InternationalPhoneInput(
                                  backgroundColor: Colors.transparent,
                                  onValidPhoneNumber: (value) {
                                    phoneNumber = value;
                                  },
                                  onInputValidated: (isValid) {
                                    setState(() {
                                      isPhoneNumberValid = isValid;
                                    });
                                  },
                                ),
                              ),
                            const Gap(8),

                            // Bouton
                            CustomLoadingButtom(
                              text: "Envoyer le code",
                              onClick: _submit,
                              isLoading: isLoading,
                              clickable: isEmail
                                  ? true
                                  : (isPhoneNumberValid && phoneNumber.isNotEmpty),
                              color: isEmail
                                  ? AppColors.primary
                                  : (isPhoneNumberValid
                                      ? AppColors.primary
                                      : Colors.blueGrey.shade200),
                            ),
                            const Gap(24),
                            Text(
                              isEmail
                                  ? "Votre email est uniquement utilisé pour cette vérification."
                                  : "Votre numéro est uniquement utilisé pour cette vérification.",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
