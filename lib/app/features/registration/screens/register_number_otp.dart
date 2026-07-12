import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
import 'package:immoplus/app/features/registration/customer_registration.dart';
import 'package:immoplus/app/features/registration/widgets/otp_verification_dialog.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/international_phone_number_input.dart';

class RegisterNumberOtpPage extends StatefulWidget {
  const RegisterNumberOtpPage({
    super.key,
    this.redirectData,
    this.onSuccess,
  });

  final AuthRedirectData? redirectData;
  final void Function()? onSuccess;

  static const String name = "REGISTER_NUMBER_OTP";
  static String routePath() => '/register-number-otp';

  @override
  State<RegisterNumberOtpPage> createState() => _RegisterNumberOtpPageState();
}

class _RegisterNumberOtpPageState extends State<RegisterNumberOtpPage> {
  final _phoneFieldKey = GlobalKey<InternationalPhoneInputState>();
  bool isPhoneNumberValid = false;
  String phoneNumber = '';

  Future<void> _sendOtpCode() async {
    final isValid = _phoneFieldKey.currentState?.validate() ?? false;
    if (!isValid || phoneNumber.isEmpty) return;
    FocusScope.of(context).unfocus();

    final formattedPhone = PhoneNumberHandler.formatPhoneNumber(phoneNumber);

    await showOtpVerificationDialog(
      context: context,
      phoneNumber: formattedPhone,
      onVerified: (resp) {
        context.pushReplacementNamed(
          CustomerRegistration.name,
          extra: DataRouterRegistration(
            email: resp.data.email,
            token: resp.data.token.toString(),
            phoneNumber: formattedPhone,
          ),
        );
        widget.onSuccess?.call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<RgistrationCubitCubit, RegistrationCubitState>(
          builder: (context, state) {
            final isLoading = state is REGISTRATION_LOADING;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Gap(24),

                        Text(
                          "Indiquez votre numéro",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF1F1F1F),
                              ),
                          textAlign: TextAlign.left,
                        ),

                        const Gap(16),

                        Text(
                          "Nous vous enverrons un code pour vérifier votre téléphone",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
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

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: CustomLoadingButtom(
                    text: "Envoyer le code",
                    onClick: _sendOtpCode,
                    isLoading: isLoading,
                    clickable: isPhoneNumberValid && phoneNumber.isNotEmpty,
                    color: isPhoneNumberValid
                        ? const Color(0xFF2744DE)
                        : Colors.blueGrey.shade200,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
