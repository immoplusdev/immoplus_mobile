import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/features/reset_password/cubit/reset_password_cubit.dart';
import 'package:immoplus/app/features/reset_password/cubit/reset_password_cubit_state.dart';
import 'package:immoplus/app/features/reset_password/widgets/header_container.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';

import 'package:pinput/pinput.dart';

const _timerDuration = 30;

class OtpVerificationPage extends StatefulWidget {
  final PageController pageController;

  const OtpVerificationPage({super.key, required this.pageController});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpComplete = false;
  final _otpLength = 6;

  Timer? _resendTimer;
  int _resendCountdown = 0;
  bool get _canResendCode => _resendCountdown == 0;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() {
      final isComplete = _otpController.text.length == _otpLength;
      if (_isOtpComplete != isComplete) {
        setState(() {
          _isOtpComplete = isComplete;
        });
      }
    });
  }

  void _startResendTimer() {
    setState(() {
      _resendCountdown = _timerDuration;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _resendCountdown--;
      });

      if (_resendCountdown == 0) {
        timer.cancel();
      }
    });
  }

  void _resendOtp() {
    if (!_canResendCode) return;

    final cubit = context.read<ResetPasswordCubit>();
    if (cubit.currentEmail != null) {
      cubit.sendEmailOtp(email: cubit.currentEmail!);
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocBuilder<ResetPasswordCubit, ResetPasswordCubitState>(
            builder: (context, state) {
              final email =
                  context.read<ResetPasswordCubit>().currentEmail ?? "";
              return HeaderContainer(
                iconData: FontAwesomeIcons.shieldHalved.data,
                title: "Entrez le code de vérification reçu",
                subtitle: "Code envoyé à $email",
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Gap(50),
                Pinput(
                  controller: _otpController,
                  length: _otpLength,
                  defaultPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightBlue, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const Gap(30),
                BlocConsumer<ResetPasswordCubit, ResetPasswordCubitState>(
                  listener: (context, state) {
                    state.when(
                      initial: () {},
                      sendingEmailOtp: () {},
                      emailOtpSent: (message) {},
                      verifyingEmail: () {},
                      emailVerified: () {
                        widget.pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      resettingPassword: () {},
                      passwordResetSuccess: (message) {},
                      error: (errorMessage) {
                        _otpController.clear();
                      },
                    );
                  },
                  builder: (context, state) {
                    return CustomLoadingButtom(
                      isLoading: state.maybeWhen(
                        verifyingEmail: () => true,
                        orElse: () => false,
                      ),
                      clickable: _isOtpComplete,
                      onClick: _isOtpComplete
                          ? () {
                              context
                                  .read<ResetPasswordCubit>()
                                  .verifyEmailOtp(otp: _otpController.text);
                            }
                          : null,
                      text: "Continuer",
                    );
                  },
                ),
                const Gap(20),
                BlocBuilder<ResetPasswordCubit, ResetPasswordCubitState>(
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(
                      sendingEmailOtp: () => true,
                      orElse: () => false,
                    );

                    return TextButton(
                      onPressed:
                          _canResendCode && !isLoading ? _resendOtp : null,
                      child: Text(
                        _canResendCode
                            ? "Renvoyer le code"
                            : "Renvoyer le code ($_resendCountdown s)",
                        style: TextStyle(
                          color: _canResendCode && !isLoading
                              ? AppColors.lightBlue
                              : Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }
}
