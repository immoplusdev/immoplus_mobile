import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/network/utils/easy_loading_handler.dart';
import 'package:immoplus/app/data/enums/account_source.dart';
import 'package:immoplus/app/data/models/auth/login_otp_body.dart';
import 'package:immoplus/app/data/models/auth/send_opt_model.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/features/otp_login/otp_login_page.dart';
import 'package:immoplus/app/features/otp_login/pages/sms_retriever_impl.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/login_cubit_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';
import 'package:immoplus/app/utils/status_code_handler.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

class OtpPageTest extends StatefulWidget {
  const OtpPageTest({super.key, this.currentPhoneNumber = '+2250701710065'});
  final String currentPhoneNumber;
  static String name = 'OTP__CONFIRM_LOGIN';

  @override
  State<OtpPageTest> createState() => _OtpPageTestState();
}

class _OtpPageTestState extends State<OtpPageTest> {
  late final SmsRetriever smsRetriever;
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
    smsRetriever = SmsRetrieverImpl(SmartAuth.instance);
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fillColor = Color.fromRGBO(243, 246, 249, 0);

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.poppins(
        fontSize: 20,
        color: const Color.fromRGBO(70, 69, 66, 1),
      ),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        borderRadius: BorderRadius.circular(24),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.scafold,
      appBar: AppBar(
        backgroundColor: AppColors.scafold,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                maxLines: 1,
                'Vérification',
                style: context.textTheme.headlineLarge!
                    .copyWith(color: const Color.fromRGBO(30, 60, 87, 1)),
              ),
              //color: const Color.fromRGBO(30, 60, 87, 1)
              const SizedBox(height: 30),
              AutoSizeText(
                maxLines: 1,
                'Entrez le code envoyé au numéro',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color.fromRGBO(133, 153, 170, 1),
                ),
              ),
              const SizedBox(height: 16),
              AutoSizeText(
                maxLines: 1,
                widget.currentPhoneNumber,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color.fromRGBO(30, 60, 87, 1),
                ),
              ),
              Gap(20),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: 6,
                  smsRetriever: smsRetriever,
                  controller: pinController,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  separatorBuilder: (index) => const SizedBox(width: 5),
                  pinputAutovalidateMode: PinputAutovalidateMode
                      .onSubmit, // Force la validation en temps réel
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un code PIN';
                    }
                    if (value.length < 6) {
                      log(value.toString(), name: 'Valeur');
                      return 'Le code doit être composé de 6 chiffres';
                    }
                    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                      return 'Le code doit être composé de 6 chiffres';
                    }
                    return null; // Le code est valide
                  },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) {
                    debugPrint('Code saisi: $pin');
                  },
                  onChanged: (value) {
                    debugPrint('Modification: $value');
                  },
                  onSubmitted: (value) {
                    print('cumit');
                  },
                  showCursor: true,
                  cursor: cursor,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.06),
                          offset: Offset(0, 3),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: AppColors.primary),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border.all(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
              Gap(20),
              Text(
                'Vous n’avez pas reçu le code ?',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color.fromRGBO(62, 116, 165, 1),
                ),
              ),
              TextButton(
                onPressed: () async {
                  EasyLoadingHandler.showLoagingToast(text: 'En cours...');
                  try {
                    final response = await AuthRepository().sendOtp(
                      body: SendOptModel(
                        phoneNumber: PhoneNumberHandler.formatPhoneNumber(
                          widget.currentPhoneNumber,
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
                      text: "Envoi de OTP code échoué, veuillez réessayer",
                    );
                  } finally {
                    EasyLoading.dismiss();
                  }
                },
                child: Text(
                  'Renvoyer',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: const Color.fromRGBO(62, 116, 165, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 20),
        color: AppColors.scafold,
        width: double.infinity,
        child: BlocBuilder<LoginCubit, LoginCubitState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: (state is LOGIN_LOADING)
                  ? null
                  : () {
                      log(pinController.text);
                      if (formKey.currentState!.validate()) {
                        focusNode.unfocus();
                        context.read<LoginCubit>().onSendOtpData(
                              body: LoginOtpBody(
                                phoneNumber:
                                    PhoneNumberHandler.formatPhoneNumber(
                                        widget.currentPhoneNumber),
                                otp: pinController.text,
                                source: AccountSource.customerApp.value,
                              ),
                            );
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
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
      ),
    );
  }
}
