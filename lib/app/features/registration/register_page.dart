import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
import 'package:immoplus/app/features/registration/screens/send_email_opt_page.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_page_immo.dart';
import 'package:immoplus/gen/assets.gen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.redirectData});
  final AuthRedirectData? redirectData;

  static String name = "REGISTER_PAGE";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late PageController _pageController;
  late ValueNotifier<int> _currentPageNotifier;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPageNotifier = ValueNotifier<int>(0);

    // Écouter les changements de page
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (_currentPageNotifier.value != page) {
        _currentPageNotifier.value = page;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageImmo(
      title: "Création de compte",
      content: Container(
        padding: const EdgeInsets.all(appPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("S'inscrire avec",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
              const Gap(10),
              AuthButton(
                icon: const Icon(
                  Icons.email_outlined,
                  color: Colors.blue,
                  size: 24,
                ),
                label: "Adresse e-mail",
                borderColor: AppColors.color65BAF0,
                onTap: () {
                  context.pushNamed(SendEmailOptPage.name);
                },
              ),
              const Gap(16),
              // Bouton Google
              AuthButton(
                icon: SvgPicture.asset(Assets.svgs.icons.google),
                label: "Google",
                onTap: () {
                  context.read<LoginCubit>().signInWithGoogle();
                },
              ),
              const Gap(16),
              // Bouton Apple (iOS uniquement)
              if (Platform.isIOS)
                AuthButton(
                  icon: const Icon(
                    Icons.apple,
                    color: Colors.black,
                    size: 24,
                  ),
                  label: "Apple",
                  onTap: () => context.read<LoginCubit>().signInWithApple(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.iconSize = 24,
  });

  final Widget icon; // Icon ou Image
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.ECECEC,
          borderRadius: BorderRadius.circular(30),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Row(
          children: [
            Gap(20),

            SizedBox(
              width: iconSize,
              height: iconSize,
              child: icon,
            ),
            Gap(10),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.black87,
                ),
              ),
            ),
            SizedBox(width: 20 + iconSize), // Pour centrer le texte
          ],
        ),
      ),
    );
  }
}
