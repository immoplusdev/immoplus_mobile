import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
import 'package:immoplus/app/features/otp_login/pages/phone_number_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class LoginPage extends StatelessWidget {
  final AuthRedirectData? redirectData;
  const LoginPage({super.key, this.redirectData});
  static String name = "LOGIN_PAGE";

  static String routePath() => '/login_page';

  @override
  Widget build(BuildContext context) {
    // Email, réseaux sociaux et mot de passe oublié sont désactivés :
    // seule la connexion par numéro de téléphone est proposée.
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
      body: const SafeArea(
        child: PhoneNumberPage(),
      ),
    );
  }
}
