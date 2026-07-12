import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/features/otp_login/widgets/login_otp_dialog.dart';
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
  String phoneNumber = '';

  Future<void> _openOtpDialog() async {
    if (!isPhoneNumberValid || phoneNumber.isEmpty) return;
    FocusScope.of(context).unfocus();
    await showLoginOtpDialog(context: context, phoneNumber: phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                        color: const Color(0xFF1F1F1F),
                      ),
                  textAlign: TextAlign.left,
                ),

                const Gap(16),

                Text(
                  "Nous vous enverrons un code pour vérifier votre téléphone",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFA3A3A3),
                      ),
                  textAlign: TextAlign.left,
                ),

                const Gap(30),

                SizedBox(
                  height: 80,
                  child: InternationalPhoneInput(
                    key: _phoneFieldKey,
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
            isLoading: false,
            clickable: isPhoneNumberValid && phoneNumber.isNotEmpty,
            color: isPhoneNumberValid
                ? const Color(0xFF2744DE)
                : Colors.blueGrey.shade200,
          ),
        ),
      ],
    );
  }
}
