import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:immoplus/app/core/error/error_feedback.dart';
import 'package:immoplus/app/data/models/auth/phone_challenge_models.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/otp_login/widgets/login_otp_dialog.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/international_phone_number_input.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({
    super.key,
    this.pageController,
    this.onSwitchMode,
  });

  final PageController? pageController;
  final VoidCallback? onSwitchMode;

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final _phoneFieldKey = GlobalKey<InternationalPhoneInputState>();
  bool isPhoneNumberValid = false;
  bool _isSendingChallenge = false;
  String phoneNumber = '';

  Future<void> _openOtpDialog() async {
    if (!isPhoneNumberValid || phoneNumber.isEmpty || _isSendingChallenge) {
      return;
    }
    FocusScope.of(context).unfocus();

    // Choix manuel du canal (WhatsApp / SMS) désactivé : on envoie directement
    // avec `channelPreference: "AUTO"` (le dialog de choix reste codé et
    // commenté dans `login_otp_dialog.dart`).
    setState(() => _isSendingChallenge = true);
    try {
      final formattedPhone = PhoneNumberHandler.formatPhoneNumber(phoneNumber);
      final challenge =
          await context.read<LoginCubit>().createPhoneChallenge(
                phoneNumber: formattedPhone,
                channelPreference: OtpChannelPreference.auto,
              );
      if (!mounted) return;
      setState(() => _isSendingChallenge = false);

      await showLoginOtpDialog(
        context: context,
        phoneNumber: phoneNumber,
        initialChallenge: challenge,
      );
    } catch (e) {
      if (mounted) setState(() => _isSendingChallenge = false);
      ErrorFeedback.present(
        AppErrorMapper.from(e),
        context: ErrorContext.authentication,
        retry: _openOtpDialog,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Contenu du formulaire qui prend tout l'espace disponible
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(24),
                Text(
                  "Indiquez votre numéro",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.immoTextPrimary,
                      ),
                  textAlign: TextAlign.left,
                ),
                const Gap(16),
                Text(
                  "Nous vous enverrons un code pour vérifier votre téléphone",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.immoTextDisabled,
                      ),
                  textAlign: TextAlign.left,
                ),
                const Gap(30),
                SizedBox(
                  height: 80,
                  child: InternationalPhoneInput(
                    key: _phoneFieldKey,
                    backgroundColor: AppColors.transparent,
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
              ],
            ),
          ),
        ),

        // Bouton "Envoyer le code" épinglé en pied de page
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: CustomLoadingButtom(
            text: "Envoyer le code",
            onClick: _openOtpDialog,
            isLoading: _isSendingChallenge,
            clickable:
                isPhoneNumberValid && phoneNumber.isNotEmpty && !_isSendingChallenge,
            color: isPhoneNumberValid ? AppColors.primary : AppColors.blueGrey,
          ),
        ),
      ],
    );
  }
}
