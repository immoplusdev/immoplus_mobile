import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';

enum LoginMode {
  phone,
  email,
}

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({
    super.key,
    required this.mode,
    this.onSwitchMode,
  });

  final LoginMode mode;
  final VoidCallback? onSwitchMode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bouton de switch (PIN ou @)
          _buildSwitchButton(),

          // Bouton Facebook
          // _SocialButton(
          //   backgroundColor: HexColor("#0866FF"),
          //   onPressed: () {
          //     context.read<LoginCubit>().signInWithFacebook();
          //   },
          //   child: SvgPicture.asset('assets/svgs/icons/facebook.svg'),
          // ),

          // Bouton Google
          _SocialButton(
            backgroundColor: Colors.white,
            onPressed: () {
              context.read<LoginCubit>().signInWithGoogle();
            },
            child: SvgPicture.asset(
              'assets/svgs/icons/google.svg',
              width: 30,
            ),
          ),

          // Bouton Apple
          if (Platform.isIOS)
            _SocialButton(
              backgroundColor: Colors.black,
              onPressed: () => context.read<LoginCubit>().signInWithApple(),
              child: Center(
                child: const FaIcon(
                  FontAwesomeIcons.apple,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Construit le bouton de switch selon le mode actuel
  Widget _buildSwitchButton() {
    switch (mode) {
      case LoginMode.phone:
        // Sur la page téléphone, affiche le bouton @ (vers email)
        return _SocialButton(
          backgroundColor: Colors.blue,
          onPressed: onSwitchMode,
          child: const FaIcon(
            FontAwesomeIcons.at,
            color: CupertinoColors.white,
            size: 40,
          ),
        );

      case LoginMode.email:
        // Sur la page email, affiche le bouton PIN (vers téléphone)
        return _SocialButton(
          backgroundColor: Colors.blueGrey,
          onPressed: onSwitchMode,
          child: const Icon(
            Icons.pin,
            color: CupertinoColors.white,
            size: 40,
          ),
        );
    }
  }
}

/// Widget interne pour un bouton social
class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.backgroundColor,
    required this.onPressed,
    required this.child,
  });

  final Color backgroundColor;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(50, 50),
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(3),
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
