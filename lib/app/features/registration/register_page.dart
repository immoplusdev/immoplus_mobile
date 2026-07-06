import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
import 'package:immoplus/app/features/registration/screens/register_number_otp.dart';

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
    // Email, Google et Apple sont désactivés : on va directement
    // sur l'inscription par numéro de téléphone.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.pushReplacementNamed(
        RegisterNumberOtpPage.name,
        extra: widget.redirectData,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white);
  }
}
