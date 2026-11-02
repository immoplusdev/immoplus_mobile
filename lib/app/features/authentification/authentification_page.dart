import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/auth_redirect_service.dart';
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/otp_login/pages/phone_number_page.dart';
import 'package:immoplus/app/widgets/config_env.dart';

class AuthenticationPage extends StatefulWidget {
  final AuthRedirectData? redirectData;
  const AuthenticationPage({super.key, this.redirectData});
  static String name = "AUTHENTICATION_PAGE";

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  void initState() {
    super.initState();
    if (widget.redirectData != null) {
      getIt<AuthRedirectService>().set(widget.redirectData);
    }
  }

  @override
  void dispose() {
    getIt<AuthRedirectService>().clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // La connexion et l'inscription sont désormais unifiées via le numéro de
    // téléphone : on affiche directement l'écran de saisie du numéro sans
    // l'écran intermédiaire "Connexion / Inscrivez-vous".
    return EnvironmentsBadge(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leadingWidth: 64,
          leading: context.canPop()
              ? Padding(
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
                )
              : null,
        ),
        body: const SafeArea(
          child: PhoneNumberPage(),
        ),
      ),
    );
  }
}
