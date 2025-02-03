import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/features/login_page/pages/login_with_email_screen.dart';
import 'package:immoplus/app/features/otp_login/otp_login_page.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String name = "LOGIN_PAGE";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: Scaffold(
        backgroundColor: HexColor("#121224"),

        body: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          //padding: const EdgeInsets.only(left: 15, right: 15),
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: HexColor("#121224"),
              leadingWidth: 35,
              // leading: Padding(
              //   padding: const EdgeInsets.only(left: 5),
              //   child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //           fixedSize: const Size(40, 40),
              //           shape: const CircleBorder(),
              //           padding: const EdgeInsets.all(3),
              //           backgroundColor: Colors.white,
              //           foregroundColor: Colors.white),
              //       onPressed: () {
              //         if (context.canPop()) {
              //           context.pop();
              //         }
              //       },
              //       child: const Icon(
              //         FontAwesomeIcons.chevronLeft,
              //         color: Colors.black,
              //       )),
              // ),
              actions: [
                SvgPicture.asset(
                  'assets/icons/logo_immo.svg',
                  color: HexColor('#2072ca'),
                  width: 50,
                ),
                const Gap(20),
              ],
            ),
            const SliverGap(30),
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  "Connexion",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            const SliverGap(8),
            SliverPadding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: AutoSizeText(
                    maxLines: 1,
                    "Inscrivez-vous si vous n'avez pas de compte",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SliverGap(50),
            SliverFillRemaining(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: PageView(
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    OTPLoginPage(
                      rootPageController: pageController,
                    ),
                    LoginWithEmailScreen(
                      rootPageController: pageController,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),

        // bottomNavigationBar: const SizedBox(

        //     height: 50,
        //     child: Center(
        //       child: Text(
        //         '©AfriqueSolus',
        //         style: TextStyle(color: Color.fromARGB(255, 182, 181, 181)),
        //       ),
        //     )),
      ),
    );
  }
}
