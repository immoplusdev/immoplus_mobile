import 'package:flutter/material.dart';
import 'package:immoplus/app/features/otp_login/pages/otp_page.dart';
import 'package:immoplus/app/features/otp_login/pages/otp_page_test.dart';
import 'package:immoplus/app/features/otp_login/pages/phone_number_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class OTPState {
  static String phoneNumber = '';
}

class OTPLoginPage extends StatefulWidget {
  const OTPLoginPage({super.key, required this.rootPageController});
  static String name = 'OTP_LOGIN';
  final PageController rootPageController;
  @override
  _OTPLoginPageState createState() => _OTPLoginPageState();
}

class _OTPLoginPageState extends State<OTPLoginPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PhoneNumberPage(
      rootPageController: widget.rootPageController,
      pageController: _pageController,
    );
    // PageView(
    //   controller: _pageController,

    // physics:
    //     const NeverScrollableScrollPhysics(), // Empêche de swiper manuellement
    // children: [
    //   PhoneNumberPage(
    //     rootPageController: widget.rootPageController,
    //     pageController: _pageController,
    // ),
    // OTPPage(
    //   pageController: _pageController,
    // ),

    //     OtpPageTest()
    //   ],
    // );
  }
}
