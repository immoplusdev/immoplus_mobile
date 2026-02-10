import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/features/login_page/pages/login_with_email_screen.dart';
import 'package:immoplus/app/features/otp_login/otp_login_page.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_page_immo.dart';
import 'package:immoplus/app/widgets/custom_tab_selector.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String name = "LOGIN_PAGE";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  PageController _pageController = PageController();
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

  void _onTabSelected(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: CustomPageImmo(
        title: "Se connecter",
        content: Container(
          padding: const EdgeInsets.all(appPadding),
          child: Column(
            children: [
              ValueListenableBuilder<int>(
                valueListenable: _currentPageNotifier,
                builder: (context, currentPage, child) {
                  return CustomTabSelector(
                    selectedIndex: currentPage,
                    tabs: const ['E-mail', 'Numero'],
                    onTabSelected: _onTabSelected,
                    selectedColor: AppColors.lightBlue,
                  );
                },
              ),
              const Gap(20),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      LoginWithEmailScreen(
                        onSwitchMode: () => _onTabSelected(1),
                      ),
                      OTPLoginPage(
                        onSwitchMode: () => _onTabSelected(0),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
