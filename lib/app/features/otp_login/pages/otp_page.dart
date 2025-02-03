import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/auth/login_otp_body.dart';
import 'package:immoplus/app/data/models/auth/send_opt_model.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/features/otp_login/otp_login_page.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/login_cubit_state.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';
import 'package:immoplus/app/utils/status_code_handler.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> with CodeAutoFill {
  String otpCode = '';
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _listenForCode();
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  void _listenForCode() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  @override
  void codeUpdated() {
    SmsAutoFill().code.listen((code) {
      setState(() {
        otpCode = code;
        isValid = otpCode.length == 6;
      });
    });
  }

  void validateOTP(String pin) {
    setState(() {
      otpCode = pin;
      isValid = otpCode.length == 6;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    widget.pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(FontAwesomeIcons.circleChevronLeft),
                ),
                const Gap(30),
                const Text(
                  'Entrez le code OTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Gap(80),
            AutoSizeText(
              'Entrer le code de 6 chiffres envoyé au numéro de ${OTPState.phoneNumber}',
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            PinFieldAutoFill(
              autoFocus: true,
              decoration: BoxLooseDecoration(
                strokeColorBuilder: const FixedColorBuilder(Colors.blue),
                bgColorBuilder: const FixedColorBuilder(Colors.white),
                radius: const Radius.circular(10.0),
                gapSpace: 10.0,
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              codeLength: 6,
              currentCode: otpCode, // Gardez le code dans le champ
              onCodeChanged: (code) {
                if (code != null && code.length <= 6) {
                  setState(() {
                    otpCode = code;
                    isValid = otpCode.length == 6;
                  });
                }
              },
              onCodeSubmitted: (code) {
                // Facultatif : utilisez cette méthode si vous souhaitez valider automatiquement le code après 6 chiffres
                if (code.length == 6) {
                  print("Code soumis : $code");
                }
              },
            ),
            const SizedBox(height: 20),
            BlocBuilder<LoginCubit, LoginCubitState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: (state is LOGIN_LOADING)
                      ? null
                      : isValid
                          ? () {
                              print(otpCode);
                              context.read<LoginCubit>().onSendOtpData(
                                    body: LoginOtpBody(
                                      phoneNumber:
                                          PhoneNumberHandler.formatPhoneNumber(
                                              OTPState.phoneNumber),
                                      otp: otpCode,
                                    ),
                                  );
                            }
                          : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: (state is LOGIN_LOADING)
                      ? const CupertinoActivityIndicator()
                      : const Text(
                          'Valider OTP',
                          style: TextStyle(fontSize: 18),
                        ),
                );
              },
            ),
            const Gap(10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Vous n'avez pas reçu le code ? ",
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Renvoyer',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        try {
                          final response = await AuthRepository().sendOtp(
                            body: SendOptModel(
                              phoneNumber: PhoneNumberHandler.formatPhoneNumber(
                                OTPState.phoneNumber,
                              ),
                            ),
                          );
                          if (StatusCodeHandler.isSuccess(
                              response.response.statusCode)) {
                            FocusScope.of(context).unfocus();
                          } else {
                            CustomPopup.showErrorToast(
                              text: 'Envoi du code échoué, veuillez ressayer',
                            );
                          }
                        } catch (e) {
                          CustomPopup.toast(
                            color: Colors.red,
                            toastPosition: EasyLoadingToastPosition.bottom,
                            text:
                                "Envoi de OTP code échoué, veuillez réessayer",
                          );
                        }
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
