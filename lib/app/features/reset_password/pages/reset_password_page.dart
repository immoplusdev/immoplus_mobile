import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/reset_password/cubit/reset_password_cubit.dart';
import 'package:immoplus/app/features/reset_password/pages/email_input_page.dart';
import 'package:immoplus/app/features/reset_password/pages/new_password_page.dart';
import 'package:immoplus/app/features/reset_password/pages/otp_verification_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});
  static String name = "RESET_PASSWORD_PAGE";

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
              color: AppColors.whiteBackground,
              onPressed: () {
                _pageController.page == 0
                    ? context.pop()
                    : _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
              }),
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.scaffoldBackgroundColor,
          title: Text("Réinitialisation",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.white,
                  )),
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            EmailInputPage(pageController: _pageController),
            OtpVerificationPage(pageController: _pageController),
            NewPasswordPage(pageController: _pageController),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
