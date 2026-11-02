import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/otp_login/pages/phone_number_page.dart';

class RegisterNumberOtpPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
      body: const SafeArea(
        child: PhoneNumberPage(),
      ),
    );
  }
}
