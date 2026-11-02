import 'package:immoplus/app/design_system/tokens/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
import 'package:immoplus/app/features/login_page/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.redirectData});
  final AuthRedirectData? redirectData;

  static String name = "REGISTER_PAGE";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
    // Connexion et inscription sont désormais unifiées via le challenge OTP téléphone.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.pushReplacementNamed(
        LoginPage.name,
        extra: widget.redirectData,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: AppColors.white);
  }
}
