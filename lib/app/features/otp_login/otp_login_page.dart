import 'package:flutter/material.dart';
import 'package:immoplus/app/features/otp_login/pages/phone_number_page.dart';

class OTPState {
  static String phoneNumber = '';
}

class OTPLoginPage extends StatefulWidget {
  const OTPLoginPage({super.key, required this.onSwitchMode});
  static String name = 'OTP_LOGIN';
  final VoidCallback onSwitchMode;
  @override
  _OTPLoginPageState createState() => _OTPLoginPageState();
}

class _OTPLoginPageState extends State<OTPLoginPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PhoneNumberPage(
      onSwitchMode: widget.onSwitchMode,
      pageController: _pageController,
    );
  }
}
