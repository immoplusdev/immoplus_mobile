import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus/app/data/models/auth/send_opt_model.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/features/otp_login/otp_login_page.dart';
import 'package:immoplus/app/features/otp_login/pages/otp_page_test.dart';
import 'package:immoplus/app/features/registration/customer_registration.dart';
import 'package:immoplus/app/features/reset_password/pages/reset_password_page.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/login_cubit_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';
import 'package:immoplus/app/utils/status_code_handler.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';
import 'package:immoplus/app/widgets/international_phone_number_input.dart';

class PhoneNumberPage extends StatefulWidget {
  final PageController pageController;

  const PhoneNumberPage({
    super.key,
    required this.pageController,
    required this.rootPageController,
  });
  final PageController rootPageController;
  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  bool isPhoneNumberValid = false;
  String phoneNumber = '';
  void onInputValidated(bool isValid) {
    setState(() {
      isPhoneNumberValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: AppColors.primaryLite,
          borderRadius: BorderRadius.circular(30),
        ),
        // padding: const EdgeInsets.all(16.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(50),
            //const SizedBox(height: 20),
            SizedBox(
              height: 80,
              child: InternationalPhoneInput(
                backgroundColor: AppColors.primaryLite,
                onValidPhoneNumber: (value) {
                  phoneNumber = value;
                  OTPState.phoneNumber = phoneNumber;
                  // Le numéro valide est traité ici si nécessaire
                  // print(phoneNumber);
                },
                onInputValidated: onInputValidated,
              ),
            ),
            const Gap(10),

            BlocBuilder<LoginCubit, LoginCubitState>(
              builder: (context, state) {
                return EasyButton(
                  type: EasyButtonType.elevated,

                  // Content inside the button when the button state is idle.
                  idleStateWidget: Text(
                    'Envoyer Code'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  // Content inside of the button when the button state is loading.
                  loadingStateWidget: const CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                  useWidthAnimation: true,
                  useEqualLoadingStateWidgetDimension: true,
                  // If you want a fullwidth size, set this to double.infinity
                  width: double.infinity,
                  height: 55.0,
                  borderRadius: 20.0,
                  elevation: 0.0,
                  contentGap: 6.0,
                  buttonColor: isPhoneNumberValid
                      ? AppColors.primary
                      : Colors.blueGrey.shade200,

                  onPressed: phoneNumber.isNotEmpty
                      ? () async {
                          try {
                            final response = await AuthRepository().sendOtp(
                                body: SendOptModel(
                                    phoneNumber:
                                        PhoneNumberHandler.formatPhoneNumber(
                                            phoneNumber)));
                            if (StatusCodeHandler.isSuccess(
                                response.response.statusCode)) {
                              // FocusScope.of(context).unfocus();

                              // OTPState.phoneNumber = phoneNumber;
                              // widget.pageController.nextPage(
                              //   duration: const Duration(milliseconds: 300),
                              //   curve: Curves.easeInOut,
                              // );
                              context.pushNamed(OtpPageTest.name,
                                  extra: phoneNumber);
                            } else {
                              CustomPopup.showErrorToast(
                                  text:
                                      'Envoi du code échoué, veuillez ressayer');
                            }
                          } catch (e) {
                            CustomPopup.toast(
                                color: Colors.red,
                                toastPosition: EasyLoadingToastPosition.bottom,
                                text:
                                    "Envoi de OTP code échoué, veuillez réessayer");
                          }
                        }
                      : null,
                );
              },
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
                TextButton(
                    onPressed: () {
                      context.pushNamed(CustomerRegistration.name);
                    },
                    child: Text(
                      'S\'inscrire',
                      style: GoogleFonts.inter(color: AppColors.primary),
                    )),
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
              child: SizedBox(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(50, 50),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(3),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        widget.rootPageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Icon(
                        FontAwesomeIcons.at,
                        color: CupertinoColors.white,
                        size: 40,
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(3),
                            backgroundColor: HexColor("#0866FF"),
                            foregroundColor: Colors.white),
                        onPressed: () {
                          CustomPopup.toast(
                              text:
                                  "La connexion via Facebook n'est pas encore disponible pour le moment, mais elle le sera très bientôt.",
                              toastPosition: EasyLoadingToastPosition.bottom,
                              color: AppColors.primary);
                        },
                        child:
                            SvgPicture.asset('assets/svgs/icons/facebook.svg')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(3),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          CustomPopup.toast(
                              text:
                                  "La connexion via Google n'est pas encore disponible pour le moment, mais elle le sera très bientôt.",
                              toastPosition: EasyLoadingToastPosition.bottom,
                              color: AppColors.primary);
                        },
                        child: SvgPicture.asset(
                          'assets/svgs/icons/google.svg',
                          width: 70,
                        )),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(50, 50),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(3),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        CustomPopup.toast(
                            text:
                                "La connexion via Apple n'est pas encore disponible pour le moment, mais elle le sera très bientôt.",
                            toastPosition: EasyLoadingToastPosition.bottom,
                            color: AppColors.primary);
                      },
                      child: const Icon(
                        FontAwesomeIcons.apple,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
