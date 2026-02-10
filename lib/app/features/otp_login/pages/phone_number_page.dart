import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/models/auth/send_opt_model.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/features/otp_login/otp_login_page.dart';
import 'package:immoplus/app/features/otp_login/pages/otp_page_test.dart';
import 'package:immoplus/app/features/reset_password/pages/reset_password_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';
import 'package:immoplus/app/utils/status_code_handler.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';
import 'package:immoplus/app/widgets/international_phone_number_input.dart';
import 'package:immoplus/app/widgets/social_button_widget.dart';

class PhoneNumberPage extends StatefulWidget {
  final PageController pageController;

  const PhoneNumberPage({
    super.key,
    required this.pageController,
    required this.onSwitchMode,
  });
  final VoidCallback onSwitchMode;
  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  bool isPhoneNumberValid = false;
  String phoneNumber = '';
  bool _isLoading = false;
  void onInputValidated(bool isValid) {
    setState(() {
      isPhoneNumberValid = isValid;
    });
  }

  Future<void> _sendOtpCode() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await AuthRepository().sendOtp(
        body: SendOptModel(
          phoneNumber: PhoneNumberHandler.formatPhoneNumber(phoneNumber),
        ),
      );

      if (!mounted) return;

      if (StatusCodeHandler.isSuccess(response.response.statusCode)) {
        context.pushNamed(OtpPageTest.name, extra: phoneNumber);
      } else {
        CustomPopup.showErrorToast(
          text: 'Envoi du code échoué, veuillez ressayer',
        );
      }
    } catch (e) {
      if (!mounted) return;
      CustomPopup.toast(
        color: Colors.red,
        toastPosition: EasyLoadingToastPosition.bottom,
        text: "Envoi de OTP code échoué, veuillez réessayer",
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(50),
          //const SizedBox(height: 20),
          SizedBox(
            height: 80,
            child: InternationalPhoneInput(
              backgroundColor: Colors.transparent,
              onValidPhoneNumber: (value) {
                phoneNumber = value;
                OTPState.phoneNumber = phoneNumber;
              },
              onInputValidated: onInputValidated,
            ),
          ),
          const Gap(10),

          CustomLoadingButtom(
            text: "Envoyer le code",
            onClick: _sendOtpCode,
            isLoading: _isLoading,
            clickable: isPhoneNumberValid && phoneNumber.isNotEmpty,
            color: isPhoneNumberValid
                ? AppColors.primary
                : Colors.blueGrey.shade200,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => ResetPassword(),
                    //     ));
                    context.pushNamed(ResetPasswordPage.name);
                  },
                  child: Text(
                    'Mot de passe oublié',
                    style: GoogleFonts.inter(color: AppColors.primary),
                  )),
              // TextButton(
              //     onPressed: () {
              //       context.pushNamed(SendEmailOptPage.name);
              //     },
              //     child: Text(
              //       'S\'inscrire',
              //       style: GoogleFonts.inter(color: AppColors.primary),
              //     )),
            ],
          ),
          const Row(
            children: [
              Flexible(
                child: SizedBox(
                  width: 200,
                  child: Divider(
                    thickness: 1,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('ou'),
              ),
              Flexible(
                  child: SizedBox(
                      child: Divider(
                thickness: 1,
              ))),
            ],
          ),

          const Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SocialLoginButtons(
              mode: LoginMode.phone,
              onSwitchMode: widget.onSwitchMode,
            ),
          ),
        ],
      ),
    );
  }
}
